import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'base_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String username,
    String? displayName,
    String? photoUrl,
    String? bio,
    List<String>? skills,
    List<String>? interests,
    Map<String, dynamic>? socialLinks,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

class User extends Equatable {
  final String id;
  final String email;
  final String username;
  final String? displayName;
  final String? photoUrl;
  final String? bio;
  final List<String>? skills;
  final List<String>? interests;
  final Map<String, dynamic>? socialLinks;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.username,
    this.displayName,
    this.photoUrl,
    this.bio,
    this.skills,
    this.interests,
    this.socialLinks,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromModel(UserModel model) {
    return User(
      id: model.id,
      email: model.email,
      username: model.username,
      displayName: model.displayName,
      photoUrl: model.photoUrl,
      bio: model.bio,
      skills: model.skills,
      interests: model.interests,
      socialLinks: model.socialLinks,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  UserModel toModel() {
    return UserModel(
      id: id,
      email: email,
      username: username,
      displayName: displayName,
      photoUrl: photoUrl,
      bio: bio,
      skills: skills,
      interests: interests,
      socialLinks: socialLinks,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? displayName,
    String? photoUrl,
    String? bio,
    List<String>? skills,
    List<String>? interests,
    Map<String, dynamic>? socialLinks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      interests: interests ?? this.interests,
      socialLinks: socialLinks ?? this.socialLinks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        displayName,
        photoUrl,
        bio,
        skills,
        interests,
        socialLinks,
        createdAt,
        updatedAt,
      ];
}
