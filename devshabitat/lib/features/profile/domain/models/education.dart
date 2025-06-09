import 'package:equatable/equatable.dart';

class Education extends Equatable {
  final String school;
  final String degree;
  final String field;
  final DateTime startDate;
  final DateTime? endDate;
  final String? description;

  const Education({
    required this.school,
    required this.degree,
    required this.field,
    required this.startDate,
    this.endDate,
    this.description,
  });

  @override
  List<Object?> get props => [
        school,
        degree,
        field,
        startDate,
        endDate,
        description,
      ];

  Map<String, dynamic> toMap() {
    return {
      'school': school,
      'degree': degree,
      'field': field,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'description': description,
    };
  }

  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      school: map['school'] as String,
      degree: map['degree'] as String,
      field: map['field'] as String,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: map['endDate'] != null
          ? DateTime.parse(map['endDate'] as String)
          : null,
      description: map['description'] as String?,
    );
  }
}
