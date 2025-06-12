import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:devshabitat/core/theme/dev_habitat_colors.dart';
import 'package:devshabitat/core/theme/devhabitat_theme.dart';
import 'package:devshabitat/features/auth/presentation/widgets/email_password_form.dart';
import 'package:devshabitat/features/auth/presentation/widgets/social_login_section.dart';

class GlassLoginCard extends StatelessWidget {
  const GlassLoginCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 768;
        final isDesktop = constraints.maxWidth >= 1200;

        return Container(
          width: isTablet ? 400.w : double.infinity,
          constraints: BoxConstraints(
            maxWidth: 400.w,
          ),
          decoration: DevHabitatTheme.glassDecoration,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 32.r : 24.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Welcome',
                      style: DevHabitatTheme.headlineMedium.copyWith(
                        color: DevHabitatColors.textPrimary,
                        fontSize: isDesktop
                            ? 32.sp
                            : isTablet
                                ? 28.sp
                                : 24.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Sign in to DevHabitat',
                      style: DevHabitatTheme.bodyMedium.copyWith(
                        color: DevHabitatColors.textSecondary,
                        fontSize: isDesktop
                            ? 16.sp
                            : isTablet
                                ? 14.sp
                                : 12.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32.h),
                    const EmailPasswordForm(),
                    SizedBox(height: 24.h),
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
