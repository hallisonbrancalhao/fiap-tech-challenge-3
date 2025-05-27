enum TransactionType { deposit, withdrawal, transfer, investment }

String transactionTypeToString(TransactionType type) {
  switch (type) {
    case TransactionType.deposit:
      return 'Depósito';
    case TransactionType.withdrawal:
      return 'Saque';
    case TransactionType.transfer:
      return 'Transferência';
    case TransactionType.investment:
      return 'Investimento';
  }
}
