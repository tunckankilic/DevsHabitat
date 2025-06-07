import 'package:dartz/dartz.dart';
import 'package:devshabitat/core/services/firebase_service.dart';
import 'package:devshabitat/features/auth/domain/entities/user.dart';
import 'package:devshabitat/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart' show OAuthCredential;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseService _firebaseService;
  final _logger = Logger();

  AuthRepositoryImpl(this._firebaseService);

  @override
  Future<Either<Exception, User>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential =
          await _firebaseService.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Kullanıcı bulunamadı');
      }

      final userDoc = await _firebaseService.firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('Kullanıcı profili bulunamadı');
      }

      return Right(User.fromJson(userDoc.data()!));
    } catch (e) {
      _logger.e('Email/şifre ile giriş hatası: ${e.toString()}');
      return Left(Exception('Giriş başarısız: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, User>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception('Google girişi iptal edildi');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseService.auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw Exception('Kullanıcı bulunamadı');
      }

      // Kullanıcı profili kontrolü ve oluşturma
      final userDoc = await _firebaseService.firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        final newUser = User(
          id: userCredential.user!.uid,
          email: userCredential.user!.email!,
          name: userCredential.user!.displayName ?? 'İsimsiz Kullanıcı',
          avatar: userCredential.user!.photoURL,
        );

        await _firebaseService.firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(newUser.toJson());

        return Right(newUser);
      }

      return Right(User.fromJson(userDoc.data()!));
    } catch (e) {
      _logger.e('Google ile giriş hatası: ${e.toString()}');
      return Left(Exception('Google girişi başarısız: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, User>> signInWithGithub() async {
    try {
      final provider = firebase_auth.GithubAuthProvider();
      final userCredential =
          await _firebaseService.auth.signInWithPopup(provider);

      if (userCredential.user == null) {
        throw Exception('Kullanıcı bulunamadı');
      }

      final userDoc = await _firebaseService.firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        final newUser = User(
          id: userCredential.user!.uid,
          email: userCredential.user!.email!,
          name: userCredential.user!.displayName ?? 'İsimsiz Kullanıcı',
          avatar: userCredential.user!.photoURL,
          githubUsername: userCredential.additionalUserInfo?.username,
          githubAvatarUrl: userCredential.user!.photoURL,
          githubId:
              userCredential.additionalUserInfo?.profile?['id']?.toString(),
          githubData: userCredential.additionalUserInfo?.profile ?? {},
        );

        await _firebaseService.firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(newUser.toJson());

        return Right(newUser);
      }

      return Right(User.fromJson(userDoc.data()!));
    } catch (e) {
      _logger.e('GitHub ile giriş hatası: ${e.toString()}');
      return Left(Exception('GitHub girişi başarısız: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, User>> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final userCredential =
          await _firebaseService.auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw Exception('Kullanıcı oluşturulamadı');
      }

      final newUser = User(
        id: userCredential.user!.uid,
        email: email,
        name: name,
      );

      await _firebaseService.firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toJson());

      return Right(newUser);
    } catch (e) {
      _logger.e('Kayıt hatası: ${e.toString()}');
      return Left(Exception('Kayıt başarısız: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, void>> signOut() async {
    try {
      await _firebaseService.auth.signOut();
      return const Right(null);
    } catch (e) {
      _logger.e('Çıkış hatası: ${e.toString()}');
      return Left(Exception('Çıkış başarısız: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, User?>> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseService.auth.currentUser;
      if (firebaseUser == null) {
        return const Right(null);
      }

      final userDoc = await _firebaseService.firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists) {
        return const Right(null);
      }

      return Right(User.fromJson(userDoc.data()!));
    } catch (e) {
      _logger.e('Mevcut kullanıcı alma hatası: ${e.toString()}');
      return Left(Exception('Kullanıcı bilgileri alınamadı: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, void>> updateUserProfile(User user) async {
    try {
      await _firebaseService.firestore
          .collection('users')
          .doc(user.id)
          .update(user.toJson());
      return const Right(null);
    } catch (e) {
      _logger.e('Profil güncelleme hatası: ${e.toString()}');
      return Left(Exception('Profil güncellenemedi: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, void>> updateUserPreferences(
      Map<String, dynamic> preferences) async {
    try {
      final user = _firebaseService.auth.currentUser;
      if (user == null) {
        throw Exception('Kullanıcı oturum açmamış');
      }

      await _firebaseService.firestore
          .collection('users')
          .doc(user.uid)
          .update({'preferences': preferences});
      return const Right(null);
    } catch (e) {
      _logger.e('Tercihleri güncelleme hatası: ${e.toString()}');
      return Left(Exception('Tercihler güncellenemedi: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, void>> addConnection(String userId) async {
    try {
      final currentUser = _firebaseService.auth.currentUser;
      if (currentUser == null) {
        throw Exception('Kullanıcı oturum açmamış');
      }

      await _firebaseService.firestore
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'connections': FieldValue.arrayUnion([userId])
      });
      return const Right(null);
    } catch (e) {
      _logger.e('Bağlantı ekleme hatası: ${e.toString()}');
      return Left(Exception('Bağlantı eklenemedi: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, void>> removeConnection(String userId) async {
    try {
      final currentUser = _firebaseService.auth.currentUser;
      if (currentUser == null) {
        throw Exception('Kullanıcı oturum açmamış');
      }

      await _firebaseService.firestore
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'connections': FieldValue.arrayRemove([userId])
      });
      return const Right(null);
    } catch (e) {
      _logger.e('Bağlantı silme hatası: ${e.toString()}');
      return Left(Exception('Bağlantı silinemedi: ${e.toString()}'));
    }
  }

  @override
  Stream<User?> get userStream {
    return _firebaseService.auth
        .authStateChanges()
        .asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      final userDoc = await _firebaseService.firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists) return null;

      return User.fromJson(userDoc.data()!);
    });
  }

  @override
  Future<Either<Exception, User>> signInWithFacebook() async {
    try {
      // Facebook girişi başlat
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        // Facebook Access Token'ı al
        final AccessToken accessToken = result.accessToken!;

        // Firebase kimlik bilgilerini oluştur
        final OAuthCredential credential =
            firebase_auth.FacebookAuthProvider.credential(
          accessToken.token,
        );

        // Firebase ile giriş yap
        final userCredential =
            await _firebaseService.auth.signInWithCredential(credential);

        if (userCredential.user == null) {
          throw Exception('Kullanıcı bulunamadı');
        }

        // Kullanıcı profili kontrolü ve oluşturma
        final userDoc = await _firebaseService.firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (!userDoc.exists) {
          // Facebook'tan kullanıcı bilgilerini al
          final userData = await FacebookAuth.instance.getUserData();

          final newUser = User(
            id: userCredential.user!.uid,
            email: userCredential.user!.email!,
            name: userData['name'] ?? 'İsimsiz Kullanıcı',
            avatar: userData['picture']?['data']?['url'],
          );

          await _firebaseService.firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(newUser.toJson());

          return Right(newUser);
        }

        return Right(User.fromJson(userDoc.data()!));
      } else {
        throw Exception('Facebook girişi iptal edildi');
      }
    } catch (e) {
      _logger.e('Facebook ile giriş hatası: ${e.toString()}');
      return Left(Exception('Facebook girişi başarısız: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, User>> signInWithApple() async {
    try {
      // Apple girişi başlat
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Firebase kimlik bilgilerini oluştur
      final oauthCredential =
          firebase_auth.OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Firebase ile giriş yap
      final userCredential =
          await _firebaseService.auth.signInWithCredential(oauthCredential);

      if (userCredential.user == null) {
        throw Exception('Kullanıcı bulunamadı');
      }

      // Kullanıcı profili kontrolü ve oluşturma
      final userDoc = await _firebaseService.firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        final newUser = User(
          id: userCredential.user!.uid,
          email: userCredential.user!.email!,
          name: '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
                  .trim()
                  .isEmpty
              ? 'İsimsiz Kullanıcı'
              : '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
                  .trim(),
        );

        await _firebaseService.firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(newUser.toJson());

        return Right(newUser);
      }

      return Right(User.fromJson(userDoc.data()!));
    } catch (e) {
      _logger.e('Apple ile giriş hatası: ${e.toString()}');
      return Left(Exception('Apple girişi başarısız: ${e.toString()}'));
    }
  }
}
