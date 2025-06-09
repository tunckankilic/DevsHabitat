class GitHubUserData {
  final String login;
  final String name;
  final String? bio;
  final String? avatarUrl;
  final int publicRepos;
  final int followers;
  final int following;

  GitHubUserData({
    required this.login,
    required this.name,
    this.bio,
    this.avatarUrl,
    required this.publicRepos,
    required this.followers,
    required this.following,
  });

  factory GitHubUserData.fromJson(Map<String, dynamic> json) {
    return GitHubUserData(
      login: json['login'],
      name: json['name'] ?? '',
      bio: json['bio'],
      avatarUrl: json['avatar_url'],
      publicRepos: json['public_repos'],
      followers: json['followers'],
      following: json['following'],
    );
  }
}

class GitHubRepository {
  final String name;
  final String? description;
  final String? language;
  final int stars;
  final int forks;

  GitHubRepository({
    required this.name,
    this.description,
    this.language,
    required this.stars,
    required this.forks,
  });

  factory GitHubRepository.fromJson(Map<String, dynamic> json) {
    return GitHubRepository(
      name: json['name'],
      description: json['description'],
      language: json['language'],
      stars: json['stargazers_count'] ?? 0,
      forks: json['forks_count'] ?? 0,
    );
  }
}

class GitHubStats {
  final int totalRepositories;
  final int totalStars;
  final int totalForks;
  final List<String> languages;
  final List<GitHubRepository> topRepositories;

  GitHubStats({
    required this.totalRepositories,
    required this.totalStars,
    required this.totalForks,
    required this.languages,
    required this.topRepositories,
  });
}
