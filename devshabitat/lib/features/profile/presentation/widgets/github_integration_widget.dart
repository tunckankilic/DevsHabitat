import 'package:flutter/material.dart';
import 'package:devshabitat/core/themes/colors.dart';
import '../../domain/models/github_repository.dart';

class GitHubIntegrationWidget extends StatelessWidget {
  final String username;
  final Map<String, dynamic>? statistics;
  final List<GitHubRepository> featuredRepositories;

  const GitHubIntegrationWidget({
    Key? key,
    required this.username,
    this.statistics,
    required this.featuredRepositories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.code,
              color: DevHabitatColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'GitHub',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                // TODO: Implement GitHub profile link
              },
              icon: const Icon(
                Icons.link,
                size: 16,
              ),
              label: const Text('GitHub Profili'),
              style: TextButton.styleFrom(
                foregroundColor: DevHabitatColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (statistics != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: DevHabitatColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildStatItem(
                      context,
                      'Public Repos',
                      statistics!['publicRepos']?.toString() ?? '0',
                      Icons.folder,
                    ),
                    _buildStatItem(
                      context,
                      'Followers',
                      statistics!['followers']?.toString() ?? '0',
                      Icons.people,
                    ),
                    _buildStatItem(
                      context,
                      'Following',
                      statistics!['following']?.toString() ?? '0',
                      Icons.person_add,
                    ),
                    _buildStatItem(
                      context,
                      'Stars',
                      statistics!['stars']?.toString() ?? '0',
                      Icons.star,
                    ),
                  ],
                ),
              ],
            ),
          ),
        if (featuredRepositories.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'Öne Çıkan Repolar',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: featuredRepositories.length,
            itemBuilder: (context, index) {
              final repo = featuredRepositories[index];
              return _buildRepositoryCard(context, repo);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: DevHabitatColors.primary,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: DevHabitatColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: DevHabitatColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepositoryCard(BuildContext context, GitHubRepository repo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: DevHabitatColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.folder,
                  color: DevHabitatColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    repo.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // TODO: Implement repository link
                  },
                  icon: const Icon(
                    Icons.link,
                    size: 16,
                  ),
                  label: const Text('Görüntüle'),
                  style: TextButton.styleFrom(
                    foregroundColor: DevHabitatColors.primary,
                  ),
                ),
              ],
            ),
            if (repo.description != null) ...[
              const SizedBox(height: 8),
              Text(
                repo.description!,
                style: const TextStyle(
                  color: DevHabitatColors.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                if (repo.language != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: DevHabitatColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      repo.language!,
                      style: const TextStyle(
                        color: DevHabitatColors.primary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                const Icon(
                  Icons.star,
                  size: 16,
                  color: DevHabitatColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  repo.stars.toString(),
                  style: const TextStyle(
                    color: DevHabitatColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.call_split,
                  size: 16,
                  color: DevHabitatColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  repo.forks.toString(),
                  style: const TextStyle(
                    color: DevHabitatColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
