import 'package:equatable/equatable.dart';

class Certification extends Equatable {
  final String id;
  final String name;
  final String issuer;
  final DateTime issueDate;
  final DateTime? expiryDate;
  final String? credentialUrl;
  final String? credentialId;

  const Certification({
    required this.id,
    required this.name,
    required this.issuer,
    required this.issueDate,
    this.expiryDate,
    this.credentialUrl,
    this.credentialId,
  });

  factory Certification.fromMap(Map<String, dynamic> map) {
    return Certification(
      id: map['id'] as String,
      name: map['name'] as String,
      issuer: map['issuer'] as String,
      issueDate: DateTime.parse(map['issueDate'] as String),
      expiryDate: map['expiryDate'] != null
          ? DateTime.parse(map['expiryDate'] as String)
          : null,
      credentialUrl: map['credentialUrl'] as String?,
      credentialId: map['credentialId'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'issuer': issuer,
      'issueDate': issueDate.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'credentialUrl': credentialUrl,
      'credentialId': credentialId,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        issuer,
        issueDate,
        expiryDate,
        credentialUrl,
        credentialId,
      ];
}
