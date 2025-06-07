import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devshabitat/features/auth/presentation/blocs/login/login_bloc.dart';

class GitHubSignInButton extends StatelessWidget {
  const GitHubSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state is LoginLoading
              ? null
              : () {
                  context.read<LoginBloc>().add(LoginWithGithubRequested());
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF24292E),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ).copyWith(
            elevation: MaterialStateProperty.all(0),
            overlayColor: MaterialStateProperty.all(
              const Color(0xFF1B1F23).withOpacity(0.1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state is LoginLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else
                Image.asset(
                  'assets/icons/github.png',
                  width: 24,
                  height: 24,
                ),
              const SizedBox(width: 12),
              const Text(
                'GitHub ile Giriş Yap',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
