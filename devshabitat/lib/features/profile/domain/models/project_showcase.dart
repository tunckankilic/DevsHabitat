import 'package:equatable/equatable.dart';

class ProjectShowcase extends Equatable {
  final String id;
  final String title;
  final String description;
  final List<String> imageUrls;
  final String? liveUrl;
  final String? repoUrl;
  final List<String> technologies;
  final DateTime startDate;
  final DateTime? endDate;

  const ProjectShowcase({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrls = const [],
    this.liveUrl,
    this.repoUrl,
    required this.technologies,
    required this.startDate,
    this.endDate,
    String? projectUrl,
    String? imageUrl,
  });

  factory ProjectShowcase.fromMap(Map<String, dynamic> map) {
    return ProjectShowcase(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      imageUrls: List<String>.from(map['imageUrls'] as List? ?? []),
      liveUrl: map['liveUrl'] as String?,
      repoUrl: map['repoUrl'] as String?,
      technologies: List<String>.from(map['technologies'] as List),
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: map['endDate'] != null
          ? DateTime.parse(map['endDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrls': imageUrls,
      'liveUrl': liveUrl,
      'repoUrl': repoUrl,
      'technologies': technologies,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrls,
        liveUrl,
        repoUrl,
        technologies,
        startDate,
        endDate,
      ];
}
