import 'package:devshabitat/core/theme/dev_habitat_colors.dart';
import 'package:devshabitat/core/theme/devhabitat_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devshabitat/features/auth/presentation/blocs/register/register_bloc.dart';

class NavigationButtons extends StatelessWidget {
  const NavigationButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        final currentStep = state is StepInitial || state is StepSuccess
            ? (state as dynamic).currentStep
            : 0;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: DevHabitatColors.glassBackground.withOpacity(0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentStep > 0)
                TextButton(
                  onPressed: () {
                    context.read<RegisterBloc>().add(PreviousStepRequested());
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back),
                      const SizedBox(width: 8),
                      Text(
                        'Back',
                        style: DevHabitatTheme.labelLarge.copyWith(
                          color: DevHabitatColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                )
              else
                const SizedBox.shrink(),
              ElevatedButton(
                onPressed: () {
                  if (currentStep < 3) {
                    context.read<RegisterBloc>().add(NextStepRequested({}));
                  } else {
                    context
                        .read<RegisterBloc>()
                        .add(RegisterWithEmailAndPasswordRequested(
                          email: '',
                          password: '',
                          name: '',
                        ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: DevHabitatColors.primary,
                  foregroundColor: DevHabitatColors.textPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      currentStep < 3 ? 'Next' : 'Register',
                      style: DevHabitatTheme.labelLarge.copyWith(
                        color: DevHabitatColors.textPrimary,
                      ),
                    ),
                    if (currentStep < 3) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
