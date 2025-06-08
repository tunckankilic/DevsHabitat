import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devshabitat/core/themes/colors.dart';
import 'package:devshabitat/core/themes/app_theme.dart';
import 'package:devshabitat/features/auth/presentation/blocs/register/register_bloc.dart';
import 'package:devshabitat/features/auth/presentation/cubits/github_validation_cubit.dart';

class GitHubIntegrationStep extends StatelessWidget {
  const GitHubIntegrationStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GitHubValidationCubit, GitHubValidationState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GitHub Entegrasyonu',
                style: DevHabitatTheme.titleLarge.copyWith(
                  color: DevHabitatColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'GitHub hesabınızı bağlayın ve projelerinizi paylaşın.',
                style: DevHabitatTheme.bodyMedium.copyWith(
                  color: DevHabitatColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              _buildGitHubUsernameField(context, state),
              const SizedBox(height: 32),
              if (state is GitHubValidationSuccess) ...[
                _buildGitHubProfileCard(context, state),
                const SizedBox(height: 32),
                _buildRepositoryShowcase(context, state),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildGitHubUsernameField(
    BuildContext context,
    GitHubValidationState state,
  ) {
    final isLoading = state is GitHubValidationLoading;
    final error = state is GitHubValidationFailure ? state.message : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GitHub Kullanıcı Adı',
          style: DevHabitatTheme.labelLarge.copyWith(
            color: DevHabitatColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          onChanged: (value) {
            if (value.isNotEmpty) {
              context.read<GitHubValidationCubit>().validateUsername(value);
              context.read<RegisterBloc>().add(
                    FormDataUpdated({'github_username': value}),
                  );
            }
          },
          decoration: InputDecoration(
            hintText: 'GitHub kullanıcı adınızı girin',
            hintStyle: DevHabitatTheme.bodyMedium.copyWith(
              color: DevHabitatColors.textTertiary,
            ),
            errorText: error,
            prefixIcon: Icon(
              Icons.code,
              color: DevHabitatColors.textSecondary,
            ),
            suffixIcon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.glassBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.glassBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.primaryBlue,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.error,
              ),
            ),
            filled: true,
            fillColor: DevHabitatColors.glassBackground,
          ),
        ),
      ],
    );
  }

  Widget _buildGitHubProfileCard(
    BuildContext context,
    GitHubValidationSuccess state,
  ) {
    final userData = state.userData;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DevHabitatColors.glassBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: DevHabitatColors.glassBorder,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(userData['avatar_url'] as String),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData['name'] as String? ?? state.username,
                  style: DevHabitatTheme.titleLarge.copyWith(
                    color: DevHabitatColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '@${state.username}',
                  style: DevHabitatTheme.bodyMedium.copyWith(
                    color: DevHabitatColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatItem(
                      context,
                      Icons.people_outline,
                      '${userData['followers']} Takipçi',
                    ),
                    const SizedBox(width: 24),
                    _buildStatItem(
                      context,
                      Icons.star_outline,
                      '${userData['public_repos']} Repo',
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

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    String label,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: DevHabitatColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: DevHabitatTheme.bodyMedium.copyWith(
            color: DevHabitatColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildRepositoryShowcase(
    BuildContext context,
    GitHubValidationSuccess state,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popüler Repolar',
          style: DevHabitatTheme.titleMedium.copyWith(
            color: DevHabitatColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: DevHabitatColors.glassBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: DevHabitatColors.glassBorder,
            ),
          ),
          child: Column(
            children: [
              _buildRepositoryItem(
                context,
                'Flutter UI Kit',
                'Modern ve özelleştirilebilir UI bileşenleri',
                'flutter-ui-kit',
                '1.2k',
              ),
              const Divider(height: 32),
              _buildRepositoryItem(
                context,
                'DevHabitat Mobile',
                'Flutter ile geliştirilmiş mobil uygulama',
                'devhabitat-mobile',
                '856',
              ),
              const Divider(height: 32),
              _buildRepositoryItem(
                context,
                'Clean Architecture',
                'Flutter için temiz mimari örneği',
                'clean-architecture',
                '2.3k',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRepositoryItem(
    BuildContext context,
    String name,
    String description,
    String repoName,
    String stars,
  ) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: DevHabitatColors.glassBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: DevHabitatColors.glassBorder,
            ),
          ),
          child: const Icon(
            Icons.folder_outlined,
            color: Colors.amber,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: DevHabitatTheme.titleSmall.copyWith(
                  color: DevHabitatColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: DevHabitatTheme.bodySmall.copyWith(
                  color: DevHabitatColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            const Icon(
              Icons.star_outline,
              size: 20,
              color: Colors.amber,
            ),
            const SizedBox(width: 4),
            Text(
              stars,
              style: DevHabitatTheme.labelMedium.copyWith(
                color: DevHabitatColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
