import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class RegisterUser extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const RegisterUser({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}

class LoginUser extends AuthEvent {
  final String email;
  final String password;

  const LoginUser({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthBloc() : super(AuthInitial()) {
    on<RegisterUser>(_onRegisterUser);
    on<LoginUser>(_onLoginUser);
  }

  Future<void> _onRegisterUser(
      RegisterUser event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());

      // Firebase Auth ile kullanıcı oluştur
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      // Firestore'da kullanıcı bilgilerini kaydet
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': event.name,
        'email': event.email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already in use';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'weak-password':
          message = 'Şifre çok zayıf';
          break;
        default:
          message = 'Bir hata oluştu: ${e.message}';
      }
      emit(AuthError(message));
    } catch (e) {
      emit(AuthError('Bir hata oluştu: $e'));
    }
  }

  Future<void> _onLoginUser(LoginUser event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());

      await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Bu e-posta adresi ile kayıtlı kullanıcı bulunamadı';
          break;
        case 'wrong-password':
          message = 'Hatalı şifre';
          break;
        case 'invalid-email':
          message = 'Geçersiz e-posta adresi';
          break;
        default:
          message = 'Bir hata oluştu: ${e.message}';
      }
      emit(AuthError(message));
    } catch (e) {
      emit(AuthError('Bir hata oluştu: $e'));
    }
  }
}
