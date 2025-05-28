import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:tech_challenge_3/data/models/upload_attachment_params.dart';
import 'package:tech_challenge_3/core/configs/theme/app_theme.dart';
import 'package:tech_challenge_3/domain/entities/transaction.dart';
import 'package:tech_challenge_3/domain/enums/transaction_type_enum.dart';
import 'package:tech_challenge_3/domain/usecases/transactions/upload_transaction_attachment.dart'; // UseCase
import 'package:tech_challenge_3/presentation/transactions/pages/transaction_detail_page.dart';
import 'package:tech_challenge_3/service_locator.dart';

import 'package:tech_challenge_3/presentation/transactions/bloc/transactions_display_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionListItem extends StatefulWidget {
  final TransactionEntity transaction;

  const TransactionListItem({super.key, required this.transaction});

  @override
  State<TransactionListItem> createState() => _TransactionListItemState();
}

class _TransactionListItemState extends State<TransactionListItem> {
  bool _isUploading = false;
  bool isPositive(TransactionType type) {
    return type == TransactionType.deposit ||
        type == TransactionType.investment;
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageXFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (imageXFile != null) {
      File imageFile = File(imageXFile.path);
      setState(() {
        _isUploading = true;
      });

      final usecase = sl<UploadTransactionAttachmentUseCase>();
      final result = await usecase.call(
        param: UploadTransactionAttachmentParams(
          transactionId: widget.transaction.id!,
          imageFile: imageFile,
        ),
      );

      setState(() {
        _isUploading = false;
      });

      result.fold(
        (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Falha no upload: $error',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        },
        (downloadUrl) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Anexo enviado com sucesso!',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
          context.read<TransactionsDisplayCubit>().fetchTransactions();
        },
      );
    }
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.pushNamed(
      context,
      TransactionDetailPage.routeName,
      arguments: widget.transaction,
    );
  }

  @override
  Widget build(BuildContext context) {
    final transaction = widget.transaction;
    final bool positive = isPositive(transaction.type);
    final Color amountColor =
        positive ? Colors.green.shade700 : Colors.red.shade700;

    final String formattedAmount = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    ).format(transaction.amount);

    final String formattedDate = DateFormat(
      'dd/MM/yyyy',
    ).format(transaction.date);

    IconData typeIconData;
    if (positive) {
      typeIconData = Icons.arrow_upward_rounded;
    } else {
      typeIconData = Icons.arrow_downward_rounded;
    }

    bool hasAttachment =
        transaction.attachmentUrl != null &&
        transaction.attachmentUrl!.isNotEmpty;

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        onTap: () => _navigateToDetail(context),
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: amountColor.withOpacity(0.15),
                child: Icon(typeIconData, color: amountColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.description.isNotEmpty
                          ? transaction.description
                          : transactionTypeToString(transaction.type),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    formattedAmount,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: amountColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _isUploading
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : IconButton(
                        icon: Icon(
                          hasAttachment
                              ? Icons.check_circle_outline_rounded
                              : Icons.add_a_photo_outlined,
                          color:
                              hasAttachment
                                  ? Colors.green.shade600
                                  : AppTheme.appTheme.primaryColor.withOpacity(
                                    0.7,
                                  ),
                          size: 22,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip:
                            hasAttachment ? 'Anexo existente' : 'Anexar imagem',
                        onPressed:
                            hasAttachment
                                ? () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'URL do anexo: ${transaction.attachmentUrl}',
                                      ),
                                    ),
                                  );
                                }
                                : () => _pickAndUploadImage(context),
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
