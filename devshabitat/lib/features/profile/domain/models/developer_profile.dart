import 'package:devshabitat/features/profile/domain/models/certification.dart';
import 'package:devshabitat/features/profile/domain/models/project_showcase.dart';
import 'package:equatable/equatable.dart';
import 'profile_privacy_settings.dart';
import 'github_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ExperienceLevel { junior, mid, senior, lead }

class DeveloperProfile extends Equatable {
  final String id;
  final String userId;
  final String displayName;
  final String? bio;
  final String? avatarUrl;
  final List<String> skills;
  final String? location;
  final String? email;
  final String? profileImageUrl;
  final String? website;
  final Map<String, String> socialLinks;
  final String? gitHubUsername;
  final Map<String, dynamic>? gitHubStats;
  final List<GitHubRepository> featuredRepositories;
  final List<ProjectShowcase> projects;
  final List<Certification> certifications;
  final ProfilePrivacySettings privacySettings;
  final ExperienceLevel experienceLevel;
  final double profileCompletionScore;
  final DateTime? lastUpdated;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DeveloperProfile({
    required this.id,
    required this.userId,
    required this.displayName,
    this.bio,
    this.avatarUrl,
    required this.skills,
    this.location,
    this.email,
    this.profileImageUrl,
    this.website,
    this.socialLinks = const {},
    this.gitHubUsername,
    this.gitHubStats,
    this.featuredRepositories = const [],
    this.projects = const [],
    this.certifications = const [],
    required this.privacySettings,
    required this.experienceLevel,
    this.profileCompletionScore = 0.0,
    this.lastUpdated,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        displayName,
        bio,
        avatarUrl,
        skills,
        location,
        email,
        profileImageUrl,
        website,
        socialLinks,
        gitHubUsername,
        gitHubStats,
        featuredRepositories,
        projects,
        certifications,
        privacySettings,
        experienceLevel,
        profileCompletionScore,
        lastUpdated,
        createdAt,
        updatedAt,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'displayName': displayName,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'skills': skills,
      'location': location,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'website': website,
      'socialLinks': socialLinks,
      'gitHubUsername': gitHubUsername,
      'gitHubStats': gitHubStats,
      'featuredRepositories':
          featuredRepositories.map((r) => r.toJson()).toList(),
      'projects': projects.map((p) => p.toJson()).toList(),
      'certifications': certifications.map((c) => c.toJson()).toList(),
      'privacySettings': privacySettings.toJson(),
      'experienceLevel': experienceLevel.toString(),
      'profileCompletionScore': profileCompletionScore,
      'lastUpdated': lastUpdated?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory DeveloperProfile.fromJson(Map<String, dynamic> json) {
    return DeveloperProfile(
      id: json['id'] as String,
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      bio: json['bio'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      skills: List<String>.from(json['skills'] ?? []),
      location: json['location'] as String?,
      email: json['email'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      website: json['website'] as String?,
      socialLinks: Map<String, String>.from(json['socialLinks'] ?? {}),
      gitHubUsername: json['gitHubUsername'] as String?,
      gitHubStats: json['gitHubStats'] as Map<String, dynamic>?,
      featuredRepositories: (json['featuredRepositories'] as List<dynamic>?)
              ?.map((e) => GitHubRepository.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      projects: (json['projects'] as List<dynamic>?)
              ?.map((e) => ProjectShowcase.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((e) => Certification.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      privacySettings: ProfilePrivacySettings.fromJson(
          json['privacySettings'] as Map<String, dynamic>),
      experienceLevel: ExperienceLevel.values.firstWhere(
          (e) => e.toString() == json['experienceLevel'],
          orElse: () => ExperienceLevel.junior),
      profileCompletionScore:
          (json['profileCompletionScore'] as num?)?.toDouble() ?? 0.0,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  factory DeveloperProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DeveloperProfile.fromJson({
      'id': doc.id,
      ...data,
    });
  }

  Map<String, dynamic> toMap() => toJson();
}
