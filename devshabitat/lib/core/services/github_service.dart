import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/github_models.dart';

class GitHubService {
  static const String baseUrl = 'https://api.github.com';

  Future<GitHubUserData> fetchUserData(String username) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$username'),
      headers: {'Accept': 'application/vnd.github.v3+json'},
    );

    if (response.statusCode == 200) {
      return GitHubUserData.fromJson(json.decode(response.body));
    }
    throw Exception('GitHub user not found');
  }

  Future<List<GitHubRepository>> fetchUserRepositories(String username,
      {int limit = 10}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$username/repos?sort=stars&per_page=$limit'),
      headers: {'Accept': 'application/vnd.github.v3+json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> repos = json.decode(response.body);
      return repos.map((repo) => GitHubRepository.fromJson(repo)).toList();
    }
    return [];
  }

  Future<Map<String, int>> fetchLanguageStats(String username) async {
    final repos = await fetchUserRepositories(username, limit: 100);
    final Map<String, int> languageStats = {};

    for (final repo in repos) {
      if (repo.language != null) {
        languageStats[repo.language!] =
            (languageStats[repo.language!] ?? 0) + 1;
      }
    }

    return languageStats;
  }

  Future<List<String>> extractSkillsFromRepos(
      List<GitHubRepository> repos) async {
    final Set<String> skills = {};

    for (final repo in repos) {
      // Language-based skills
      if (repo.language != null) {
        skills.add(repo.language!);
      }

      // Framework detection from repo name and description
      final content = '${repo.name} ${repo.description}'.toLowerCase();

      if (content.contains('flutter')) skills.add('Flutter');
      if (content.contains('react')) skills.add('React');
      if (content.contains('vue')) skills.add('Vue.js');
      if (content.contains('angular')) skills.add('Angular');
      if (content.contains('node')) skills.add('Node.js');
      if (content.contains('docker')) skills.add('Docker');
      if (content.contains('kubernetes')) skills.add('Kubernetes');
      if (content.contains('aws')) skills.add('AWS');
      if (content.contains('firebase')) skills.add('Firebase');
    }

    return skills.toList();
  }

  Future<GitHubStats> calculateStats(String username) async {
    final repos = await fetchUserRepositories(username, limit: 100);

    int totalStars = 0;
    int totalForks = 0;
    final Set<String> languages = {};

    for (final repo in repos) {
      totalStars += repo.stars;
      totalForks += repo.forks;
      if (repo.language != null) {
        languages.add(repo.language!);
      }
    }

    return GitHubStats(
      totalRepositories: repos.length,
      totalStars: totalStars,
      totalForks: totalForks,
      languages: languages.toList(),
      topRepositories: repos.take(5).toList(),
    );
  }
}
