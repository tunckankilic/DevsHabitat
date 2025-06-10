import 'package:equatable/equatable.dart';

class ProjectShowcase extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String? demoUrl;
  final String? sourceCodeUrl;
  final List<String> technologies;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProjectShowcase({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.demoUrl,
    this.sourceCodeUrl,
    required this.technologies,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        demoUrl,
        sourceCodeUrl,
        technologies,
        createdAt,
        updatedAt,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'demoUrl': demoUrl,
      'sourceCodeUrl': sourceCodeUrl,
      'technologies': technologies,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ProjectShowcase.fromJson(Map<String, dynamic> json) {
    return ProjectShowcase(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      demoUrl: json['demoUrl'] as String?,
      sourceCodeUrl: json['sourceCodeUrl'] as String?,
      technologies: List<String>.from(json['technologies'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
