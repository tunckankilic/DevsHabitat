import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// States
abstract class GitHubValidationState extends Equatable {
  const GitHubValidationState();

  @override
  List<Object?> get props => [];
}

class GitHubValidationInitial extends GitHubValidationState {}

class GitHubValidationLoading extends GitHubValidationState {}

class GitHubValidationSuccess extends GitHubValidationState {
  final String username;
  final Map<String, dynamic> userData;

  const GitHubValidationSuccess({
    required this.username,
    required this.userData,
  });

  @override
  List<Object?> get props => [username, userData];
}

class GitHubValidationFailure extends GitHubValidationState {
  final String message;

  const GitHubValidationFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class GitHubValidationCubit extends Cubit<GitHubValidationState> {
  final http.Client _httpClient;
  static const String _baseUrl = 'https://api.github.com/users';

  GitHubValidationCubit({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client(),
        super(GitHubValidationInitial());

  Future<void> validateUsername(String username) async {
    if (username.isEmpty) {
      emit(const GitHubValidationFailure('Kullanıcı adı boş olamaz'));
      return;
    }

    emit(GitHubValidationLoading());

    try {
      final response = await _httpClient.get(
        Uri.parse('$_baseUrl/$username'),
        headers: {
          'Accept': 'application/vnd.github.v3+json',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        emit(GitHubValidationSuccess(
          username: username,
          userData: userData,
        ));
      } else if (response.statusCode == 404) {
        emit(const GitHubValidationFailure('Kullanıcı bulunamadı'));
      } else {
        emit(const GitHubValidationFailure('GitHub API hatası'));
      }
    } catch (e) {
      emit(GitHubValidationFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _httpClient.close();
    return super.close();
  }
}
