class TransactionEntity {
  final int id;
  final String type;
  final double value;
  final DateTime createdAt;
  final int userId;

  TransactionEntity({
    required this.id,
    required this.type,
    required this.value,
    required this.createdAt,
    required this.userId,
  });
}
