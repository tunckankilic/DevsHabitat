import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:devshabitat/app/models/message_model.dart';
import 'package:devshabitat/app/services/image_upload_service.dart';

class BackgroundSyncService extends GetxService {
  final _syncQueue = <MessageModel>[].obs;
  final _isSyncing = false.obs;
  final _networkStatus = Rx<ConnectivityResult>(ConnectivityResult.none);
  final _syncStatus = ''.obs;
  final _batteryOptimized = true.obs;

  Timer? _cleanupTimer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  final _retryAttempts = 3;
  final _retryDelay = const Duration(seconds: 5);

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _startNetworkMonitoring();
    _startPeriodicCleanup();
  }

  void _startPeriodicCleanup() {
    _cleanupTimer = Timer.periodic(const Duration(minutes: 30), (_) {
      _cleanupResources();
    });
  }

  void _cleanupResources() {
    // Önbellek temizleme
    _syncQueue.removeWhere((message) {
      final age = DateTime.now().difference(message.timestamp);
      return age > const Duration(hours: 24);
    });

    // Gereksiz kaynakları serbest bırak
    Get.find<ImageUploadService>().clearCache();
  }

  Future<void> _initConnectivity() async {
    try {
      final results = await Connectivity().checkConnectivity();
      if (results.isNotEmpty) {
        _networkStatus.value = results.first;
      }
    } catch (e) {
      print('Bağlantı durumu kontrol edilemedi: $e');
    }
  }

  void _startNetworkMonitoring() {
    _connectivitySubscription?.cancel();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((results) {
      if (results.isNotEmpty) {
        _networkStatus.value = results.first;
        if (results.first != ConnectivityResult.none) {
          _processSyncQueue();
        }
      }
    });
  }

  Future<void> addToSyncQueue(MessageModel message) async {
    _syncQueue.add(message);
    _updateSyncStatus(
        'Senkronizasyon kuyruğuna eklendi: ${_syncQueue.length} öğe');

    if (_networkStatus.value != ConnectivityResult.none && !_isSyncing.value) {
      await _processSyncQueue();
    }
  }

  Future<void> _processSyncQueue() async {
    if (_syncQueue.isEmpty || _isSyncing.value) return;

    _isSyncing.value = true;
    _updateSyncStatus('Senkronizasyon başlatılıyor...');

    try {
      final messagesToProcess = List<MessageModel>.from(_syncQueue);
      for (var message in messagesToProcess) {
        bool synced = false;
        int attempts = 0;

        while (!synced && attempts < _retryAttempts) {
          try {
            await _syncMessage(message);
            synced = true;
            _syncQueue.remove(message);
          } catch (e) {
            attempts++;
            if (attempts < _retryAttempts) {
              _updateSyncStatus('Yeniden deneme $attempts/$_retryAttempts');
              await Future.delayed(_retryDelay);
            }
          }
        }
      }
    } finally {
      _isSyncing.value = false;
      _updateSyncStatus('Senkronizasyon tamamlandı');
    }
  }

  Future<void> _syncMessage(MessageModel message) async {
    // Sunucu ile senkronizasyon mantığı burada uygulanacak
    await Future.delayed(
        const Duration(seconds: 1)); // Simüle edilmiş ağ gecikmesi
  }

  void _updateSyncStatus(String status) {
    _syncStatus.value = status;
  }

  void setBatteryOptimization(bool enabled) {
    _batteryOptimized.value = enabled;
    // Pil optimizasyonu ayarlarını uygula
  }

  String get syncStatus => _syncStatus.value;
  bool get isSyncing => _isSyncing.value;
  bool get hasPendingSync => _syncQueue.isNotEmpty;

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    _cleanupTimer?.cancel();
    _syncQueue.clear();
    super.onClose();
  }
}
