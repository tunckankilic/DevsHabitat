import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devshabitat/core/themes/colors.dart';
import 'package:devshabitat/features/auth/presentation/blocs/register/register_bloc.dart';
import 'package:devshabitat/features/auth/presentation/cubits/github_validation_cubit.dart';
import 'package:devshabitat/features/auth/presentation/cubits/form_validation_cubit.dart';
import 'package:devshabitat/features/auth/presentation/widgets/step_progress_indicator.dart';
import 'package:devshabitat/features/auth/presentation/widgets/navigation_buttons.dart';
import 'package:devshabitat/features/auth/presentation/widgets/steps/basic_info_step.dart';
import 'package:devshabitat/features/auth/presentation/widgets/steps/developer_profile_step.dart';
import 'package:devshabitat/features/auth/presentation/widgets/steps/github_integration_step.dart';

class RegistrationWizardPage extends StatelessWidget {
  const RegistrationWizardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GitHubValidationCubit()),
        BlocProvider(create: (context) => FormValidationCubit()),
      ],
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: DevHabitatColors.error,
              ),
            );
          }
        },
        child: const ResponsiveRegistrationWizard(),
      ),
    );
  }
}

class ResponsiveRegistrationWizard extends StatelessWidget {
  const ResponsiveRegistrationWizard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: DevHabitatColors.backgroundGradient,
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 768) {
                return const TabletLayout();
              } else {
                return const MobileLayout();
              }
            },
          ),
        ),
      ),
    );
  }
}

class TabletLayout extends StatelessWidget {
  const TabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Sol Sidebar (30%)
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: const StepProgressIndicator(isTablet: true),
        ),
        // Sağ İçerik (70%)
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: DevHabitatColors.glassBackground.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                bottomLeft: Radius.circular(32),
              ),
            ),
            child: const StepContent(),
          ),
        ),
      ],
    );
  }
}

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Üst Progress Indicator
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: StepProgressIndicator(isTablet: false),
        ),
        // Ana İçerik
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: DevHabitatColors.glassBackground.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: const StepContent(),
          ),
        ),
      ],
    );
  }
}

class StepContent extends StatelessWidget {
  const StepContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        if (state is RegisterLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final currentStep = state is StepInitial || state is StepSuccess
            ? (state as dynamic).currentStep
            : 0;

        return Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: currentStep,
                children: const [
                  BasicInfoStep(),
                  DeveloperProfileStep(),
                  GitHubIntegrationStep(),
                ],
              ),
            ),
            const NavigationButtons(),
          ],
        );
      },
    );
  }
}
