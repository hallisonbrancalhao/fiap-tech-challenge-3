import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tech_challenge_3/core/configs/theme/app_theme.dart';
import 'package:tech_challenge_3/domain/entities/transaction.dart';
import 'package:tech_challenge_3/domain/enums/transaction_type_enum.dart';
import 'package:tech_challenge_3/presentation/transactions/pages/transaction_attachment_section.dart';
import 'package:tech_challenge_3/presentation/transactions/pages/transaction_detail_card.dart';

class TransactionDetailPage extends StatelessWidget {
  static const String routeName = '/transaction-detail';
  final TransactionEntity transaction;

  const TransactionDetailPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final formattedAmount = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    ).format(transaction.amount);
    final formattedDate = DateFormat('dd/MM/yyyy').format(transaction.date);

    final isPositive =
        transaction.type == TransactionType.deposit ||
        transaction.type == TransactionType.investment;
    final amountColor =
        isPositive ? Colors.green.shade700 : Colors.red.shade700;

    return Scaffold(
      backgroundColor: AppTheme.appTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Detalhes da Transação',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.appTheme.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TransactionDetailCard(
                label: 'Tipo',
                value: transactionTypeToString(transaction.type),
                icon: Icons.category,
              ),
              const SizedBox(height: 16),
              TransactionDetailCard(
                label: 'Descrição',
                value:
                    transaction.description.isNotEmpty
                        ? transaction.description
                        : transactionTypeToString(transaction.type),
                icon: Icons.description,
              ),
              const SizedBox(height: 16),
              TransactionDetailCard(
                label: 'Valor',
                value: formattedAmount,
                icon: Icons.monetization_on,
                textColor: amountColor,
              ),
              const SizedBox(height: 16),
              TransactionDetailCard(
                label: 'Data',
                value: formattedDate,
                icon: Icons.calendar_today,
              ),
              const SizedBox(height: 16),
              TransactionAttachmentSection(
                attachmentUrl: transaction.attachmentUrl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
