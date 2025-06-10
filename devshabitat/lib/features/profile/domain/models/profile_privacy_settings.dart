import 'package:equatable/equatable.dart';

class ProfilePrivacySettings extends Equatable {
  final bool isProfilePublic;
  final bool showEmail;
  final bool showLocation;
  final bool showSocialLinks;
  final bool showGitHubStats;
  final bool showProjects;
  final bool showCertifications;
  final bool allowMessages;
  final bool showOnlineStatus;

  const ProfilePrivacySettings({
    this.isProfilePublic = true,
    this.showEmail = false,
    this.showLocation = true,
    this.showSocialLinks = true,
    this.showGitHubStats = true,
    this.showProjects = true,
    this.showCertifications = true,
    this.allowMessages = true,
    this.showOnlineStatus = true,
  });

  @override
  List<Object?> get props => [
        isProfilePublic,
        showEmail,
        showLocation,
        showSocialLinks,
        showGitHubStats,
        showProjects,
        showCertifications,
        allowMessages,
        showOnlineStatus,
      ];

  Map<String, dynamic> toJson() {
    return {
      'isProfilePublic': isProfilePublic,
      'showEmail': showEmail,
      'showLocation': showLocation,
      'showSocialLinks': showSocialLinks,
      'showGitHubStats': showGitHubStats,
      'showProjects': showProjects,
      'showCertifications': showCertifications,
      'allowMessages': allowMessages,
      'showOnlineStatus': showOnlineStatus,
    };
  }

  factory ProfilePrivacySettings.fromJson(Map<String, dynamic> json) {
    return ProfilePrivacySettings(
      isProfilePublic: json['isProfilePublic'] as bool? ?? true,
      showEmail: json['showEmail'] as bool? ?? false,
      showLocation: json['showLocation'] as bool? ?? true,
      showSocialLinks: json['showSocialLinks'] as bool? ?? true,
      showGitHubStats: json['showGitHubStats'] as bool? ?? true,
      showProjects: json['showProjects'] as bool? ?? true,
      showCertifications: json['showCertifications'] as bool? ?? true,
      allowMessages: json['allowMessages'] as bool? ?? true,
      showOnlineStatus: json['showOnlineStatus'] as bool? ?? true,
    );
  }

  ProfilePrivacySettings copyWith({
    bool? isProfilePublic,
    bool? showEmail,
    bool? showLocation,
    bool? showSocialLinks,
    bool? showGitHubStats,
    bool? showProjects,
    bool? showCertifications,
    bool? allowMessages,
    bool? showOnlineStatus,
  }) {
    return ProfilePrivacySettings(
      isProfilePublic: isProfilePublic ?? this.isProfilePublic,
      showEmail: showEmail ?? this.showEmail,
      showLocation: showLocation ?? this.showLocation,
      showSocialLinks: showSocialLinks ?? this.showSocialLinks,
      showGitHubStats: showGitHubStats ?? this.showGitHubStats,
      showProjects: showProjects ?? this.showProjects,
      showCertifications: showCertifications ?? this.showCertifications,
      allowMessages: allowMessages ?? this.allowMessages,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
    );
  }
}
