import 'package:flutter/material.dart';
import 'package:devshabitat/core/themes/colors.dart';
import 'package:devshabitat/core/themes/app_theme.dart';
import 'package:devshabitat/features/auth/presentation/widgets/glass_login_card.dart';
import 'package:devshabitat/features/auth/presentation/widgets/loading_overlay.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Yap'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'E-posta',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement login
                context.go('/home');
              },
              child: const Text('Giriş Yap'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context.go('/register');
              },
              child: const Text('Hesabın yok mu? Kayıt ol'),
            ),
          ],
        ),
      ),
    );
  }
}

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
