import 'package:tech_challenge_3/domain/enums/transaction_type_enum.dart';

class TransactionUpdateDto {
  final TransactionType? type;
  final String? description;
  final double? amount;
  final DateTime? date;

  TransactionUpdateDto({this.description, this.amount, this.date, this.type});

  Map<String, dynamic> toJson() {
    return {
      'type': type?.name,
      'description': description,
      'amount': amount,
      'date': date?.toIso8601String(),
    };
  }
}
