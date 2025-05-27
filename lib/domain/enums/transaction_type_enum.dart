enum TransactionType { deposit, withdrawal, transfer, investment }

String transactionTypeToString(TransactionType type) {
  const transactionTypeEnumMap = {
    TransactionType.deposit: 'Depósito',
    TransactionType.withdrawal: 'Saque',
    TransactionType.transfer: 'Transferência',
    TransactionType.investment: 'Investimento',
  };

  return transactionTypeEnumMap[type] ?? '';
}
