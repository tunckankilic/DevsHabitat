import 'package:flutter/material.dart';
import 'package:devshabitat/core/themes/colors.dart';
import 'package:devshabitat/core/themes/app_theme.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Gradient? gradient;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;
  final double elevation;

  const GradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.gradient,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.textStyle,
    this.elevation = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? DevHabitatColors.primaryGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: DevHabitatColors.primaryBlue.withOpacity(0.3),
            blurRadius: elevation,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding,
            child: Center(
              child: Text(
                text,
                style: textStyle ??
                    DevHabitatTheme.labelLarge.copyWith(
                      color: DevHabitatColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
