import 'package:devshabitat/core/theme/dev_habitat_colors.dart';
import 'package:devshabitat/core/theme/devhabitat_theme.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

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
            decoration: DevHabitatTheme.glassDecoration,
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
