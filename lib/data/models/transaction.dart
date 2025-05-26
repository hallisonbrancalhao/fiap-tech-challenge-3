import 'package:tech_challenge_3/domain/entities/transaction.dart';

class TransactionModel {
  final int id;
  final String type;
  final double value;
  final DateTime createdAt;
  final int userId;

  TransactionModel({
    required this.id,
    required this.type,
    required this.value,
    required this.createdAt,
    required this.userId,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int,
      type: map['type'] as String,
      value: map['value'] as double,
      createdAt: map['created_at'] as DateTime,
      userId: map['user_id'] as int,
    );
  }
}

extension TransactionXModel on TransactionModel {
  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      type: type,
      value: value,
      createdAt: createdAt,
      userId: userId,
    );
  }
}
