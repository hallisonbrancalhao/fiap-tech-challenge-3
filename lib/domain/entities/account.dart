enum AccountType {
  checking,
  savings,
  investment,
  credit,
}

class Account {
  const Account({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.balance,
    required this.type,
  });

  final String id;
  final String name;
  final String accountNumber;
  final double balance;
  final AccountType type;

  bool get isOverdrawn => balance < 0;
}