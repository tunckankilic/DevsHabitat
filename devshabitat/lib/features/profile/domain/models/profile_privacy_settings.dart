import 'package:equatable/equatable.dart';

class ProfilePrivacySettings extends Equatable {
  final bool isProfilePublic;
  final bool isEmailPublic;
  final bool isGitHubPublic;
  final bool isProjectsPublic;
  final bool isCertificationsPublic;
  final bool isSocialLinksPublic;

  const ProfilePrivacySettings({
    required this.isProfilePublic,
    required this.isEmailPublic,
    required this.isGitHubPublic,
    required this.isProjectsPublic,
    required this.isCertificationsPublic,
    required this.isSocialLinksPublic,
  });

  ProfilePrivacySettings copyWith({
    bool? isProfilePublic,
    bool? isEmailPublic,
    bool? isGitHubPublic,
    bool? isProjectsPublic,
    bool? isCertificationsPublic,
    bool? isSocialLinksPublic,
  }) {
    return ProfilePrivacySettings(
      isProfilePublic: isProfilePublic ?? this.isProfilePublic,
      isEmailPublic: isEmailPublic ?? this.isEmailPublic,
      isGitHubPublic: isGitHubPublic ?? this.isGitHubPublic,
      isProjectsPublic: isProjectsPublic ?? this.isProjectsPublic,
      isCertificationsPublic:
          isCertificationsPublic ?? this.isCertificationsPublic,
      isSocialLinksPublic: isSocialLinksPublic ?? this.isSocialLinksPublic,
    );
  }

  factory ProfilePrivacySettings.fromMap(Map<String, dynamic> map) {
    return ProfilePrivacySettings(
      isProfilePublic: map['isProfilePublic'] as bool? ?? false,
      isEmailPublic: map['isEmailPublic'] as bool? ?? false,
      isGitHubPublic: map['isGitHubPublic'] as bool? ?? false,
      isProjectsPublic: map['isProjectsPublic'] as bool? ?? false,
      isCertificationsPublic: map['isCertificationsPublic'] as bool? ?? false,
      isSocialLinksPublic: map['isSocialLinksPublic'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isProfilePublic': isProfilePublic,
      'isEmailPublic': isEmailPublic,
      'isGitHubPublic': isGitHubPublic,
      'isProjectsPublic': isProjectsPublic,
      'isCertificationsPublic': isCertificationsPublic,
      'isSocialLinksPublic': isSocialLinksPublic,
    };
  }

  @override
  List<Object?> get props => [
        isProfilePublic,
        isEmailPublic,
        isGitHubPublic,
        isProjectsPublic,
        isCertificationsPublic,
        isSocialLinksPublic,
      ];
}
