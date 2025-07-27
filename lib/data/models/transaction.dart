import 'package:tech_challenge_3/domain/entities/transaction.dart';
import 'package:tech_challenge_3/domain/enums/transaction_type_enum.dart';

class TransactionModel {
  final String? id;
  final String userUid;
  final TransactionType type;
  final String description;
  final double amount;
  final DateTime date;
  final String? attachmentUrl;

  TransactionModel({
    this.id,
    required this.userUid,
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
    this.attachmentUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userUid': userUid,
      'type': type.name,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'attachmentUrl': attachmentUrl,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String?,
      userUid: json['userUid'] as String,
      type: TransactionType.values.byName(json['type'] as String),
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      attachmentUrl: json['attachmentUrl'] as String?,
    );
  }
}

extension TransactionXModel on TransactionModel {
  TransactionEntity toEntity() {
    return TransactionEntity(
      userUid: userUid,
      type: type,
      description: description,
      amount: amount,
      date: date,
    );
  }
}
