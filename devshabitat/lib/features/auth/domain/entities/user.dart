class User {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final List<String> skills;
  final Map<String, dynamic> experience;
  final Map<String, dynamic> preferences;
  final List<String> connections;
  final DateTime? lastSeen;
  final String? githubUsername;
  final String? githubAvatarUrl;
  final String? githubId;
  final Map<String, dynamic> githubData;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.skills = const [],
    this.experience = const {},
    this.preferences = const {},
    this.connections = const [],
    this.lastSeen,
    this.githubUsername,
    this.githubAvatarUrl,
    this.githubId,
    this.githubData = const {},
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        email: json['email'] as String,
        name: json['name'] as String,
        avatar: json['avatar'] as String?,
        skills: List<String>.from(json['skills'] ?? []),
        experience: Map<String, dynamic>.from(json['experience'] ?? {}),
        preferences: Map<String, dynamic>.from(json['preferences'] ?? {}),
        connections: List<String>.from(json['connections'] ?? []),
        lastSeen: json['lastSeen'] != null
            ? DateTime.parse(json['lastSeen'] as String)
            : null,
        githubUsername: json['githubUsername'] as String?,
        githubAvatarUrl: json['githubAvatarUrl'] as String?,
        githubId: json['githubId'] as String?,
        githubData: Map<String, dynamic>.from(json['githubData'] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'avatar': avatar,
        'skills': skills,
        'experience': experience,
        'preferences': preferences,
        'connections': connections,
        'lastSeen': lastSeen?.toIso8601String(),
        'githubUsername': githubUsername,
        'githubAvatarUrl': githubAvatarUrl,
        'githubId': githubId,
        'githubData': githubData,
      };

  factory User.fromGitHub({
    required String id,
    required String email,
    required String name,
    required String githubUsername,
    required String githubAvatarUrl,
    required String githubId,
    Map<String, dynamic>? githubData,
  }) {
    return User(
      id: id,
      email: email,
      name: name,
      avatar: githubAvatarUrl,
      githubUsername: githubUsername,
      githubAvatarUrl: githubAvatarUrl,
      githubId: githubId,
      githubData: githubData ?? {},
    );
  }
}
