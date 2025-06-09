import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/models/developer_profile.dart';
import '../../domain/usecases/get_profile_usecase.dart';

// Events
abstract class ProfileViewEvent extends Equatable {
  const ProfileViewEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileViewEvent {
  final String userId;

  const LoadProfile(this.userId);

  @override
  List<Object?> get props => [userId];
}

// States
abstract class ProfileViewState extends Equatable {
  const ProfileViewState();

  @override
  List<Object?> get props => [];
}

class ProfileViewInitial extends ProfileViewState {}

class ProfileViewLoading extends ProfileViewState {}

class ProfileViewLoaded extends ProfileViewState {
  final DeveloperProfile profile;

  const ProfileViewLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileViewError extends ProfileViewState {
  final String message;

  const ProfileViewError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class ProfileViewBloc extends Bloc<ProfileViewEvent, ProfileViewState> {
  final GetProfileUseCase getProfileUseCase;

  ProfileViewBloc({
    required this.getProfileUseCase,
  }) : super(ProfileViewInitial()) {
    on<LoadProfile>(_onLoadProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileViewState> emit,
  ) async {
    emit(ProfileViewLoading());
    try {
      final profile = await getProfileUseCase(event.userId);
      emit(ProfileViewLoaded(profile));
    } catch (e) {
      emit(ProfileViewError(e.toString()));
    }
  }
}
