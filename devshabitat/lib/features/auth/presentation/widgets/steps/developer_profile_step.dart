import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devshabitat/core/themes/colors.dart';
import 'package:devshabitat/core/themes/app_theme.dart';
import 'package:devshabitat/features/auth/presentation/blocs/register/register_bloc.dart';
import 'package:devshabitat/features/auth/presentation/cubits/form_validation_cubit.dart';
import 'package:devshabitat/features/auth/presentation/widgets/skill_selection_grid.dart';

class DeveloperProfileStep extends StatelessWidget {
  const DeveloperProfileStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormValidationCubit, FormValidationState>(
      builder: (context, validationState) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Geliştirici Profili',
                style: DevHabitatTheme.headlineMedium.copyWith(
                  color: DevHabitatColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Kendinizi tanıtın ve becerilerinizi paylaşın.',
                style: DevHabitatTheme.bodyMedium.copyWith(
                  color: DevHabitatColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              _buildBioField(context, validationState),
              const SizedBox(height: 32),
              _buildExperienceLevelField(context, validationState),
              const SizedBox(height: 32),
              _buildSkillsField(context, validationState),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBioField(
    BuildContext context,
    FormValidationState validationState,
  ) {
    final errors = validationState is FormValidationFailure
        ? validationState.errors
        : <String, String>{};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Biyografi',
          style: DevHabitatTheme.labelLarge.copyWith(
            color: DevHabitatColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          onChanged: (value) {
            context.read<FormValidationCubit>().validateField('bio', value);
            context.read<RegisterBloc>().add(
                  FormDataUpdated({'bio': value}),
                );
          },
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Kendinizi kısaca tanıtın...',
            hintStyle: DevHabitatTheme.bodyMedium.copyWith(
              color: DevHabitatColors.textTertiary,
            ),
            errorText: errors['bio'],
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
                color: DevHabitatColors.primary,
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

  Widget _buildExperienceLevelField(
    BuildContext context,
    FormValidationState validationState,
  ) {
    final errors = validationState is FormValidationFailure
        ? validationState.errors
        : <String, String>{};

    final experienceLevels = [
      'Yeni Başlayan',
      'Orta Seviye',
      'İleri Seviye',
      'Uzman',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deneyim Seviyesi',
          style: DevHabitatTheme.labelLarge.copyWith(
            color: DevHabitatColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: experienceLevels.map((level) {
            return ChoiceChip(
              label: Text(level),
              selected: false,
              onSelected: (selected) {
                if (selected) {
                  context
                      .read<FormValidationCubit>()
                      .validateExperienceLevel(level);
                  context.read<RegisterBloc>().add(
                        FormDataUpdated({'experience_level': level}),
                      );
                }
              },
              backgroundColor: DevHabitatColors.glassBackground,
              selectedColor: DevHabitatColors.primary,
              labelStyle: DevHabitatTheme.labelMedium.copyWith(
                color: DevHabitatColors.textPrimary,
              ),
            );
          }).toList(),
        ),
        if (errors['experience_level'] != null) ...[
          const SizedBox(height: 8),
          Text(
            errors['experience_level']!,
            style: DevHabitatTheme.labelSmall.copyWith(
              color: DevHabitatColors.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSkillsField(
    BuildContext context,
    FormValidationState validationState,
  ) {
    final errors = validationState is FormValidationFailure
        ? validationState.errors
        : <String, String>{};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Beceriler',
          style: DevHabitatTheme.labelLarge.copyWith(
            color: DevHabitatColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const SkillSelectionGrid(),
        if (errors['skills'] != null) ...[
          const SizedBox(height: 8),
          Text(
            errors['skills']!,
            style: DevHabitatTheme.labelSmall.copyWith(
              color: DevHabitatColors.error,
            ),
          ),
        ],
      ],
    );
  }
}
