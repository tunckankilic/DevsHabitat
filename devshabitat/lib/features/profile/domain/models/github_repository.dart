import 'package:equatable/equatable.dart';

class GitHubRepository extends Equatable {
  final String id;
  final String name;
  final String description;
  final String url;
  final String language;
  final int stars;
  final int forks;
  final DateTime lastUpdated;

  const GitHubRepository({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.language,
    required this.stars,
    required this.forks,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        url,
        language,
        stars,
        forks,
        lastUpdated,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'url': url,
      'language': language,
      'stars': stars,
      'forks': forks,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory GitHubRepository.fromJson(Map<String, dynamic> json) {
    return GitHubRepository(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      language: json['language'] as String,
      stars: json['stars'] as int,
      forks: json['forks'] as int,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }
}
