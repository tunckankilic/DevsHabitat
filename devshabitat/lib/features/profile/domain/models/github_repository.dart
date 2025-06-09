import 'package:equatable/equatable.dart';

class GitHubRepository extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? language;
  final int stars;
  final int forks;
  final String url;
  final DateTime lastUpdated;

  const GitHubRepository({
    required this.id,
    required this.name,
    this.description,
    this.language,
    required this.stars,
    required this.forks,
    required this.url,
    required this.lastUpdated,
  });

  factory GitHubRepository.fromMap(Map<String, dynamic> map) {
    return GitHubRepository(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      url: map['url'] as String,
      stars: map['stars'] as int,
      forks: map['forks'] as int,
      language: map['language'] as String?,
      lastUpdated: DateTime.parse(map['lastUpdated'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'url': url,
      'stars': stars,
      'forks': forks,
      'language': language,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        language,
        stars,
        forks,
        url,
        lastUpdated,
      ];
}
