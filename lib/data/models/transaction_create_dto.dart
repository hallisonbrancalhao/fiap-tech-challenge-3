import 'package:tech_challenge_3/domain/enums/transaction_type_enum.dart';

class TransactionCreateDto {
  final String? userUid;
  final TransactionType type;
  final String description;
  final double amount;
  final DateTime date;

  TransactionCreateDto({
    this.userUid,
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
  });
}
