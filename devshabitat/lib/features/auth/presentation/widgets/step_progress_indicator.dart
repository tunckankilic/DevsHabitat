import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devshabitat/core/themes/colors.dart';
import 'package:devshabitat/core/themes/app_theme.dart';
import 'package:devshabitat/features/auth/presentation/blocs/register/register_bloc.dart';

class StepProgressIndicator extends StatelessWidget {
  final bool isTablet;

  const StepProgressIndicator({
    super.key,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        final currentStep = state is StepInitial || state is StepSuccess
            ? (state as dynamic).currentStep
            : 0;

        return isTablet
            ? _buildTabletLayout(context, currentStep)
            : _buildMobileLayout(context, currentStep);
      },
    );
  }

  Widget _buildTabletLayout(BuildContext context, int currentStep) {
    return Container(
      decoration: BoxDecoration(
        color: DevHabitatColors.glassBackground.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            'Kayıt Ol',
            style: DevHabitatTheme.headlineMedium.copyWith(
              color: DevHabitatColors.textPrimary,
            ),
          ),
          const SizedBox(height: 48),
          ...List.generate(4, (index) {
            final isActive = index == currentStep;
            final isCompleted = index < currentStep;

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              child: _buildStepItem(
                context,
                index,
                isActive,
                isCompleted,
                isTablet: true,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, int currentStep) {
    return Column(
      children: [
        Text(
          'Kayıt Ol',
          style: DevHabitatTheme.headlineMedium.copyWith(
            color: DevHabitatColors.textPrimary,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            final isActive = index == currentStep;
            final isCompleted = index < currentStep;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _buildStepItem(
                context,
                index,
                isActive,
                isCompleted,
                isTablet: false,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStepItem(
    BuildContext context,
    int index,
    bool isActive,
    bool isCompleted, {
    required bool isTablet,
  }) {
    final stepTitles = [
      'Temel Bilgiler',
      'Geliştirici Profili',
      'GitHub Entegrasyonu',
      'Tercihler',
    ];

    final stepIcons = [
      Icons.person_outline,
      Icons.code_outlined,
      Icons.integration_instructions_outlined,
      Icons.settings_outlined,
    ];

    return isTablet
        ? _buildTabletStepItem(
            context,
            index,
            isActive,
            isCompleted,
            stepTitles[index],
            stepIcons[index],
          )
        : _buildMobileStepItem(
            context,
            index,
            isActive,
            isCompleted,
            stepTitles[index],
            stepIcons[index],
          );
  }

  Widget _buildTabletStepItem(
    BuildContext context,
    int index,
    bool isActive,
    bool isCompleted,
    String title,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive
            ? DevHabitatColors.glassBackground
            : DevHabitatColors.glassBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? DevHabitatColors.primary
              : DevHabitatColors.glassBorder,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive
                  ? DevHabitatColors.primary
                  : isCompleted
                      ? DevHabitatColors.success
                      : DevHabitatColors.glassBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isActive || isCompleted
                  ? DevHabitatColors.textPrimary
                  : DevHabitatColors.textSecondary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Adım ${index + 1}',
                  style: DevHabitatTheme.labelSmall.copyWith(
                    color: DevHabitatColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: DevHabitatTheme.titleMedium.copyWith(
                    color: isActive
                        ? DevHabitatColors.textPrimary
                        : DevHabitatColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileStepItem(
    BuildContext context,
    int index,
    bool isActive,
    bool isCompleted,
    String title,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive
                ? DevHabitatColors.primary
                : isCompleted
                    ? DevHabitatColors.success
                    : DevHabitatColors.glassBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isActive || isCompleted
                ? DevHabitatColors.textPrimary
                : DevHabitatColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: DevHabitatTheme.labelSmall.copyWith(
            color: isActive
                ? DevHabitatColors.textPrimary
                : DevHabitatColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
