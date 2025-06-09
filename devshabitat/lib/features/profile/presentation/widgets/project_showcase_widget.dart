import 'package:flutter/material.dart';
import 'package:devshabitat/core/themes/colors.dart';
import '../../domain/models/project_showcase.dart';

class ProjectShowcaseWidget extends StatelessWidget {
  final List<ProjectShowcase> projects;

  const ProjectShowcaseWidget({
    Key? key,
    required this.projects,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.work,
              color: DevHabitatColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Projeler',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return _buildProjectCard(context, project);
          },
        ),
      ],
    );
  }

  Widget _buildProjectCard(BuildContext context, ProjectShowcase project) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: DevHabitatColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (project.imageUrls.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: project.imageUrls.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      project.imageUrls[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: DevHabitatColors.surface,
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 48,
                              color: DevHabitatColors.textSecondary,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  project.description,
                  style: const TextStyle(
                    color: DevHabitatColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: project.technologies.map((tech) {
                    return Chip(
                      label: Text(tech),
                      backgroundColor:
                          DevHabitatColors.primary.withOpacity(0.2),
                      labelStyle: const TextStyle(
                        color: DevHabitatColors.primary,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (project.liveUrl != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implement live URL
                          },
                          icon: const Icon(Icons.launch),
                          label: const Text('Canlı Demo'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: DevHabitatColors.primary,
                            side: const BorderSide(
                              color: DevHabitatColors.primary,
                            ),
                          ),
                        ),
                      ),
                    if (project.liveUrl != null && project.repoUrl != null)
                      const SizedBox(width: 8),
                    if (project.repoUrl != null)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implement repo URL
                          },
                          icon: const Icon(Icons.code),
                          label: const Text('Kaynak Kod'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: DevHabitatColors.primary,
                            side: const BorderSide(
                              color: DevHabitatColors.primary,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
