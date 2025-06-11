import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class User extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoURL;
  final List<String> connections;
  final Map<String, dynamic> preferences;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSeen;
  final List<String>? skills;
  final List<Map<String, dynamic>>? experience;
  final String? githubUsername;
  final String? githubAvatarUrl;
  final String? githubId;
  final Map<String, dynamic>? githubData;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoURL,
    this.connections = const [],
    this.preferences = const {},
    required this.createdAt,
    required this.updatedAt,
    this.lastSeen,
    this.skills,
    this.experience,
    this.githubUsername,
    this.githubAvatarUrl,
    this.githubId,
    this.githubData,
  });

  factory User.fromFirebase(firebase_auth.User user) {
    return User(
      id: user.uid,
      email: user.email!,
      displayName: user.displayName,
      photoURL: user.photoURL,
      createdAt: user.metadata.creationTime ?? DateTime.now(),
      updatedAt: user.metadata.lastSignInTime ?? DateTime.now(),
    );
  }

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      email: data['email'] as String,
      displayName: data['displayName'] as String?,
      photoURL: data['photoURL'] as String?,
      connections: List<String>.from(data['connections'] ?? []),
      preferences: data['preferences'] as Map<String, dynamic>? ?? {},
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  factory User.fromGitHub({
    required String id,
    required String email,
    required String name,
    required String githubUsername,
    required String githubAvatarUrl,
    required String githubId,
    required Map<String, dynamic> githubData,
  }) {
    return User(
      id: id,
      email: email,
      displayName: name,
      photoURL: githubAvatarUrl,
      preferences: {
        'github': {
          'username': githubUsername,
          'id': githubId,
          'data': githubData,
        },
      },
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'connections': connections,
      'preferences': preferences,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoURL,
    List<String>? connections,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      connections: connections ?? this.connections,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoURL,
        connections,
        preferences,
        createdAt,
        updatedAt,
      ];

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoURL: json['photoURL'] as String?,
      connections: List<String>.from(json['connections'] ?? []),
      preferences: json['preferences'] as Map<String, dynamic>? ?? {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastSeen: json['lastSeen'] != null
          ? DateTime.parse(json['lastSeen'] as String)
          : null,
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
      experience: json['experience'] != null
          ? List<Map<String, dynamic>>.from(json['experience'])
          : null,
      githubUsername: json['githubUsername'] as String?,
      githubAvatarUrl: json['githubAvatarUrl'] as String?,
      githubId: json['githubId'] as String?,
      githubData: json['githubData'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'connections': connections,
      'preferences': preferences,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastSeen': lastSeen?.toIso8601String(),
      'skills': skills,
      'experience': experience,
      'githubUsername': githubUsername,
      'githubAvatarUrl': githubAvatarUrl,
      'githubId': githubId,
      'githubData': githubData,
    };
  }
}
