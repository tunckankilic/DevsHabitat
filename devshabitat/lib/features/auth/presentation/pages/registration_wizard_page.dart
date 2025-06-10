import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegistrationWizardPage extends StatelessWidget {
  const RegistrationWizardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Ad Soyad',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
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
                // TODO: Implement registration
                context.go('/home');
              },
              child: const Text('Kayıt Ol'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context.go('/login');
              },
              child: const Text('Zaten hesabın var mı? Giriş yap'),
            ),
          ],
        ),
      ),
    );
  }
}
