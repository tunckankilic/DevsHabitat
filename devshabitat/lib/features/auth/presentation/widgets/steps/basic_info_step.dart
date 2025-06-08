import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:devshabitat/core/themes/colors.dart';
import 'package:devshabitat/core/themes/app_theme.dart';
import 'package:devshabitat/features/auth/presentation/blocs/register/register_bloc.dart';
import 'package:devshabitat/features/auth/presentation/cubits/form_validation_cubit.dart';

class BasicInfoStep extends StatelessWidget {
  const BasicInfoStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormValidationCubit, FormValidationState>(
      builder: (context, validationState) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Temel Bilgiler',
                style: DevHabitatTheme.headlineMedium.copyWith(
                  color: DevHabitatColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'DevHabitat\'a hoş geldiniz! Lütfen temel bilgilerinizi girin.',
                style: DevHabitatTheme.bodyMedium.copyWith(
                  color: DevHabitatColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              _buildNameField(context, validationState),
              const SizedBox(height: 24),
              _buildEmailField(context, validationState),
              const SizedBox(height: 24),
              _buildPasswordField(context, validationState),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNameField(
    BuildContext context,
    FormValidationState validationState,
  ) {
    final errors = validationState is FormValidationFailure
        ? validationState.errors
        : <String, String>{};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ad Soyad',
          style: DevHabitatTheme.labelLarge.copyWith(
            color: DevHabitatColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          onChanged: (value) {
            context.read<FormValidationCubit>().validateField('name', value);
            context.read<RegisterBloc>().add(
                  FormDataUpdated({'name': value}),
                );
          },
          decoration: InputDecoration(
            hintText: 'Adınızı ve soyadınızı girin',
            hintStyle: DevHabitatTheme.bodyMedium.copyWith(
              color: DevHabitatColors.textTertiary,
            ),
            errorText: errors['name'],
            prefixIcon: Icon(
              Icons.person_outline,
              color: DevHabitatColors.textSecondary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.glassBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.glassBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.primary,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.error,
              ),
            ),
            filled: true,
            fillColor: DevHabitatColors.glassBackground,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField(
    BuildContext context,
    FormValidationState validationState,
  ) {
    final errors = validationState is FormValidationFailure
        ? validationState.errors
        : <String, String>{};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'E-posta',
          style: DevHabitatTheme.labelLarge.copyWith(
            color: DevHabitatColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          onChanged: (value) {
            context.read<FormValidationCubit>().validateField('email', value);
            context.read<RegisterBloc>().add(
                  FormDataUpdated({'email': value}),
                );
          },
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'E-posta adresinizi girin',
            hintStyle: DevHabitatTheme.bodyMedium.copyWith(
              color: DevHabitatColors.textTertiary,
            ),
            errorText: errors['email'],
            prefixIcon: Icon(
              Icons.email_outlined,
              color: DevHabitatColors.textSecondary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.glassBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.glassBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.primary,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.error,
              ),
            ),
            filled: true,
            fillColor: DevHabitatColors.glassBackground,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    BuildContext context,
    FormValidationState validationState,
  ) {
    final errors = validationState is FormValidationFailure
        ? validationState.errors
        : <String, String>{};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Şifre',
          style: DevHabitatTheme.labelLarge.copyWith(
            color: DevHabitatColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          onChanged: (value) {
            context
                .read<FormValidationCubit>()
                .validateField('password', value);
            context.read<RegisterBloc>().add(
                  FormDataUpdated({'password': value}),
                );
          },
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Şifrenizi girin',
            hintStyle: DevHabitatTheme.bodyMedium.copyWith(
              color: DevHabitatColors.textTertiary,
            ),
            errorText: errors['password'],
            prefixIcon: Icon(
              Icons.lock_outline,
              color: DevHabitatColors.textSecondary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.glassBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.glassBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.primary,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: DevHabitatColors.error,
              ),
            ),
            filled: true,
            fillColor: DevHabitatColors.glassBackground,
          ),
        ),
        if (errors['password'] == null) ...[
          const SizedBox(height: 16),
          _buildPasswordStrengthIndicator(context),
        ],
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Şifre Güvenliği',
          style: DevHabitatTheme.labelSmall.copyWith(
            color: DevHabitatColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.5,
                  backgroundColor: DevHabitatColors.glassBackground,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    DevHabitatColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Orta',
              style: DevHabitatTheme.labelSmall.copyWith(
                color: DevHabitatColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '• En az 8 karakter\n• En az bir büyük harf\n• En az bir küçük harf\n• En az bir rakam',
          style: DevHabitatTheme.labelSmall.copyWith(
            color: DevHabitatColors.textTertiary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
