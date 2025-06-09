class GitHubRepository {
  final String name;
  final String description;
  final String? language;
  final int stars;
  final int forks;
  final String url;

  GitHubRepository({
    required this.name,
    required this.description,
    this.language,
    required this.stars,
    required this.forks,
    required this.url,
  });

  factory GitHubRepository.fromMap(Map<String, dynamic> map) {
    return GitHubRepository(
      name: map['name'] as String,
      description: map['description'] as String,
      language: map['language'] as String?,
      stars: map['stars'] as int,
      forks: map['forks'] as int,
      url: map['url'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'language': language,
      'stars': stars,
      'forks': forks,
      'url': url,
    };
  }
}
