import 'package:equatable/equatable.dart';

class Certification extends Equatable {
  final String id;
  final String title;
  final String issuer;
  final String? description;
  final String? credentialUrl;
  final DateTime issueDate;
  final DateTime? expiryDate;
  final String? credentialId;

  const Certification({
    required this.id,
    required this.title,
    required this.issuer,
    this.description,
    this.credentialUrl,
    required this.issueDate,
    this.expiryDate,
    this.credentialId,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        issuer,
        description,
        credentialUrl,
        issueDate,
        expiryDate,
        credentialId,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'issuer': issuer,
      'description': description,
      'credentialUrl': credentialUrl,
      'issueDate': issueDate.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'credentialId': credentialId,
    };
  }

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      id: json['id'] as String,
      title: json['title'] as String,
      issuer: json['issuer'] as String,
      description: json['description'] as String?,
      credentialUrl: json['credentialUrl'] as String?,
      issueDate: DateTime.parse(json['issueDate'] as String),
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
      credentialId: json['credentialId'] as String?,
    );
  }
}
