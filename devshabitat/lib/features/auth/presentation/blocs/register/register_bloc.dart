import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:devshabitat/features/auth/domain/entities/user.dart';
import 'package:devshabitat/features/auth/domain/repositories/auth_repository.dart';

// Events
abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterWithEmailAndPasswordRequested extends RegisterEvent {
  final String email;
  final String password;
  final String name;

  const RegisterWithEmailAndPasswordRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

// States
abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final User user;

  const RegisterSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class RegisterFailure extends RegisterState {
  final String message;

  const RegisterFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;

  RegisterBloc(this._authRepository) : super(RegisterInitial()) {
    on<RegisterWithEmailAndPasswordRequested>(
        _onRegisterWithEmailAndPasswordRequested);
  }

  Future<void> _onRegisterWithEmailAndPasswordRequested(
    RegisterWithEmailAndPasswordRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      final result = await _authRepository.registerWithEmailAndPassword(
        event.email,
        event.password,
        event.name,
      );
      result.fold(
        (failure) => emit(RegisterFailure(failure.toString())),
        (user) => emit(RegisterSuccess(user)),
      );
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
