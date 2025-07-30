import 'package:tech_challenge_3/domain/entities/pin.dart';

class PinDto {
  final String value;
  final DateTime createdAt;
  final DateTime? lastUsedAt;

  PinDto({required this.value, required this.createdAt, this.lastUsedAt});

  factory PinDto.fromEntity(Pin pin) {
    return PinDto(
      value: pin.value,
      createdAt: pin.createdAt,
      lastUsedAt: pin.lastUsedAt,
    );
  }

  Pin toEntity() {
    return Pin(value: value, createdAt: createdAt, lastUsedAt: lastUsedAt);
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'createdAt': createdAt.toIso8601String(),
      'lastUsedAt': lastUsedAt?.toIso8601String(),
    };
  }

  factory PinDto.fromJson(Map<String, dynamic> json) {
    return PinDto(
      value: json['value'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUsedAt:
          json['lastUsedAt'] != null
              ? DateTime.parse(json['lastUsedAt'] as String)
              : null,
    );
  }
}
