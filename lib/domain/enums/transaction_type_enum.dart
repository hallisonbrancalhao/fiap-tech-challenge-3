enum TransactionType {
  deposit,
  withdrawal,
  transfer,
  investment;

  factory TransactionType.fromString(String typeString) {
    try {
      return TransactionType.values.byName(typeString.toLowerCase());
    } on ArgumentError {
      throw ArgumentError('Tipo de transação desconhecido: $typeString');
    }
  }
}
String transactionTypeToString(TransactionType type) {
  const transactionTypeEnumMap = {
    TransactionType.deposit: 'Depósito',
    TransactionType.withdrawal: 'Saque',
    TransactionType.transfer: 'Transferência',
    TransactionType.investment: 'Investimento',
  };

  return transactionTypeEnumMap[type] ?? '';
}