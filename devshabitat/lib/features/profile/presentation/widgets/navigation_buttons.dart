import 'package:flutter/material.dart';
import '../../../../core/theme/devhabitat_colors.dart';

class NavigationButtons extends StatelessWidget {
  final int currentStep;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const NavigationButtons({
    Key? key,
    required this.currentStep,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DevHabitatColors.surface,
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: onPrevious,
                style: OutlinedButton.styleFrom(
                  foregroundColor: DevHabitatColors.primary,
                  side: const BorderSide(
                    color: DevHabitatColors.primary,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),
                child: const Text('Geri'),
              ),
            ),
          if (currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: DevHabitatColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
              ),
              child: Text(
                currentStep < 6 ? 'İleri' : 'Kaydet',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
