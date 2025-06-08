import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';

// States
abstract class FormValidationState extends Equatable {
  const FormValidationState();

  @override
  List<Object?> get props => [];
}

class FormValidationInitial extends FormValidationState {}

class FormValidationLoading extends FormValidationState {}

class FormValidationSuccess extends FormValidationState {
  final Map<String, dynamic> validatedData;

  const FormValidationSuccess(this.validatedData);

  @override
  List<Object?> get props => [validatedData];
}

class FormValidationFailure extends FormValidationState {
  final Map<String, String> errors;

  const FormValidationFailure(this.errors);

  @override
  List<Object?> get props => [errors];
}

// Cubit
class FormValidationCubit extends Cubit<FormValidationState> {
  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 300);

  FormValidationCubit() : super(FormValidationInitial());

  void validateField(String fieldName, String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, () {
      final errors = <String, String>{};

      switch (fieldName) {
        case 'name':
          if (value.isEmpty) {
            errors['name'] = 'İsim alanı zorunludur';
          } else if (value.length < 2) {
            errors['name'] = 'İsim en az 2 karakter olmalıdır';
          }
          break;

        case 'email':
          if (value.isEmpty) {
            errors['email'] = 'E-posta alanı zorunludur';
          } else if (!_isValidEmail(value)) {
            errors['email'] = 'Geçerli bir e-posta adresi giriniz';
          }
          break;

        case 'password':
          if (value.isEmpty) {
            errors['password'] = 'Şifre alanı zorunludur';
          } else if (value.length < 8) {
            errors['password'] = 'Şifre en az 8 karakter olmalıdır';
          } else if (!_hasRequiredPasswordChars(value)) {
            errors['password'] =
                'Şifre en az bir büyük harf, bir küçük harf ve bir rakam içermelidir';
          }
          break;

        case 'bio':
          if (value.isNotEmpty && value.length < 10) {
            errors['bio'] = 'Biyografi en az 10 karakter olmalıdır';
          }
          break;

        case 'location':
          if (value.isNotEmpty && value.length < 3) {
            errors['location'] = 'Konum en az 3 karakter olmalıdır';
          }
          break;
      }

      if (errors.isEmpty) {
        emit(FormValidationSuccess({fieldName: value}));
      } else {
        emit(FormValidationFailure(errors));
      }
    });
  }

  void validateSkills(List<String> skills) {
    final errors = <String, String>{};
    if (skills.length < 3) {
      errors['skills'] = 'En az 3 beceri seçmelisiniz';
    }

    if (errors.isEmpty) {
      emit(FormValidationSuccess({'skills': skills}));
    } else {
      emit(FormValidationFailure(errors));
    }
  }

  void validateExperienceLevel(String level) {
    final errors = <String, String>{};
    if (level.isEmpty) {
      errors['experience_level'] = 'Deneyim seviyesi seçmelisiniz';
    }

    if (errors.isEmpty) {
      emit(FormValidationSuccess({'experience_level': level}));
    } else {
      emit(FormValidationFailure(errors));
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegex.hasMatch(email);
  }

  bool _hasRequiredPasswordChars(String password) {
    final hasUpperCase = password.contains(RegExp(r'[A-Z]'));
    final hasLowerCase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    return hasUpperCase && hasLowerCase && hasDigits;
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
