import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';
import 'package:devshabitat/core/config/firebase/firebase_options.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final _logger = Logger();
  final _internetChecker = InternetConnectionChecker.createInstance();

  late final FirebaseAuth _auth;
  late final FirebaseFirestore _firestore;
  late final FirebaseStorage _storage;
  late final FirebaseMessaging _messaging;
  late final FirebaseAnalytics _analytics;

  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;
  FirebaseMessaging get messaging => _messaging;
  FirebaseAnalytics get analytics => _analytics;

  Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _storage = FirebaseStorage.instance;
      _messaging = FirebaseMessaging.instance;
      _analytics = FirebaseAnalytics.instance;

      // Firestore ayarları
      _firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      // FCM izinleri
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // FCM token'ı al
      final token = await _messaging.getToken();
      _logger.i('FCM Token: $token');

      // İnternet bağlantısı kontrolü
      _internetChecker.onStatusChange.listen((status) {
        _logger.i('İnternet bağlantısı durumu: $status');
      });
    } catch (e, stackTrace) {
      _logger.e('Firebase başlatma hatası: ${e.toString()}\n$stackTrace');
      rethrow;
    }
  }

  Future<bool> checkInternetConnection() async {
    return await _internetChecker.hasConnection;
  }
}
