import 'package:flutter/material.dart';
import 'package:devshabitat/core/theme/dev_habitat_colors.dart';
import '../../domain/models/profile_privacy_settings.dart';

class PrivacySettingsWidget extends StatelessWidget {
  final ProfilePrivacySettings settings;
  final Function(ProfilePrivacySettings) onSettingsChanged;

  const PrivacySettingsWidget({
    Key? key,
    required this.settings,
    required this.onSettingsChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.privacy_tip,
              color: DevHabitatColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Privacy Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildPrivacySwitch(
          context,
          'Profile Visibility',
          'Make your profile public',
          settings.isProfilePublic,
          (value) {
            onSettingsChanged(
              settings.copyWith(isProfilePublic: value),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildPrivacySwitch(
          context,
          'Email Visibility',
          'Make your email public',
          settings.showEmail,
          (value) {
            onSettingsChanged(
              settings.copyWith(showEmail: value),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildPrivacySwitch(
          context,
          'Social Media Visibility',
          'Make your social media accounts public',
          settings.showSocialLinks,
          (value) {
            onSettingsChanged(
              settings.copyWith(showSocialLinks: value),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildPrivacySwitch(
          context,
          'GitHub Visibility',
          'Make your GitHub information public',
          settings.showGitHubStats,
          (value) {
            onSettingsChanged(
              settings.copyWith(showGitHubStats: value),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildPrivacySwitch(
          context,
          'Projects Visibility',
          'Make your projects public',
          settings.showProjects,
          (value) {
            onSettingsChanged(
              settings.copyWith(showProjects: value),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildPrivacySwitch(
          context,
          'Certifications Visibility',
          'Make your certifications public',
          settings.showCertifications,
          (value) {
            onSettingsChanged(
              settings.copyWith(showCertifications: value),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPrivacySwitch(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: DevHabitatColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: DevHabitatColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: DevHabitatColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
