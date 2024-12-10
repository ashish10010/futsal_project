// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FieldModel {
  final String id;
  final String cardImg;
  final String img1;
  final String img2;
  final String name;
  final String email;
  final String location;
  final String contact;
  final String monthlyPrice;
  final String hourlyPrice;
  final String courtSize;
  final String userId;
  FieldModel({
    required this.id,
    required this.cardImg,
    required this.img1,
    required this.img2,
    required this.name,
    required this.email,
    required this.location,
    required this.contact,
    required this.monthlyPrice,
    required this.hourlyPrice,
    required this.courtSize,
    required this.userId,
  });

  
   factory FieldModel.empty() {
    return FieldModel(
      id: '',
      cardImg: '',
      img1: '',
      img2: '',
      name: 'Unknown Futsal',
      email: '',
      location: 'Unknown Location',
      contact: '',
      monthlyPrice: '0',
      hourlyPrice: '0',
      courtSize: 'Unknown',
      userId: '',
    );
  }


  FieldModel copyWith({
    String? id,
    String? cardImg,
    String? img1,
    String? img2,
    String? name,
    String? email,
    String? location,
    String? contact,
    String? monthlyPrice,
    String? hourlyPrice,
    String? courtSize,
    String? userId,
  }) {
    return FieldModel(
      id: id ?? this.id,
      cardImg: cardImg ?? this.cardImg,
      img1: img1 ?? this.img1,
      img2: img2 ?? this.img2,
      name: name ?? this.name,
      email: email ?? this.email,
      location: location ?? this.location,
      contact: contact ?? this.contact,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      hourlyPrice: hourlyPrice ?? this.hourlyPrice,
      courtSize: courtSize ?? this.courtSize,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'cardImg': cardImg,
      'img1': img1,
      'img2': img2,
      'name': name,
      'email': email,
      'location': location,
      'contact': contact,
      'monthlyPrice': monthlyPrice,
      'hourlyPrice': hourlyPrice,
      'courtSize': courtSize,
      'userId': userId,
    };
  }

  factory FieldModel.fromMap(Map<String, dynamic> map) {
    return FieldModel(
      id: map['_id'] ?? '', 
      cardImg: map['cardImg'] ?? '',
      img1: map['img1'] ?? '',
      img2: map['img2'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      location: map['location'] ?? '',
      contact: map['contact'] ?? '',
      monthlyPrice: map['monthlyPrice'] ?? '',
      hourlyPrice: map['hourlyPrice'] ?? '',
      courtSize: map['courtSize'] ?? '',
      userId: map['userId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FieldModel.fromJson(String source) =>
      FieldModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FieldModel(cardImg: $cardImg, img1: $img1, img2: $img2, name: $name, email: $email, location: $location, contact: $contact, monthlyPrice: $monthlyPrice, hourlyPrice: $hourlyPrice, courtSize: $courtSize, userId: $userId)';
  }

  @override
  bool operator ==(covariant FieldModel other) {
    if (identical(this, other)) return true;

    return other.cardImg == cardImg &&
        other.img1 == img1 &&
        other.img2 == img2 &&
        other.name == name &&
        other.email == email &&
        other.location == location &&
        other.contact == contact &&
        other.monthlyPrice == monthlyPrice &&
        other.hourlyPrice == hourlyPrice &&
        other.courtSize == courtSize &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return cardImg.hashCode ^
        img1.hashCode ^
        img2.hashCode ^
        name.hashCode ^
        email.hashCode ^
        location.hashCode ^
        contact.hashCode ^
        monthlyPrice.hashCode ^
        hourlyPrice.hashCode ^
        courtSize.hashCode ^
        userId.hashCode;
  }
}
