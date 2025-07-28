// lib/data/models/transaction_update_dto.dart

import 'package:tech_challenge_3/domain/enums/transaction_type_enum.dart';

class TransactionUpdateDto {
  final TransactionType? type;
  final String? description;
  final double? amount;
  final DateTime? date;
  final String? attachmentUrl;

  TransactionUpdateDto({
    this.description,
    this.amount,
    this.date,
    this.type,
    this.attachmentUrl, 
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type?.name,
      'description': description,
      'amount': amount,
      'date': date?.toIso8601String(),
      'attachmentUrl': attachmentUrl, 
    };
  }
}