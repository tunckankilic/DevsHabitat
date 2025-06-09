import 'dart:ui';

import 'package:devshabitat/core/themes/app_theme.dart';
import 'package:devshabitat/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:devshabitat/features/auth/presentation/widgets/email_password_form.dart';
import 'package:devshabitat/features/auth/presentation/widgets/social_login_section.dart';

class GlassLoginCard extends StatelessWidget {
  const GlassLoginCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 768;

        return Container(
          width: isTablet ? 400 : double.infinity,
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          decoration: DevHabitatTheme.glassDecoration(
            background: DevHabitatColors.glassBackground,
            border: DevHabitatColors.glassBorder,
            borderRadius: 24,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Welcome',
                      style: DevHabitatTheme.headingMedium.copyWith(
                        color: DevHabitatColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to DevHabitat',
                      style: DevHabitatTheme.bodyMedium.copyWith(
                        color: DevHabitatColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    const EmailPasswordForm(),
                    const SizedBox(height: 24),
                    const SocialLoginSection(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
