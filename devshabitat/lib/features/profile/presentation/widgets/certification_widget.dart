import 'package:devshabitat/core/theme/dev_habitat_colors.dart';
import 'package:flutter/material.dart';

import '../../domain/models/certification.dart';

class CertificationWidget extends StatelessWidget {
  final List<Certification> certifications;
  final bool readOnly;

  const CertificationWidget({
    Key? key,
    required this.certifications,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.workspace_premium,
              color: DevHabitatColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Sertifikalar',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: certifications.length,
          itemBuilder: (context, index) {
            final certification = certifications[index];
            return _buildCertificationCard(context, certification);
          },
        ),
      ],
    );
  }

  Widget _buildCertificationCard(
      BuildContext context, Certification certification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: DevHabitatColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.workspace_premium,
                  color: DevHabitatColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    certification.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (certification.credentialUrl != null)
                  TextButton.icon(
                    onPressed: () {
                      // TODO: Implement credential URL
                    },
                    icon: const Icon(
                      Icons.link,
                      size: 16,
                    ),
                    label: const Text('Görüntüle'),
                    style: TextButton.styleFrom(
                      foregroundColor: DevHabitatColors.primary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              certification.issuer,
              style: const TextStyle(
                color: DevHabitatColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: DevHabitatColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Verilme: ${_formatDate(certification.issueDate)}',
                  style: const TextStyle(
                    color: DevHabitatColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                if (certification.expiryDate != null) ...[
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.timer,
                    size: 16,
                    color: DevHabitatColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Expiry: ${_formatDate(certification.expiryDate!)}',
                    style: const TextStyle(
                      color: DevHabitatColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
