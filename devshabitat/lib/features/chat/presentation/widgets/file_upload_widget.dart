import 'package:devshabitat/core/theme/dev_habitat_colors.dart';
import 'package:flutter/material.dart';

class FileUploadWidget extends StatelessWidget {
  final double progress;
  final String fileName;
  final VoidCallback onCancel;

  const FileUploadWidget({
    Key? key,
    required this.progress,
    required this.fileName,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DevHabitatColors.darkSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(
                Icons.upload_file,
                color: DevHabitatColors.primaryBlue,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  fileName,
                  style: const TextStyle(
                    color: DevHabitatColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: DevHabitatColors.textSecondary,
                ),
                onPressed: onCancel,
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: DevHabitatColors.darkCard,
            valueColor: const AlwaysStoppedAnimation<Color>(
              DevHabitatColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 12,
              color: DevHabitatColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
