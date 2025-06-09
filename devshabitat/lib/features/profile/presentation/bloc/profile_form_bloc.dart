import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/models/developer_profile.dart';
import '../../domain/models/certification.dart';
import '../../domain/models/github_repository.dart';
import '../../domain/models/project_showcase.dart';
import '../../domain/models/profile_privacy_settings.dart';

// Events
abstract class ProfileFormEvent extends Equatable {
  const ProfileFormEvent();

  @override
  List<Object?> get props => [];
}

class UpdateBasicInfo extends ProfileFormEvent {
  final String fullName;
  final String title;
  final String? email;
  final String? location;
  final String? bio;
  final String? profileImageUrl;

  const UpdateBasicInfo({
    required this.fullName,
    required this.title,
    this.email,
    this.location,
    this.bio,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [
        fullName,
        title,
        email,
        location,
        bio,
        profileImageUrl,
      ];
}

class UpdateProfessionalDetails extends ProfileFormEvent {
  final ExperienceLevel experienceLevel;
  final String? company;
  final String? position;
  final String? website;

  const UpdateProfessionalDetails({
    required this.experienceLevel,
    this.company,
    this.position,
    this.website,
  });

  @override
  List<Object?> get props => [
        experienceLevel,
        company,
        position,
        website,
      ];
}

class UpdateSkills extends ProfileFormEvent {
  final List<String> skills;

  const UpdateSkills(this.skills);

  @override
  List<Object> get props => [skills];
}

class UpdateGitHubInfo extends ProfileFormEvent {
  final String? username;
  final Map<String, dynamic>? statistics;
  final List<GitHubRepository> featuredRepositories;

  const UpdateGitHubInfo({
    this.username,
    this.statistics,
    required this.featuredRepositories,
  });

  @override
  List<Object?> get props => [
        username,
        statistics,
        featuredRepositories,
      ];
}

class UpdateProjects extends ProfileFormEvent {
  final List<ProjectShowcase> projects;

  const UpdateProjects(this.projects);

  @override
  List<Object> get props => [projects];
}

class UpdateCertifications extends ProfileFormEvent {
  final List<Certification> certifications;

  const UpdateCertifications(this.certifications);

  @override
  List<Object> get props => [certifications];
}

class UpdateSocialLinks extends ProfileFormEvent {
  final Map<String, String> socialLinks;

  const UpdateSocialLinks(this.socialLinks);

  @override
  List<Object> get props => [socialLinks];
}

class UpdatePrivacySettings extends ProfileFormEvent {
  final ProfilePrivacySettings settings;

  const UpdatePrivacySettings(this.settings);

  @override
  List<Object> get props => [settings];
}

class SaveProfile extends ProfileFormEvent {}

// States
abstract class ProfileFormState extends Equatable {
  const ProfileFormState();

  @override
  List<Object?> get props => [];
}

class ProfileFormInitial extends ProfileFormState {}

class ProfileFormLoading extends ProfileFormState {}

class ProfileFormLoaded extends ProfileFormState {
  final DeveloperProfile developerProfile;

  const ProfileFormLoaded(this.developerProfile);

  @override
  List<Object> get props => [developerProfile];
}

class ProfileFormError extends ProfileFormState {
  final String message;

  const ProfileFormError(this.message);

  @override
  List<Object> get props => [message];
}

class ProfileFormSaved extends ProfileFormState {}

// Bloc
class ProfileFormBloc extends Bloc<ProfileFormEvent, ProfileFormState> {
  ProfileFormBloc() : super(ProfileFormInitial()) {
    on<UpdateBasicInfo>(_onUpdateBasicInfo);
    on<UpdateProfessionalDetails>(_onUpdateProfessionalDetails);
    on<UpdateSkills>(_onUpdateSkills);
    on<UpdateGitHubInfo>(_onUpdateGitHubInfo);
    on<UpdateProjects>(_onUpdateProjects);
    on<UpdateCertifications>(_onUpdateCertifications);
    on<UpdateSocialLinks>(_onUpdateSocialLinks);
    on<UpdatePrivacySettings>(_onUpdatePrivacySettings);
    on<SaveProfile>(_onSaveProfile);
  }

  void _onUpdateBasicInfo(
    UpdateBasicInfo event,
    Emitter<ProfileFormState> emit,
  ) {
    if (state is ProfileFormLoaded) {
      final currentProfile = (state as ProfileFormLoaded).developerProfile;
      final updatedProfile = DeveloperProfile(
        id: currentProfile.id,
        userId: currentProfile.userId,
        fullName: event.fullName,
        title: event.title,
        email: event.email,
        location: event.location,
        bio: event.bio,
        profileImageUrl: event.profileImageUrl,
        skills: currentProfile.skills,
        website: currentProfile.website,
        socialLinks: currentProfile.socialLinks,
        gitHubUsername: currentProfile.gitHubUsername,
        gitHubStats: currentProfile.gitHubStats,
        featuredRepositories: currentProfile.featuredRepositories,
        projects: currentProfile.projects,
        certifications: currentProfile.certifications,
        privacySettings: currentProfile.privacySettings,
        experienceLevel: currentProfile.experienceLevel,
        profileCompletionScore: currentProfile.profileCompletionScore,
        lastUpdated: currentProfile.lastUpdated,
      );
      emit(ProfileFormLoaded(updatedProfile));
    }
  }

  void _onUpdateProfessionalDetails(
    UpdateProfessionalDetails event,
    Emitter<ProfileFormState> emit,
  ) {
    if (state is ProfileFormLoaded) {
      final currentProfile = (state as ProfileFormLoaded).developerProfile;
      final updatedProfile = DeveloperProfile(
        id: currentProfile.id,
        userId: currentProfile.userId,
        fullName: currentProfile.fullName,
        title: currentProfile.title,
        bio: currentProfile.bio,
        location: currentProfile.location,
        email: currentProfile.email,
        profileImageUrl: currentProfile.profileImageUrl,
        skills: currentProfile.skills,
        website: event.website,
        socialLinks: currentProfile.socialLinks,
        gitHubUsername: currentProfile.gitHubUsername,
        gitHubStats: currentProfile.gitHubStats,
        featuredRepositories: currentProfile.featuredRepositories,
        projects: currentProfile.projects,
        certifications: currentProfile.certifications,
        privacySettings: currentProfile.privacySettings,
        experienceLevel: event.experienceLevel,
        profileCompletionScore: currentProfile.profileCompletionScore,
        lastUpdated: currentProfile.lastUpdated,
      );
      emit(ProfileFormLoaded(updatedProfile));
    }
  }

  void _onUpdateSkills(
    UpdateSkills event,
    Emitter<ProfileFormState> emit,
  ) {
    if (state is ProfileFormLoaded) {
      final currentProfile = (state as ProfileFormLoaded).developerProfile;
      final updatedProfile = DeveloperProfile(
        id: currentProfile.id,
        userId: currentProfile.userId,
        fullName: currentProfile.fullName,
        title: currentProfile.title,
        bio: currentProfile.bio,
        location: currentProfile.location,
        email: currentProfile.email,
        profileImageUrl: currentProfile.profileImageUrl,
        skills: event.skills,
        website: currentProfile.website,
        socialLinks: currentProfile.socialLinks,
        gitHubUsername: currentProfile.gitHubUsername,
        gitHubStats: currentProfile.gitHubStats,
        featuredRepositories: currentProfile.featuredRepositories,
        projects: currentProfile.projects,
        certifications: currentProfile.certifications,
        privacySettings: currentProfile.privacySettings,
        experienceLevel: currentProfile.experienceLevel,
        profileCompletionScore: currentProfile.profileCompletionScore,
        lastUpdated: currentProfile.lastUpdated,
      );
      emit(ProfileFormLoaded(updatedProfile));
    }
  }

  void _onUpdateGitHubInfo(
    UpdateGitHubInfo event,
    Emitter<ProfileFormState> emit,
  ) {
    if (state is ProfileFormLoaded) {
      final currentProfile = (state as ProfileFormLoaded).developerProfile;
      final updatedProfile = DeveloperProfile(
        id: currentProfile.id,
        userId: currentProfile.userId,
        fullName: currentProfile.fullName,
        title: currentProfile.title,
        bio: currentProfile.bio,
        location: currentProfile.location,
        email: currentProfile.email,
        profileImageUrl: currentProfile.profileImageUrl,
        skills: currentProfile.skills,
        website: currentProfile.website,
        socialLinks: currentProfile.socialLinks,
        gitHubUsername: event.username,
        gitHubStats: event.statistics,
        featuredRepositories: event.featuredRepositories,
        projects: currentProfile.projects,
        certifications: currentProfile.certifications,
        privacySettings: currentProfile.privacySettings,
        experienceLevel: currentProfile.experienceLevel,
        profileCompletionScore: currentProfile.profileCompletionScore,
        lastUpdated: currentProfile.lastUpdated,
      );
      emit(ProfileFormLoaded(updatedProfile));
    }
  }

  void _onUpdateProjects(
    UpdateProjects event,
    Emitter<ProfileFormState> emit,
  ) {
    if (state is ProfileFormLoaded) {
      final currentProfile = (state as ProfileFormLoaded).developerProfile;
      final updatedProfile = DeveloperProfile(
        id: currentProfile.id,
        userId: currentProfile.userId,
        fullName: currentProfile.fullName,
        title: currentProfile.title,
        bio: currentProfile.bio,
        location: currentProfile.location,
        email: currentProfile.email,
        profileImageUrl: currentProfile.profileImageUrl,
        skills: currentProfile.skills,
        website: currentProfile.website,
        socialLinks: currentProfile.socialLinks,
        gitHubUsername: currentProfile.gitHubUsername,
        gitHubStats: currentProfile.gitHubStats,
        featuredRepositories: currentProfile.featuredRepositories,
        projects: event.projects,
        certifications: currentProfile.certifications,
        privacySettings: currentProfile.privacySettings,
        experienceLevel: currentProfile.experienceLevel,
        profileCompletionScore: currentProfile.profileCompletionScore,
        lastUpdated: currentProfile.lastUpdated,
      );
      emit(ProfileFormLoaded(updatedProfile));
    }
  }

  void _onUpdateCertifications(
    UpdateCertifications event,
    Emitter<ProfileFormState> emit,
  ) {
    if (state is ProfileFormLoaded) {
      final currentProfile = (state as ProfileFormLoaded).developerProfile;
      final updatedProfile = DeveloperProfile(
        id: currentProfile.id,
        userId: currentProfile.userId,
        fullName: currentProfile.fullName,
        title: currentProfile.title,
        bio: currentProfile.bio,
        location: currentProfile.location,
        email: currentProfile.email,
        profileImageUrl: currentProfile.profileImageUrl,
        skills: currentProfile.skills,
        website: currentProfile.website,
        socialLinks: currentProfile.socialLinks,
        gitHubUsername: currentProfile.gitHubUsername,
        gitHubStats: currentProfile.gitHubStats,
        featuredRepositories: currentProfile.featuredRepositories,
        projects: currentProfile.projects,
        certifications: event.certifications,
        privacySettings: currentProfile.privacySettings,
        experienceLevel: currentProfile.experienceLevel,
        profileCompletionScore: currentProfile.profileCompletionScore,
        lastUpdated: currentProfile.lastUpdated,
      );
      emit(ProfileFormLoaded(updatedProfile));
    }
  }

  void _onUpdateSocialLinks(
    UpdateSocialLinks event,
    Emitter<ProfileFormState> emit,
  ) {
    if (state is ProfileFormLoaded) {
      final currentProfile = (state as ProfileFormLoaded).developerProfile;
      final updatedProfile = DeveloperProfile(
        id: currentProfile.id,
        userId: currentProfile.userId,
        fullName: currentProfile.fullName,
        title: currentProfile.title,
        bio: currentProfile.bio,
        location: currentProfile.location,
        email: currentProfile.email,
        profileImageUrl: currentProfile.profileImageUrl,
        skills: currentProfile.skills,
        website: currentProfile.website,
        socialLinks: event.socialLinks,
        gitHubUsername: currentProfile.gitHubUsername,
        gitHubStats: currentProfile.gitHubStats,
        featuredRepositories: currentProfile.featuredRepositories,
        projects: currentProfile.projects,
        certifications: currentProfile.certifications,
        privacySettings: currentProfile.privacySettings,
        experienceLevel: currentProfile.experienceLevel,
        profileCompletionScore: currentProfile.profileCompletionScore,
        lastUpdated: currentProfile.lastUpdated,
      );
      emit(ProfileFormLoaded(updatedProfile));
    }
  }

  void _onUpdatePrivacySettings(
    UpdatePrivacySettings event,
    Emitter<ProfileFormState> emit,
  ) {
    if (state is ProfileFormLoaded) {
      final currentProfile = (state as ProfileFormLoaded).developerProfile;
      final updatedProfile = DeveloperProfile(
        id: currentProfile.id,
        userId: currentProfile.userId,
        fullName: currentProfile.fullName,
        title: currentProfile.title,
        bio: currentProfile.bio,
        location: currentProfile.location,
        email: currentProfile.email,
        profileImageUrl: currentProfile.profileImageUrl,
        skills: currentProfile.skills,
        website: currentProfile.website,
        socialLinks: currentProfile.socialLinks,
        gitHubUsername: currentProfile.gitHubUsername,
        gitHubStats: currentProfile.gitHubStats,
        featuredRepositories: currentProfile.featuredRepositories,
        projects: currentProfile.projects,
        certifications: currentProfile.certifications,
        privacySettings: event.settings,
        experienceLevel: currentProfile.experienceLevel,
        profileCompletionScore: currentProfile.profileCompletionScore,
        lastUpdated: currentProfile.lastUpdated,
      );
      emit(ProfileFormLoaded(updatedProfile));
    }
  }

  void _onSaveProfile(
    SaveProfile event,
    Emitter<ProfileFormState> emit,
  ) async {
    if (state is ProfileFormLoaded) {
      emit(ProfileFormLoading());
      try {
        // TODO: Implement save functionality
        emit(ProfileFormSaved());
      } catch (e) {
        emit(ProfileFormError(e.toString()));
      }
    }
  }
}
