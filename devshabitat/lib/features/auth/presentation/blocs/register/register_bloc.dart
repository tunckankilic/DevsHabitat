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

class NextStepRequested extends RegisterEvent {
  final Map<String, dynamic> formData;

  const NextStepRequested(this.formData);

  @override
  List<Object?> get props => [formData];
}

class PreviousStepRequested extends RegisterEvent {}

class FormDataUpdated extends RegisterEvent {
  final Map<String, dynamic> formData;

  const FormDataUpdated(this.formData);

  @override
  List<Object?> get props => [formData];
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

class StepInitial extends RegisterState {
  final int currentStep;
  final Map<String, dynamic> formData;

  const StepInitial({
    this.currentStep = 0,
    this.formData = const {},
  });

  @override
  List<Object?> get props => [currentStep, formData];
}

class StepLoading extends RegisterState {
  final int currentStep;
  final Map<String, dynamic> formData;

  const StepLoading({
    required this.currentStep,
    required this.formData,
  });

  @override
  List<Object?> get props => [currentStep, formData];
}

class StepSuccess extends RegisterState {
  final int currentStep;
  final Map<String, dynamic> formData;

  const StepSuccess({
    required this.currentStep,
    required this.formData,
  });

  @override
  List<Object?> get props => [currentStep, formData];
}

class StepFailure extends RegisterState {
  final String message;
  final int currentStep;
  final Map<String, dynamic> formData;

  const StepFailure({
    required this.message,
    required this.currentStep,
    required this.formData,
  });

  @override
  List<Object?> get props => [message, currentStep, formData];
}

// BLoC
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;
  static const int totalSteps = 3;

  RegisterBloc(this._authRepository) : super(StepInitial()) {
    on<RegisterWithEmailAndPasswordRequested>(
        _onRegisterWithEmailAndPasswordRequested);
    on<NextStepRequested>(_onNextStepRequested);
    on<PreviousStepRequested>(_onPreviousStepRequested);
    on<FormDataUpdated>(_onFormDataUpdated);
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

  void _onNextStepRequested(
    NextStepRequested event,
    Emitter<RegisterState> emit,
  ) {
    if (state is StepInitial || state is StepSuccess) {
      final currentState = state as dynamic;
      final currentStep = currentState.currentStep;
      final formData = Map<String, dynamic>.from(currentState.formData);
      formData.addAll(event.formData);

      if (currentStep < totalSteps - 1) {
        emit(StepSuccess(
          currentStep: currentStep + 1,
          formData: formData,
        ));
      } else {
        // Son adımda kayıt işlemini başlat
        add(RegisterWithEmailAndPasswordRequested(
          email: formData['email'] as String,
          password: formData['password'] as String,
          name: formData['name'] as String,
        ));
      }
    }
  }

  void _onPreviousStepRequested(
    PreviousStepRequested event,
    Emitter<RegisterState> emit,
  ) {
    if (state is StepInitial || state is StepSuccess) {
      final currentState = state as dynamic;
      final currentStep = currentState.currentStep;
      final formData = currentState.formData;

      if (currentStep > 0) {
        emit(StepSuccess(
          currentStep: currentStep - 1,
          formData: formData,
        ));
      }
    }
  }

  void _onFormDataUpdated(
    FormDataUpdated event,
    Emitter<RegisterState> emit,
  ) {
    if (state is StepInitial || state is StepSuccess) {
      final currentState = state as dynamic;
      final currentStep = currentState.currentStep;
      final formData = Map<String, dynamic>.from(currentState.formData);
      formData.addAll(event.formData);

      emit(StepSuccess(
        currentStep: currentStep,
        formData: formData,
      ));
    }
  }
}
