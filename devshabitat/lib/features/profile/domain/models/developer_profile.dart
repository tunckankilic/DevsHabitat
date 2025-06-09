import 'package:devshabitat/features/profile/domain/models/certification.dart';
import 'package:devshabitat/features/profile/domain/models/project_showcase.dart';
import 'package:equatable/equatable.dart';
import 'profile_privacy_settings.dart';
import 'github_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'education.dart';

enum ExperienceLevel { junior, mid, senior, lead }

class DeveloperProfile extends Equatable {
  final String id;
  final String userId;
  final String fullName;
  final String title;
  final String? bio;
  final String? location;
  final String? email;
  final String? phone;
  final String? website;
  final String? profileImageUrl;
  final Map<String, String> socialLinks;
  final List<String> skills;
  final ExperienceLevel experienceLevel;
  final String? company;
  final String? position;
  final List<Education> education;
  final List<String> languages;
  final String? gitHubUsername;
  final Map<String, dynamic>? gitHubStats;
  final List<GitHubRepository> featuredRepositories;
  final List<ProjectShowcase> projects;
  final List<Certification> certifications;
  final ProfilePrivacySettings privacySettings;
  final double profileCompletionScore;
  final DateTime lastUpdated;

  const DeveloperProfile({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.title,
    this.bio,
    this.location,
    this.email,
    this.phone,
    this.website,
    this.profileImageUrl,
    this.socialLinks = const {},
    this.skills = const [],
    this.experienceLevel = ExperienceLevel.junior,
    this.company,
    this.position,
    this.education = const [],
    this.languages = const [],
    this.gitHubUsername,
    this.gitHubStats,
    this.featuredRepositories = const [],
    this.projects = const [],
    this.certifications = const [],
    required this.privacySettings,
    required this.profileCompletionScore,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        fullName,
        title,
        bio,
        location,
        email,
        phone,
        website,
        profileImageUrl,
        socialLinks,
        skills,
        experienceLevel,
        company,
        position,
        education,
        languages,
        gitHubUsername,
        gitHubStats,
        featuredRepositories,
        projects,
        certifications,
        privacySettings,
        profileCompletionScore,
        lastUpdated,
      ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'fullName': fullName,
      'title': title,
      'bio': bio,
      'location': location,
      'email': email,
      'phone': phone,
      'website': website,
      'profileImageUrl': profileImageUrl,
      'socialLinks': socialLinks,
      'skills': skills,
      'experienceLevel': experienceLevel.toString(),
      'company': company,
      'position': position,
      'education': education.map((e) => e.toMap()).toList(),
      'languages': languages,
      'gitHubUsername': gitHubUsername,
      'gitHubStats': gitHubStats,
      'featuredRepositories':
          featuredRepositories.map((r) => r.toMap()).toList(),
      'projects': projects.map((p) => p.toMap()).toList(),
      'certifications': certifications.map((c) => c.toMap()).toList(),
      'privacySettings': privacySettings.toMap(),
      'profileCompletionScore': profileCompletionScore,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory DeveloperProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DeveloperProfile(
      id: doc.id,
      userId: data['userId'] as String,
      fullName: data['fullName'] as String,
      title: data['title'] as String,
      bio: data['bio'] as String?,
      location: data['location'] as String?,
      email: data['email'] as String?,
      phone: data['phone'] as String?,
      website: data['website'] as String?,
      profileImageUrl: data['profileImageUrl'] as String?,
      socialLinks: Map<String, String>.from(data['socialLinks'] ?? {}),
      skills: List<String>.from(data['skills'] ?? []),
      experienceLevel: ExperienceLevel.values.firstWhere(
        (e) => e.toString() == data['experienceLevel'],
        orElse: () => ExperienceLevel.junior,
      ),
      company: data['company'] as String?,
      position: data['position'] as String?,
      education: (data['education'] as List<dynamic>?)
              ?.map((e) => Education.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      languages: List<String>.from(data['languages'] ?? []),
      gitHubUsername: data['gitHubUsername'] as String?,
      gitHubStats: data['gitHubStats'] as Map<String, dynamic>?,
      featuredRepositories: (data['featuredRepositories'] as List<dynamic>?)
              ?.map((r) => GitHubRepository.fromMap(r as Map<String, dynamic>))
              .toList() ??
          [],
      projects: (data['projects'] as List<dynamic>?)
              ?.map((p) => ProjectShowcase.fromMap(p as Map<String, dynamic>))
              .toList() ??
          [],
      certifications: (data['certifications'] as List<dynamic>?)
              ?.map((c) => Certification.fromMap(c as Map<String, dynamic>))
              .toList() ??
          [],
      privacySettings: ProfilePrivacySettings.fromMap(
          data['privacySettings'] as Map<String, dynamic>? ?? {}),
      profileCompletionScore:
          (data['profileCompletionScore'] as num?)?.toDouble() ?? 0.0,
      lastUpdated: DateTime.parse(data['lastUpdated'] as String),
    );
  }
}
