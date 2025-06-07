import 'package:devshabitat/features/auth/domain/entities/user.dart';

class GitHubUserModel {
  final String id;
  final String login;
  final String name;
  final String? email;
  final String? avatarUrl;
  final String? bio;
  final String? company;
  final String? location;
  final String? blog;
  final int? publicRepos;
  final int? followers;
  final int? following;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const GitHubUserModel({
    required this.id,
    required this.login,
    required this.name,
    this.email,
    this.avatarUrl,
    this.bio,
    this.company,
    this.location,
    this.blog,
    this.publicRepos,
    this.followers,
    this.following,
    this.createdAt,
    this.updatedAt,
  });

  factory GitHubUserModel.fromJson(Map<String, dynamic> json) =>
      GitHubUserModel(
        id: json['id'].toString(),
        login: json['login'] as String,
        name: json['name'] as String,
        email: json['email'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        bio: json['bio'] as String?,
        company: json['company'] as String?,
        location: json['location'] as String?,
        blog: json['blog'] as String?,
        publicRepos: json['public_repos'] as int?,
        followers: json['followers'] as int?,
        following: json['following'] as int?,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'login': login,
        'name': name,
        'email': email,
        'avatar_url': avatarUrl,
        'bio': bio,
        'company': company,
        'location': location,
        'blog': blog,
        'public_repos': publicRepos,
        'followers': followers,
        'following': following,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  User toUser(String firebaseUid) {
    return User.fromGitHub(
      id: firebaseUid,
      email: email ?? 'no-email@github.com',
      name: name,
      githubUsername: login,
      githubAvatarUrl: avatarUrl?.toString() ?? "",
      githubId: id,
      githubData: toJson(),
    );
  }
}
