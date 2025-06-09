import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:devshabitat/core/themes/colors.dart';
import 'package:devshabitat/core/themes/app_theme.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        color: DevHabitatColors.shadowDark,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: DevHabitatTheme.glassDecoration(
              background: DevHabitatColors.glassBackground,
              border: DevHabitatColors.glassBorder,
              borderRadius: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      DevHabitatColors.primaryBlue),
                ),
                const SizedBox(height: 16),
                Text(
                  'Signing in...',
                  style: DevHabitatTheme.bodyMedium.copyWith(
                    color: DevHabitatColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
