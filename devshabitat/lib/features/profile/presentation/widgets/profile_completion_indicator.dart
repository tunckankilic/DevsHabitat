import 'package:flutter/material.dart';
import 'package:devshabitat/core/theme/dev_habitat_colors.dart';

class ProfileCompletionIndicator extends StatelessWidget {
  final double completionScore;

  const ProfileCompletionIndicator({
    Key? key,
    required this.completionScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DevHabitatColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profil Tamamlama',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '${(completionScore * 100).toInt()}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: DevHabitatColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: completionScore,
            backgroundColor: DevHabitatColors.surface,
            valueColor: AlwaysStoppedAnimation<Color>(
              DevHabitatColors.primary,
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
