# Changelog

## [Unreleased]

### Fixed

- Firebase başlatma işlemi optimize edildi
  - Firebase'in iki farklı yerde başlatılması sorunu giderildi
  - Başlatma işlemi sadece `FirebaseService` üzerinden yapılacak şekilde düzenlendi
  - `DefaultFirebaseOptions` kullanılarak doğru yapılandırma seçenekleri eklendi
  - Bu değişiklik, uygulamanın daha tutarlı ve güvenilir çalışmasını sağlayacak

### Changed

- `lib/main.dart`: Gereksiz Firebase başlatma kodu kaldırıldı
- `lib/core/services/firebase_service.dart`: Firebase başlatma işlemi `DefaultFirebaseOptions` ile güncellendi
