import 'package:devshabitat/core/theme/dev_habitat_colors.dart';
import 'package:devshabitat/core/theme/devhabitat_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devshabitat/features/auth/presentation/blocs/login/login_bloc.dart';
import 'package:devshabitat/features/auth/presentation/widgets/github_sign_in_button.dart';

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'veya',
          style: DevHabitatTheme.bodyMedium.copyWith(
            color: DevHabitatColors.textTertiary,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _SocialLoginButton(
              icon: Icons.g_mobiledata,
              onPressed: () {
                context.read<LoginBloc>().add(LoginWithGoogleRequested());
              },
            ),
            const GitHubSignInButton(),
            _SocialLoginButton(
              icon: Icons.apple,
              onPressed: () {
                context.read<LoginBloc>().add(LoginWithAppleRequested());
              },
            ),
            _SocialLoginButton(
              icon: Icons.facebook,
              onPressed: () {
                context.read<LoginBloc>().add(LoginWithFacebookRequested());
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _SocialLoginButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: DevHabitatColors.glassBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: DevHabitatColors.glassBorder,
            ),
          ),
          child: Icon(
            icon,
            color: DevHabitatColors.textPrimary,
            size: 24,
          ),
        ),
      ),
    );
  }
}
