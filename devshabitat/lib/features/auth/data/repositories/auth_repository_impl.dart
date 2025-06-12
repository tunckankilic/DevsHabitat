import 'package:dartz/dartz.dart';
import 'package:devshabitat/core/services/firebase_service.dart';
import 'package:devshabitat/features/auth/domain/entities/user.dart';
import 'package:devshabitat/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseService _firebaseService;
  final _logger = Logger();

  AuthRepositoryImpl(this._firebaseService);

  // Email kontrolü için helper method
  Future<Either<Exception, bool>> _checkEmailExists(String email) async {
    try {
      // Firestore'da kontrol et
      final userQuery = await _firebaseService.firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return Right(userQuery.docs.isNotEmpty);
    } catch (e) {
      _logger.e('Email kontrol hatası: ${e.toString()}');
      return Left(Exception('E-posta kontrol edilemedi: ${e.toString()}'));
    }
  }

  // Mevcut kullanıcıyı e-posta ile bul
  Future<Either<Exception, User?>> _findUserByEmail(String email) async {
    try {
      final userQuery = await _firebaseService.firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        return const Right(null);
      }

      return Right(User.fromJson(userQuery.docs.first.data()));
    } catch (e) {
      _logger.e('Kullanıcı arama hatası: ${e.toString()}');
      return Left(Exception('Kullanıcı arama hatası: ${e.toString()}'));
    }
  }

  // Account linking önerisi
  Future<Either<Exception, Map<String, dynamic>>>
      _createAccountLinkingSuggestion(
    String email,
    String newProvider,
  ) async {
    try {
      final actionCodeSettings = firebase_auth.ActionCodeSettings(
        url: 'https://devshabitat.page.link/account-linking',
        handleCodeInApp: true,
        androidPackageName: 'com.devsHabitat.app',
        androidInstallApp: true,
        androidMinimumVersion: '1',
        iOSBundleId: 'com.devsHabitat.app',
      );

      await _firebaseService.auth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );

      return Right({
        'email': email,
        'newProvider': newProvider,
        'suggestion': 'Hesap bağlama bağlantısı e-posta adresinize gönderildi.',
      });
    } catch (e) {
      return Left(Exception('Hesap bağlama önerisi oluşturulamadı'));
    }
  }

  // Mevcut kullanıcıyı provider bilgileri ile güncelle
  Future<Either<Exception, User>> _updateExistingUserWithProvider(
    User existingUser,
    firebase_auth.UserCredential userCredential,
    String provider,
  ) async {
    try {
      final updatedUser = User(
        id: existingUser.id,
        email: existingUser.email,
        displayName: existingUser.displayName,
        photoURL: existingUser.photoURL ?? userCredential.user!.photoURL,
        skills: existingUser.skills,
        experience: existingUser.experience,
        preferences: existingUser.preferences,
        connections: existingUser.connections,
        lastSeen: DateTime.now(),
        githubUsername: provider == 'github'
            ? _getGitHubUsername(userCredential)
            : existingUser.githubUsername,
        githubAvatarUrl: provider == 'github'
            ? _getGitHubAvatar(userCredential)
            : existingUser.githubAvatarUrl,
        githubId: provider == 'github'
            ? _getGitHubId(userCredential)
            : existingUser.githubId,
        githubData: provider == 'github'
            ? _getGitHubData(userCredential)
            : existingUser.githubData,
        createdAt: existingUser.createdAt,
        updatedAt: DateTime.now(),
      );

      await _firebaseService.firestore
          .collection('users')
          .doc(existingUser.id)
          .update(updatedUser.toJson());

      return Right(updatedUser);
    } catch (e) {
      _logger.e('Kullanıcı güncelleme hatası: ${e.toString()}');
      return Left(Exception('Kullanıcı güncellenemedi: ${e.toString()}'));
    }
  }

  // Firebase Auth Exception handler
  Either<Exception, User> _handleFirebaseAuthException(
    firebase_auth.FirebaseAuthException e,
    String provider,
  ) {
    _logger.e('$provider ile giriş hatası: ${e.code} - ${e.message}');

    String errorMessage;
    switch (e.code) {
      case 'account-exists-with-different-credential':
        errorMessage =
            'Bu e-posta adresi farklı bir yöntemle kayıtlı. Lütfen doğru yöntemi kullanın';
        break;
      case 'invalid-credential':
        errorMessage = '$provider kimlik bilgileri geçersiz';
        break;
      case 'operation-not-allowed':
        errorMessage = '$provider girişi etkin değil';
        break;
      case 'user-disabled':
        errorMessage = 'Bu hesap devre dışı bırakılmış';
        break;
      case 'network-request-failed':
        errorMessage = 'İnternet bağlantınızı kontrol edin';
        break;
      default:
        errorMessage = '$provider girişi başarısız: ${e.message}';
    }

    return Left(Exception(errorMessage));
  }

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
    } on firebase_auth.FirebaseAuthException catch (e) {
      _logger.e('Email/şifre ile giriş hatası: ${e.code} - ${e.message}');

      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Bu e-posta adresi ile kayıtlı kullanıcı bulunamadı';
          break;
        case 'wrong-password':
          errorMessage = 'Hatalı şifre girdiniz';
          break;
        case 'invalid-email':
          errorMessage = 'Geçersiz e-posta adresi';
          break;
        case 'user-disabled':
          errorMessage = 'Bu hesap devre dışı bırakılmış';
          break;
        case 'too-many-requests':
          errorMessage =
              'Çok fazla başarısız deneme. Lütfen daha sonra tekrar deneyin';
          break;
        case 'network-request-failed':
          errorMessage = 'İnternet bağlantınızı kontrol edin';
          break;
        default:
          errorMessage = 'Giriş başarısız: ${e.message}';
      }

      return Left(Exception(errorMessage));
    } catch (e) {
      _logger.e('Email/şifre ile giriş hatası: ${e.toString()}');
      return Left(Exception('Beklenmeyen bir hata oluştu: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, User>> signInWithGoogle() async {
    try {
      firebase_auth.UserCredential userCredential;

      if (kIsWeb) {
        final provider = firebase_auth.GoogleAuthProvider();
        provider.addScope('email');
        provider.addScope('profile');

        userCredential = await _firebaseService.auth.signInWithPopup(provider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn(
          scopes: ['email', 'profile'],
        ).signIn();

        if (googleUser == null) {
          throw Exception('Google girişi iptal edildi');
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        if (googleAuth.accessToken == null || googleAuth.idToken == null) {
          throw Exception('Google kimlik doğrulama bilgileri alınamadı');
        }

        final credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential =
            await _firebaseService.auth.signInWithCredential(credential);
      }

      if (userCredential.user == null) {
        throw Exception('Google kimlik doğrulaması başarısız');
      }

      // E-posta kontrolü
      final userEmail = userCredential.user!.email;
      if (userEmail != null) {
        final emailCheckResult = await _checkEmailExists(userEmail);

        return emailCheckResult.fold(
          (error) => Left(error),
          (emailExists) async {
            if (emailExists) {
              // Mevcut kullanıcıyı bul
              final existingUserResult = await _findUserByEmail(userEmail);
              return existingUserResult.fold(
                (error) => Left(error),
                (existingUser) async {
                  if (existingUser != null) {
                    // Kullanıcı zaten var, Google provider bilgilerini güncelle
                    return await _updateExistingUserWithProvider(
                        existingUser, userCredential, 'google');
                  } else {
                    // Firebase Auth'da var ama Firestore'da yok - hesap bağlama gerekli
                    final linkingSuggestion =
                        await _createAccountLinkingSuggestion(
                            userEmail, 'Google');

                    return linkingSuggestion.fold(
                      (error) => Left(error),
                      (suggestion) => Left(Exception(
                          'ACCOUNT_LINKING_REQUIRED|${suggestion['suggestion']}')),
                    );
                  }
                },
              );
            } else {
              // Yeni kullanıcı oluştur
              return await _createOrUpdateUser(userCredential, 'google');
            }
          },
        );
      }

      return await _createOrUpdateUser(userCredential, 'google');
    } on firebase_auth.FirebaseAuthException catch (e) {
      _logger.e('Google ile giriş hatası: ${e.code} - ${e.message}');

      String errorMessage;
      switch (e.code) {
        case 'account-exists-with-different-credential':
          // E-posta adresini al ve mevcut provider'ları göster
          final email = e.email;
          if (email != null) {
            final actionCodeSettings = firebase_auth.ActionCodeSettings(
              url: 'https://devshabitat.page.link/account-linking',
              handleCodeInApp: true,
              androidPackageName: 'com.devsHabitat.app',
              androidInstallApp: true,
              androidMinimumVersion: '1',
              iOSBundleId: 'com.devsHabitat.app',
            );

            await _firebaseService.auth.sendSignInLinkToEmail(
              email: email,
              actionCodeSettings: actionCodeSettings,
            );

            errorMessage =
                'Hesap bağlama bağlantısı e-posta adresinize gönderildi.';
          } else {
            errorMessage = 'Bu e-posta adresi farklı bir yöntemle kayıtlı';
          }
          break;
        case 'invalid-credential':
          errorMessage = 'Google kimlik bilgileri geçersiz';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Google girişi etkin değil';
          break;
        case 'user-disabled':
          errorMessage = 'Bu hesap devre dışı bırakılmış';
          break;
        case 'network-request-failed':
          errorMessage = 'İnternet bağlantınızı kontrol edin';
          break;
        default:
          errorMessage = 'Google girişi başarısız: ${e.message}';
      }

      return Left(Exception(errorMessage));
    } catch (e) {
      _logger.e('Google ile giriş hatası: ${e.toString()}');
      return Left(Exception('Google girişi başarısız: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, User>> signInWithGithub() async {
    try {
      final provider = firebase_auth.GithubAuthProvider();
      provider.addScope('user:email');
      provider.addScope('read:user');

      firebase_auth.UserCredential userCredential;

      if (kIsWeb) {
        userCredential = await _firebaseService.auth.signInWithPopup(provider);
      } else {
        userCredential =
            await _firebaseService.auth.signInWithProvider(provider);
      }

      if (userCredential.user == null) {
        throw Exception('GitHub kimlik doğrulaması başarısız');
      }

      // E-posta kontrolü (GitHub'da e-posta olmayabilir)
      final userEmail = userCredential.user!.email;
      if (userEmail != null) {
        final emailCheckResult = await _checkEmailExists(userEmail);

        return emailCheckResult.fold(
          (error) => Left(error),
          (emailExists) async {
            if (emailExists) {
              final existingUserResult = await _findUserByEmail(userEmail);
              return existingUserResult.fold(
                (error) => Left(error),
                (existingUser) async {
                  if (existingUser != null) {
                    return await _updateExistingUserWithProvider(
                        existingUser, userCredential, 'github');
                  } else {
                    final linkingSuggestion =
                        await _createAccountLinkingSuggestion(
                            userEmail, 'GitHub');

                    return linkingSuggestion.fold(
                      (error) => Left(error),
                      (suggestion) => Left(Exception(
                          'ACCOUNT_LINKING_REQUIRED|${suggestion['suggestion']}')),
                    );
                  }
                },
              );
            } else {
              return await _createOrUpdateUser(userCredential, 'github');
            }
          },
        );
      }

      return await _createOrUpdateUser(userCredential, 'github');
    } on firebase_auth.FirebaseAuthException catch (e) {
      return _handleFirebaseAuthException(e, 'GitHub');
    } catch (e) {
      _logger.e('GitHub ile giriş hatası: ${e.toString()}');
      return Left(Exception('GitHub girişi başarısız: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, User>> signInWithFacebook() async {
    try {
      firebase_auth.UserCredential userCredential;

      if (kIsWeb) {
        final provider = firebase_auth.FacebookAuthProvider();
        provider.addScope('email');
        provider.addScope('public_profile');

        userCredential = await _firebaseService.auth.signInWithPopup(provider);
      } else {
        final LoginResult result = await FacebookAuth.instance.login(
          permissions: ['email', 'public_profile'],
        );

        if (result.status == LoginStatus.success) {
          final AccessToken accessToken = result.accessToken!;

          final credential = firebase_auth.FacebookAuthProvider.credential(
            accessToken.tokenString,
          );

          userCredential =
              await _firebaseService.auth.signInWithCredential(credential);
        } else if (result.status == LoginStatus.cancelled) {
          throw Exception('Facebook girişi iptal edildi');
        } else {
          throw Exception('Facebook girişi başarısız: ${result.message}');
        }
      }

      if (userCredential.user == null) {
        throw Exception('Facebook kimlik doğrulaması başarısız');
      }

      // E-posta kontrolü
      final userEmail = userCredential.user!.email;
      if (userEmail != null) {
        final emailCheckResult = await _checkEmailExists(userEmail);

        return emailCheckResult.fold(
          (error) => Left(error),
          (emailExists) async {
            if (emailExists) {
              final existingUserResult = await _findUserByEmail(userEmail);
              return existingUserResult.fold(
                (error) => Left(error),
                (existingUser) async {
                  if (existingUser != null) {
                    return await _updateExistingUserWithProvider(
                        existingUser, userCredential, 'facebook');
                  } else {
                    final linkingSuggestion =
                        await _createAccountLinkingSuggestion(
                            userEmail, 'Facebook');

                    return linkingSuggestion.fold(
                      (error) => Left(error),
                      (suggestion) => Left(Exception(
                          'ACCOUNT_LINKING_REQUIRED|${suggestion['suggestion']}')),
                    );
                  }
                },
              );
            } else {
              return await _createOrUpdateUser(userCredential, 'facebook');
            }
          },
        );
      }

      return await _createOrUpdateUser(userCredential, 'facebook');
    } on firebase_auth.FirebaseAuthException catch (e) {
      return _handleFirebaseAuthException(e, 'Facebook');
    } catch (e) {
      _logger.e('Facebook ile giriş hatası: ${e.toString()}');
      return Left(Exception('Facebook girişi başarısız: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, User>> signInWithApple() async {
    try {
      firebase_auth.UserCredential userCredential;

      if (kIsWeb || Platform.isAndroid) {
        final provider = firebase_auth.OAuthProvider('apple.com');
        provider.addScope('email');
        provider.addScope('name');

        userCredential =
            await _firebaseService.auth.signInWithProvider(provider);
      } else if (Platform.isIOS) {
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        final oauthCredential =
            firebase_auth.OAuthProvider('apple.com').credential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode,
        );

        userCredential =
            await _firebaseService.auth.signInWithCredential(oauthCredential);
      } else {
        throw Exception('Apple Sign In bu platformda desteklenmiyor');
      }

      if (userCredential.user == null) {
        throw Exception('Apple kimlik doğrulaması başarısız');
      }

      return await _createOrUpdateUser(userCredential, 'apple');
    } on firebase_auth.FirebaseAuthException catch (e) {
      return _handleFirebaseAuthException(e, 'Apple');
    } catch (e) {
      _logger.e('Apple ile giriş hatası: ${e.toString()}');
      return Left(Exception('Apple girişi başarısız: ${e.toString()}'));
    }
  }

  // Helper method to create or update user
  Future<Either<Exception, User>> _createOrUpdateUser(
    firebase_auth.UserCredential userCredential,
    String provider,
  ) async {
    try {
      final firebaseUser = userCredential.user!;

      // Check if user already exists by Firebase UID
      final userDoc = await _firebaseService.firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (userDoc.exists) {
        final existingUser = User.fromJson(userDoc.data()!);

        final updatedUser = User(
          id: existingUser.id,
          email: existingUser.email,
          displayName: existingUser.displayName,
          photoURL: existingUser.photoURL ?? userCredential.user!.photoURL,
          skills: existingUser.skills,
          experience: existingUser.experience,
          preferences: existingUser.preferences,
          connections: existingUser.connections,
          lastSeen: DateTime.now(),
          githubUsername: existingUser.githubUsername,
          githubAvatarUrl: existingUser.githubAvatarUrl,
          githubId: existingUser.githubId,
          githubData: existingUser.githubData,
          createdAt: existingUser.createdAt,
          updatedAt: DateTime.now(),
        );

        await _firebaseService.firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .update({'lastSeen': updatedUser.lastSeen?.toIso8601String()});

        return Right(updatedUser);
      }

      // Create new user
      final newUser = User(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? 'no-email@$provider.com',
        displayName: _getDisplayName(firebaseUser, userCredential, provider),
        photoURL: firebaseUser.photoURL,
        lastSeen: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        githubUsername:
            provider == 'github' ? _getGitHubUsername(userCredential) : null,
        githubAvatarUrl:
            provider == 'github' ? _getGitHubAvatar(userCredential) : null,
        githubId: provider == 'github' ? _getGitHubId(userCredential) : null,
        githubData:
            provider == 'github' ? _getGitHubData(userCredential) : const {},
      );

      await _firebaseService.firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .set(newUser.toJson());

      return Right(newUser);
    } catch (e) {
      _logger.e('User creation error: ${e.toString()}');
      return Left(
          Exception('Kullanıcı profili oluşturulamadı: ${e.toString()}'));
    }
  }

  String _getDisplayName(
    firebase_auth.User firebaseUser,
    firebase_auth.UserCredential userCredential,
    String provider,
  ) {
    // Try to get name from Firebase user
    if (firebaseUser.displayName != null &&
        firebaseUser.displayName!.isNotEmpty) {
      return firebaseUser.displayName!;
    }

    // Try to get name from additional user info
    final profile = userCredential.additionalUserInfo?.profile;
    if (profile != null) {
      // GitHub
      if (provider == 'github' &&
          profile['name'] != null &&
          profile['name'].toString().isNotEmpty) {
        return profile['name'].toString();
      }
      // Facebook
      if (provider == 'facebook') {
        if (profile['name'] != null && profile['name'].toString().isNotEmpty) {
          return profile['name'].toString();
        }
        if (profile['first_name'] != null || profile['last_name'] != null) {
          final firstName = profile['first_name']?.toString() ?? '';
          final lastName = profile['last_name']?.toString() ?? '';
          return '$firstName $lastName'.trim();
        }
      }
      // Google
      if (provider == 'google' &&
          profile['name'] != null &&
          profile['name'].toString().isNotEmpty) {
        return profile['name'].toString();
      }
    }

    // Fallback to email or username
    if (provider == 'github' &&
        userCredential.additionalUserInfo?.username != null) {
      return userCredential.additionalUserInfo!.username!;
    }

    return firebaseUser.email?.split('@').first ?? 'İsimsiz Kullanıcı';
  }

  String? _getGitHubUsername(firebase_auth.UserCredential userCredential) {
    return userCredential.additionalUserInfo?.username;
  }

  String? _getGitHubAvatar(firebase_auth.UserCredential userCredential) {
    final profile = userCredential.additionalUserInfo?.profile;
    return profile?['avatar_url']?.toString();
  }

  String? _getGitHubId(firebase_auth.UserCredential userCredential) {
    final profile = userCredential.additionalUserInfo?.profile;
    return profile?['id']?.toString();
  }

  Map<String, dynamic> _getGitHubData(
      firebase_auth.UserCredential userCredential) {
    return userCredential.additionalUserInfo?.profile ?? {};
  }

  // Additional helper methods

  Future<Either<Exception, void>> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseService.auth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      _logger.e(
          'Şifre sıfırlama e-postası gönderme hatası: ${e.code} - ${e.message}');

      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Bu e-posta adresi ile kayıtlı kullanıcı bulunamadı';
          break;
        case 'invalid-email':
          errorMessage = 'Geçersiz e-posta adresi';
          break;
        case 'network-request-failed':
          errorMessage = 'İnternet bağlantınızı kontrol edin';
          break;
        default:
          errorMessage =
              'Şifre sıfırlama e-postası gönderilemedi: ${e.message}';
      }

      return Left(Exception(errorMessage));
    } catch (e) {
      _logger.e('Şifre sıfırlama e-postası gönderme hatası: ${e.toString()}');
      return Left(Exception(
          'Şifre sıfırlama e-postası gönderilemedi: ${e.toString()}'));
    }
  }

  Future<Either<Exception, void>> verifyEmail() async {
    try {
      final user = _firebaseService.auth.currentUser;
      if (user == null) {
        throw Exception('Kullanıcı oturum açmamış');
      }

      if (user.emailVerified) {
        throw Exception('E-posta adresi zaten doğrulanmış');
      }

      await user.sendEmailVerification();
      return const Right(null);
    } catch (e) {
      _logger.e('E-posta doğrulama gönderme hatası: ${e.toString()}');
      return Left(
          Exception('E-posta doğrulama gönderme hatası: ${e.toString()}'));
    }
  }

  Future<Either<Exception, void>> updatePassword(String newPassword) async {
    try {
      final user = _firebaseService.auth.currentUser;
      if (user == null) {
        throw Exception('Kullanıcı oturum açmamış');
      }

      await user.updatePassword(newPassword);
      return const Right(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      _logger.e('Şifre güncelleme hatası: ${e.code} - ${e.message}');

      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'Şifre çok zayıf. Lütfen daha güçlü bir şifre seçin';
          break;
        case 'requires-recent-login':
          errorMessage = 'Bu işlem için tekrar giriş yapmanız gerekiyor';
          break;
        case 'network-request-failed':
          errorMessage = 'İnternet bağlantınızı kontrol edin';
          break;
        default:
          errorMessage = 'Şifre güncellenemedi: ${e.message}';
      }

      return Left(Exception(errorMessage));
    } catch (e) {
      _logger.e('Şifre güncelleme hatası: ${e.toString()}');
      return Left(Exception('Şifre güncellenemedi: ${e.toString()}'));
    }
  }

  Future<Either<Exception, void>> updateEmail(String newEmail) async {
    try {
      final user = _firebaseService.auth.currentUser;
      if (user == null) {
        throw Exception('Kullanıcı oturum açmamış');
      }

      await user.verifyBeforeUpdateEmail(newEmail);

      // Update email in Firestore as well
      await _firebaseService.firestore
          .collection('users')
          .doc(user.uid)
          .update({'email': newEmail});

      return const Right(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      _logger.e('E-posta güncelleme hatası: ${e.code} - ${e.message}');

      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Bu e-posta adresi zaten kullanımda';
          break;
        case 'invalid-email':
          errorMessage = 'Geçersiz e-posta adresi';
          break;
        case 'requires-recent-login':
          errorMessage = 'Bu işlem için tekrar giriş yapmanız gerekiyor';
          break;
        case 'network-request-failed':
          errorMessage = 'İnternet bağlantınızı kontrol edin';
          break;
        default:
          errorMessage = 'E-posta güncellenemedi: ${e.message}';
      }

      return Left(Exception(errorMessage));
    } catch (e) {
      _logger.e('E-posta güncelleme hatası: ${e.toString()}');
      return Left(Exception('E-posta güncellenemedi: ${e.toString()}'));
    }
  }

  Future<Either<Exception, void>> deleteAccount() async {
    try {
      final user = _firebaseService.auth.currentUser;
      if (user == null) {
        throw Exception('Kullanıcı oturum açmamış');
      }

      // Delete user data from Firestore
      await _firebaseService.firestore
          .collection('users')
          .doc(user.uid)
          .delete();

      // Delete user account
      await user.delete();

      return const Right(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      _logger.e('Hesap silme hatası: ${e.code} - ${e.message}');

      String errorMessage;
      switch (e.code) {
        case 'requires-recent-login':
          errorMessage = 'Bu işlem için tekrar giriş yapmanız gerekiyor';
          break;
        case 'network-request-failed':
          errorMessage = 'İnternet bağlantınızı kontrol edin';
          break;
        default:
          errorMessage = 'Hesap silinemedi: ${e.message}';
      }

      return Left(Exception(errorMessage));
    } catch (e) {
      _logger.e('Hesap silme hatası: ${e.toString()}');
      return Left(Exception('Hesap silinemedi: ${e.toString()}'));
    }
  }

  Future<Either<Exception, void>> reauthenticateWithPassword(
      String password) async {
    try {
      final user = _firebaseService.auth.currentUser;
      if (user == null) {
        throw Exception('Kullanıcı oturum açmamış');
      }

      if (user.email == null) {
        throw Exception('E-posta adresi bulunamadı');
      }

      final credential = firebase_auth.EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      return const Right(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      _logger.e('Yeniden kimlik doğrulama hatası: ${e.code} - ${e.message}');

      String errorMessage;
      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'Hatalı şifre girdiniz';
          break;
        case 'user-mismatch':
          errorMessage = 'Kullanıcı uyumsuzluğu';
          break;
        case 'user-not-found':
          errorMessage = 'Kullanıcı bulunamadı';
          break;
        case 'invalid-credential':
          errorMessage = 'Geçersiz kimlik bilgileri';
          break;
        case 'network-request-failed':
          errorMessage = 'İnternet bağlantınızı kontrol edin';
          break;
        default:
          errorMessage = 'Kimlik doğrulama başarısız: ${e.message}';
      }

      return Left(Exception(errorMessage));
    } catch (e) {
      _logger.e('Yeniden kimlik doğrulama hatası: ${e.toString()}');
      return Left(Exception('Kimlik doğrulama başarısız: ${e.toString()}'));
    }
  }

  Future<Either<Exception, List<String>>> getLinkedProviders(
      String email) async {
    try {
      final user = _firebaseService.auth.currentUser;
      if (user == null) {
        return const Right([]);
      }
      return Right(user.providerData.map((info) => info.providerId).toList());
    } catch (e) {
      _logger.e('Bağlı sağlayıcılar getirme hatası: ${e.toString()}');
      return Left(
          Exception('Bağlı sağlayıcılar getirilemedi: ${e.toString()}'));
    }
  }

  Future<Either<Exception, void>> linkWithGoogle() async {
    try {
      final user = _firebaseService.auth.currentUser;
      if (user == null) {
        throw Exception('Kullanıcı oturum açmamış');
      }

      firebase_auth.AuthCredential credential;

      if (kIsWeb) {
        final provider = firebase_auth.GoogleAuthProvider();
        final userCredential = await user.linkWithPopup(provider);
        return const Right(null);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          throw Exception('Google girişi iptal edildi');
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await user.linkWithCredential(credential);
        return const Right(null);
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      _logger.e('Google hesabı bağlama hatası: ${e.code} - ${e.message}');

      String errorMessage;
      switch (e.code) {
        case 'provider-already-linked':
          errorMessage = 'Google hesabı zaten bağlı';
          break;
        case 'invalid-credential':
          errorMessage = 'Geçersiz kimlik bilgileri';
          break;
        case 'credential-already-in-use':
          errorMessage =
              'Bu Google hesabı başka bir kullanıcı tarafından kullanılıyor';
          break;
        case 'email-already-in-use':
          errorMessage = 'Bu e-posta adresi zaten kullanımda';
          break;
        case 'network-request-failed':
          errorMessage = 'İnternet bağlantınızı kontrol edin';
          break;
        default:
          errorMessage = 'Google hesabı bağlanamadı: ${e.message}';
      }

      return Left(Exception(errorMessage));
    } catch (e) {
      _logger.e('Google hesabı bağlama hatası: ${e.toString()}');
      return Left(Exception('Google hesabı bağlanamadı: ${e.toString()}'));
    }
  }

  Future<Either<Exception, void>> unlinkProvider(String providerId) async {
    try {
      final user = _firebaseService.auth.currentUser;
      if (user == null) {
        throw Exception('Kullanıcı oturum açmamış');
      }

      await user.unlink(providerId);
      return const Right(null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      _logger.e(
          'Sağlayıcı bağlantısını kaldırma hatası: ${e.code} - ${e.message}');

      String errorMessage;
      switch (e.code) {
        case 'no-such-provider':
          errorMessage = 'Bu sağlayıcı hesabınıza bağlı değil';
          break;
        case 'requires-recent-login':
          errorMessage = 'Bu işlem için tekrar giriş yapmanız gerekiyor';
          break;
        case 'network-request-failed':
          errorMessage = 'İnternet bağlantınızı kontrol edin';
          break;
        default:
          errorMessage = 'Sağlayıcı bağlantısı kaldırılamadı: ${e.message}';
      }

      return Left(Exception(errorMessage));
    } catch (e) {
      _logger.e('Sağlayıcı bağlantısını kaldırma hatası: ${e.toString()}');
      return Left(
          Exception('Sağlayıcı bağlantısı kaldırılamadı: ${e.toString()}'));
    }
  }

  // User activity tracking
  Future<Either<Exception, void>> updateLastSeen() async {
    try {
      final user = _firebaseService.auth.currentUser;
      if (user == null) {
        return const Right(null); // Not an error if user is not logged in
      }

      await _firebaseService.firestore
          .collection('users')
          .doc(user.uid)
          .update({
        'lastSeen': DateTime.now().toIso8601String(),
      });

      return const Right(null);
    } catch (e) {
      _logger.e('Son görülme zamanı güncelleme hatası: ${e.toString()}');
      return Left(
          Exception('Son görülme zamanı güncellenemedi: ${e.toString()}'));
    }
  }

  // Check if user is verified
  bool get isEmailVerified {
    final user = _firebaseService.auth.currentUser;
    return user?.emailVerified ?? false;
  }

  // Get current user ID
  String? get currentUserId {
    return _firebaseService.auth.currentUser?.uid;
  }

  // Check if user is anonymous
  bool get isAnonymous {
    final user = _firebaseService.auth.currentUser;
    return user?.isAnonymous ?? false;
  }

  // Get user creation time
  DateTime? get userCreationTime {
    final user = _firebaseService.auth.currentUser;
    return user?.metadata.creationTime;
  }

  // Get last sign in time
  DateTime? get lastSignInTime {
    final user = _firebaseService.auth.currentUser;
    return user?.metadata.lastSignInTime;
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

      await userCredential.user!.updateDisplayName(name);

      final newUser = User(
        id: userCredential.user!.uid,
        email: email,
        displayName: name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firebaseService.firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(newUser.toJson());

      await userCredential.user!.sendEmailVerification();

      return Right(newUser);
    } catch (e) {
      return Left(Exception('Kayıt başarısız: ${e.toString()}'));
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
      return Left(Exception('Kullanıcı bilgileri alınamadı: ${e.toString()}'));
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
      return Left(Exception('Bağlantı silinemedi: ${e.toString()}'));
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
      return Left(Exception('Tercihler güncellenemedi: ${e.toString()}'));
    }
  }

  @override
  Stream<User?> get userStream {
    return _firebaseService.auth
        .authStateChanges()
        .asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      try {
        final userDoc = await _firebaseService.firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        if (!userDoc.exists) return null;

        return User.fromJson(userDoc.data()!);
      } catch (e) {
        _logger.e('User stream error: ${e.toString()}');
        return null;
      }
    });
  }

  @override
  Future<Either<Exception, void>> signOut() async {
    try {
      await _firebaseService.auth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(Exception('Çıkış yapılamadı: ${e.toString()}'));
    }
  }
}
