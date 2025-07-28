// lib/domain/entities/transaction.dart

import 'package:tech_challenge_3/domain/enums/transaction_type_enum.dart';
import 'package:tech_challenge_3/data/models/transaction_update_dto.dart';
import 'package:tech_challenge_3/data/models/transaction_create_dto.dart'; // Mantenha este import

class TransactionEntity {
  final String? id;
  final String userUid;
  final TransactionType type;
  final String description;
  final double amount;
  final DateTime date;
  final String? attachmentUrl;

  TransactionEntity({
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

  factory TransactionEntity.fromJson(Map<String, dynamic> json) {
    return TransactionEntity(
      id: json['id'] as String?,
      userUid: json['userUid'] as String,
      type: TransactionType.values.byName(json['type'] as String),
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      attachmentUrl: json['attachmentUrl'] as String?,
    );
  }

  factory TransactionEntity.fromCreateDto(TransactionCreateDto dto, {required String userUid}) {
    return TransactionEntity(
      id: null,
      userUid: userUid,
      type: TransactionType.fromString(dto.type.name),
      description: dto.description,
      amount: dto.amount,
      date: dto.date,
      attachmentUrl: null, 
    );
  }

 
  factory TransactionEntity.fromUpdateDto(
      TransactionUpdateDto dto, {
      required String id,
      required String userUid,
    }) {
    return TransactionEntity(
      id: id,
      userUid: userUid, 
      type: dto.type != null ? TransactionType.fromString(dto.type!.name) : TransactionType.deposit, 
      description: dto.description ?? '', // Fornecer um padrão para campos nulos
      amount: dto.amount ?? 0.0, // Fornecer um padrão para campos nulos
      date: dto.date ?? DateTime.now(), // Fornecer um padrão para campos nulos
      attachmentUrl: dto.attachmentUrl, // Pode ser nulo
    );
  }
}