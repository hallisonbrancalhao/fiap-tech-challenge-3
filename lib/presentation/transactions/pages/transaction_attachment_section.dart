import 'package:flutter/material.dart';
import 'package:tech_challenge_3/core/configs/theme/app_theme.dart';

class TransactionAttachmentSection extends StatelessWidget {
  final String? attachmentUrl;

  const TransactionAttachmentSection({super.key, this.attachmentUrl});

  @override
  Widget build(BuildContext context) {
    final hasAttachment = attachmentUrl != null && attachmentUrl!.isNotEmpty;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Anexo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            hasAttachment
                ? Row(
                  children: [
                    Icon(
                      Icons.attach_file,
                      color: AppTheme.appTheme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Image.network(
                        attachmentUrl!,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => const Text(
                              'Erro ao carregar imagem',
                              style: TextStyle(color: Colors.red),
                            ),
                      ),
                    ),
                  ],
                )
                : Text(
                  'Nenhum anexo disponível',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
          ],
        ),
      ),
    );
  }
}
