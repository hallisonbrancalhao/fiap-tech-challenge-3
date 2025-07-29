class Pin {
  final String value;
  final DateTime createdAt;
  final DateTime? lastUsedAt;

  Pin({required this.value, required this.createdAt, this.lastUsedAt});

  bool get isValid => value.length == 4 && RegExp(r'^[0-9]{4}').hasMatch(value);

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'createdAt': createdAt.toIso8601String(),
      'lastUsedAt': lastUsedAt?.toIso8601String(),
    };
  }

  factory Pin.fromJson(Map<String, dynamic> json) {
    return Pin(
      value: json['value'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUsedAt:
          json['lastUsedAt'] != null
              ? DateTime.parse(json['lastUsedAt'] as String)
              : null,
    );
  }

  Pin copyWith({String? value, DateTime? createdAt, DateTime? lastUsedAt}) {
    return Pin(
      value: value ?? this.value,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }
}
