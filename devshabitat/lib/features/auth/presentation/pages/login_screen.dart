import 'package:flutter/material.dart';
import 'package:devshabitat/core/themes/colors.dart';
import 'package:devshabitat/core/themes/app_theme.dart';
import 'package:devshabitat/features/auth/presentation/widgets/glass_login_card.dart';
import 'package:devshabitat/features/auth/presentation/widgets/loading_overlay.dart';

class ResponsiveLoginScreen extends StatelessWidget {
  final bool isLoading;

  const ResponsiveLoginScreen({
    Key? key,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: DevHabitatColors.neonGradient,
        ),
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isTablet = constraints.maxWidth >= 768;

                return Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
                      child: isTablet
                          ? Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: GlassLoginCard(),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  flex: 4,
                                  child: _buildBrandingSection(),
                                ),
                              ],
                            )
                          : GlassLoginCard(),
                    ),
                  ),
                );
              },
            ),
            if (isLoading) const LoadingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandingSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DevHabitat',
          style: DevHabitatTheme.headingLarge.copyWith(
            color: DevHabitatColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Geliştiriciler için profesyonel ağ platformu',
          style: DevHabitatTheme.bodyLarge.copyWith(
            color: DevHabitatColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        // Buraya bir illustration eklenebilir
      ],
    );
  }
}
