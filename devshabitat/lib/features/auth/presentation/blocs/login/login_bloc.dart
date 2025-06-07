import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:devshabitat/features/auth/domain/entities/user.dart';
import 'package:devshabitat/features/auth/domain/repositories/auth_repository.dart';

// Events
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginWithEmailAndPasswordRequested extends LoginEvent {
  final String email;
  final String password;

  const LoginWithEmailAndPasswordRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class LoginWithGoogleRequested extends LoginEvent {}

class LoginWithGithubRequested extends LoginEvent {}

class LoginWithFacebookRequested extends LoginEvent {}

class LoginWithAppleRequested extends LoginEvent {}

// States
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final User user;

  const LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class LoginFailure extends LoginState {
  final String message;

  const LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc(this._authRepository) : super(LoginInitial()) {
    on<LoginWithEmailAndPasswordRequested>(
        _onLoginWithEmailAndPasswordRequested);
    on<LoginWithGoogleRequested>(_onLoginWithGoogleRequested);
    on<LoginWithGithubRequested>(_onLoginWithGithubRequested);
    on<LoginWithFacebookRequested>(_onLoginWithFacebookRequested);
    on<LoginWithAppleRequested>(_onLoginWithAppleRequested);
  }

  Future<void> _onLoginWithEmailAndPasswordRequested(
    LoginWithEmailAndPasswordRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final result = await _authRepository.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      result.fold(
        (failure) => emit(LoginFailure(failure.toString())),
        (user) => emit(LoginSuccess(user)),
      );
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> _onLoginWithGoogleRequested(
    LoginWithGoogleRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final result = await _authRepository.signInWithGoogle();
      result.fold(
        (failure) => emit(LoginFailure(failure.toString())),
        (user) => emit(LoginSuccess(user)),
      );
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> _onLoginWithGithubRequested(
    LoginWithGithubRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final result = await _authRepository.signInWithGithub();
      result.fold(
        (failure) => emit(LoginFailure(failure.toString())),
        (user) => emit(LoginSuccess(user)),
      );
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> _onLoginWithFacebookRequested(
    LoginWithFacebookRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final result = await _authRepository.signInWithFacebook();
      result.fold(
        (failure) => emit(LoginFailure(failure.toString())),
        (user) => emit(LoginSuccess(user)),
      );
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> _onLoginWithAppleRequested(
    LoginWithAppleRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final result = await _authRepository.signInWithApple();
      result.fold(
        (failure) => emit(LoginFailure(failure.toString())),
        (user) => emit(LoginSuccess(user)),
      );
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
