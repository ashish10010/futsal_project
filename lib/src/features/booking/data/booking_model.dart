// import 'dart:convert';

// class BookingModel {
//   final String id;
//   final String futsalId;
//   final String packageType;
//   final String amount;
//   final DateTime date;
//   final String userId;
//   final DateTime createdAt;
//   final DateTime? updatedAt;

//   BookingModel({
//     required this.id,
//     required this.futsalId,
//     required this.packageType,
//     required this.amount,
//     required this.date,
//     required this.userId,
//     required this.createdAt,
//     this.updatedAt,
//   });

//   BookingModel copyWith({
//     String? id,
//     String? futsalId,
//     String? packageType,
//     String? amount,
//     DateTime? date,
//     String? userId,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) {
//     return BookingModel(
//       id: id ?? this.id,
//       futsalId: futsalId ?? this.futsalId,
//       packageType: packageType ?? this.packageType,
//       amount: amount ?? this.amount,
//       date: date ?? this.date,
//       userId: userId ?? this.userId,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       '_id': id, // Correct field for backend ID
//       'futsalId': futsalId,
//       'packageType': packageType,
//       'amount': amount,
//       'date': date.toIso8601String(),
//       'userId': userId,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//     };
//   }

//   factory BookingModel.fromMap(Map<String, dynamic> map) {
//     return BookingModel(
//       id: map['_id'] ?? '',
//       futsalId: map['futsalId'] ?? '',
//       packageType: map['packageType'] ?? '',
//       amount: (map['amount']) ?? '',
//       date: DateTime.parse(map['date']), // Parse ISO date string
//       userId: map['userId'] ?? '',
//       createdAt: DateTime.parse(map['createdAt']), // Parse ISO date string
//       updatedAt:
//           map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory BookingModel.fromJson(String source) =>
//       BookingModel.fromMap(json.decode(source));

//   @override
//   String toString() {
//     return 'BookingModel(id: $id, futsalId: $futsalId, packageType: $packageType, amount: $amount, date: $date, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt,)';
//   }

//   @override
//   bool operator ==(covariant BookingModel other) {
//     if (identical(this, other)) return true;

//     return id == other.id &&
//         futsalId == other.futsalId &&
//         packageType == other.packageType &&
//         amount == other.amount &&
//         date == other.date &&
//         userId == other.userId &&
//         createdAt == other.createdAt &&
//         updatedAt == other.updatedAt;
//   }

//   @override
//   int get hashCode {
//     return id.hashCode ^
//         futsalId.hashCode ^
//         packageType.hashCode ^
//         amount.hashCode ^
//         date.hashCode ^
//         userId.hashCode ^
//         createdAt.hashCode ^
//         updatedAt.hashCode;
//   }
// }

// To parse this JSON data, do
//
//     final bookingModel = bookingModelFromJson(jsonString);

import 'dart:convert';

List<BookingModel> bookingModelFromJson(String str) => List<BookingModel>.from(
    json.decode(str).map((x) => BookingModel.fromJson(x)));

String bookingModelToJson(List<BookingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookingModel {
  final String id;
  final List<Futsalid> futsalid;
  final String packageType;
  final String amount;
  final dynamic date;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  BookingModel({
    required this.id,
    required this.futsalid,
    required this.packageType,
    required this.amount,
    required this.date,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        id: json["_id"],
        futsalid: List<Futsalid>.from(
            json["futsalid"].map((x) => Futsalid.fromJson(x))),
        packageType: json["packageType"],
        amount: json["amount"],
        date: json["date"],
        userId: json["userId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "futsalid": List<dynamic>.from(futsalid.map((x) => x.toJson())),
        "packageType": packageType,
        "amount": amount,
        "date": date,
        "userId": userId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class Futsalid {
  final String id;
  final String name;
  final String email;
  final String location;
  final String contact;
  final String monthlyPrice;
  final String hourlyPrice;
  final String courtSize;
  final String cardImg;
  final String img1;
  final String img2;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Futsalid({
    required this.id,
    required this.name,
    required this.email,
    required this.location,
    required this.contact,
    required this.monthlyPrice,
    required this.hourlyPrice,
    required this.courtSize,
    required this.cardImg,
    required this.img1,
    required this.img2,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Futsalid.fromJson(Map<String, dynamic> json) => Futsalid(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        location: json["location"],
        contact: json["contact"],
        monthlyPrice: json["monthlyPrice"],
        hourlyPrice: json["hourlyPrice"],
        courtSize: json["courtSize"],
        cardImg: json["cardImg"],
        img1: json["img1"],
        img2: json["img2"],
        userId: json["userId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "location": location,
        "contact": contact,
        "monthlyPrice": monthlyPrice,
        "hourlyPrice": hourlyPrice,
        "courtSize": courtSize,
        "cardImg": cardImg,
        "img1": img1,
        "img2": img2,
        "userId": userId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
