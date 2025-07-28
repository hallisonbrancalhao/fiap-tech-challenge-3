import 'package:tech_challenge_3/domain/entities/transaction.dart';
import 'package:tech_challenge_3/domain/enums/transaction_type_enum.dart';

class TransactionModel {
  final String id;
  final String userUid;
  final String type; // No modelo de dados, o tipo é String (como vem do backend)
  final String description;
  final double amount;
  final DateTime date;
  final String? attachmentUrl;

  TransactionModel({
    required this.id,
    required this.userUid,
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
    this.attachmentUrl,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as String? ?? '', // Garante String não nula para 'id'
      userUid: map['userUid'] as String,
      type: map['type'] as String, // Garante que 'type' é lido como String
      description: map['description'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date'] as String), // Garante que 'date' é String
      attachmentUrl: map['attachmentUrl'] as String?, // Garante 'String?'
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userUid': userUid,
      'type': type, // Permanece como String para escrita no backend
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'attachmentUrl': attachmentUrl,
    };
  }

  // MÉTODOS DE CONVERSÃO PARA ENTITY (Corrigidos)
  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      userUid: userUid,
      type: TransactionType.fromString(type), // Converte String do Model para Enum da Entity
      description: description,
      amount: amount,
      date: date,
      attachmentUrl: attachmentUrl,
    );
  }

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id ?? '', // Converte String? da Entity para String do Model
      userUid: entity.userUid,
      type: entity.type.name, // Converte Enum da Entity para String do Model
      description: entity.description,
      amount: entity.amount,
      date: entity.date,
      attachmentUrl: entity.attachmentUrl,
    );
  }
}