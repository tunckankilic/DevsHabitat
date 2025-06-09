import 'package:flutter/material.dart';
import '../../../../core/theme/devhabitat_colors.dart';

class SocialLinksWidget extends StatelessWidget {
  final Map<String, String> socialLinks;
  final bool readOnly;
  final Function(String, String)? onLinkChanged;

  const SocialLinksWidget({
    Key? key,
    required this.socialLinks,
    this.readOnly = false,
    this.onLinkChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.link,
              color: DevHabitatColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Sosyal Medya',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSocialLinkField(
          context,
          'GitHub',
          'github.com/',
          Icons.code,
        ),
        const SizedBox(height: 8),
        _buildSocialLinkField(
          context,
          'LinkedIn',
          'linkedin.com/in/',
          Icons.work,
        ),
        const SizedBox(height: 8),
        _buildSocialLinkField(
          context,
          'Twitter',
          'twitter.com/',
          Icons.chat,
        ),
        const SizedBox(height: 8),
        _buildSocialLinkField(
          context,
          'Instagram',
          'instagram.com/',
          Icons.camera_alt,
        ),
        const SizedBox(height: 8),
        _buildSocialLinkField(
          context,
          'Medium',
          'medium.com/@',
          Icons.article,
        ),
        const SizedBox(height: 8),
        _buildSocialLinkField(
          context,
          'Dev.to',
          'dev.to/',
          Icons.computer,
        ),
      ],
    );
  }

  Widget _buildSocialLinkField(
    BuildContext context,
    String platform,
    String prefix,
    IconData icon,
  ) {
    final controller = TextEditingController(
      text: socialLinks[platform] ?? '',
    );

    return Container(
      decoration: BoxDecoration(
        color: DevHabitatColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: DevHabitatColors.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    platform,
                    style: const TextStyle(
                      color: DevHabitatColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        prefix,
                        style: const TextStyle(
                          color: DevHabitatColors.textSecondary,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          enabled: !readOnly,
                          style: const TextStyle(
                            color: DevHabitatColors.text,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                          onChanged: (value) {
                            if (onLinkChanged != null) {
                              onLinkChanged!(platform, value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
