import 'dart:convert';

class BookingModel {
  final String id;
  final String futsalId;
  final String packageType;
  final double amount;
  final DateTime date;
  final String userId;
  final DateTime createdAt;
  final DateTime? updatedAt; // Nullable for new or incomplete data

  BookingModel({
    required this.id,
    required this.futsalId,
    required this.packageType,
    required this.amount,
    required this.date,
    required this.userId,
    required this.createdAt,
    this.updatedAt,
  });

  BookingModel copyWith({
    String? id,
    String? futsalId,
    String? packageType,
    double? amount,
    DateTime? date,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      futsalId: futsalId ?? this.futsalId,
      packageType: packageType ?? this.packageType,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id, // Correct field for backend ID
      'futsalId': futsalId,
      'packageType': packageType,
      'amount': amount,
      'date': date.toIso8601String(),
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['_id'] ?? '',
      futsalId: map['futsalId'] ?? '',
      packageType: map['packageType'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0, 
      date: DateTime.parse(map['date']), // Parse ISO date string
      userId: map['userId'] ?? '',
      createdAt: DateTime.parse(map['createdAt']), // Parse ISO date string
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null, 
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingModel.fromJson(String source) =>
      BookingModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BookingModel(id: $id, futsalId: $futsalId, packageType: $packageType, amount: $amount, date: $date, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant BookingModel other) {
    if (identical(this, other)) return true;

    return id == other.id &&
        futsalId == other.futsalId &&
        packageType == other.packageType &&
        amount == other.amount &&
        date == other.date &&
        userId == other.userId &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        futsalId.hashCode ^
        packageType.hashCode ^
        amount.hashCode ^
        date.hashCode ^
        userId.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
