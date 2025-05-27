import 'package:tech_challenge_3/domain/enums/transaction_type_enum.dart';

class TransactionEntity {
  final String uid;
  final String userUid;
  final TransactionType type;
  final String description;
  final double amount;
  final DateTime date;

  TransactionEntity({
    required this.uid,
    required this.userUid,
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'userUid': userUid,
      'type': type.name,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  // From JSON
  factory TransactionEntity.fromJson(Map<String, dynamic> json) {
    return TransactionEntity(
      uid: json['uid'] as String,
      userUid: json['userUid'] as String,
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == 'TransactionType.${json['type']}',
        orElse: () => TransactionType.expense,
      ),
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );
  }
}
