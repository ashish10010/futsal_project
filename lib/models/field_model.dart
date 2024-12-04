import 'package:equatable/equatable.dart';

class FieldModel extends Equatable {
  final String id; // Firestore's auto-generated document ID
  final String name;
  final String fieldType;
  final String cardImageUrl;  // Updated for card image URL
  final List<String> detailImageUrl;  // Updated for detail image URLs
  final String description;
  final double ratings;
  final double price;
  final String location;

  const FieldModel({
    required this.id,
    this.name = '',
    this.fieldType = '',
    this.cardImageUrl = '',
    this.detailImageUrl = const [],
    this.description = '',
    this.ratings = 0.0,
    this.price = 0,
    this.location = '',
  });

  // Factory constructor to create a model from Firestore data
  factory FieldModel.fromJson(String id, Map<String, dynamic> json) => FieldModel(
        id: id,
        name: json['name'] ?? '',
        fieldType: json['fieldType'] ?? '',
        cardImageUrl: json['cardImageUrl'] ?? '',  // Adjusted field
        detailImageUrl: List<String>.from(json['detailImageUrl'] ?? []),  // Adjusted for list of URLs
        description: json['description'] ?? '',
        ratings: (json['ratings'] ?? 0).toDouble(),
        price: (json['price'] ?? 0).toDouble(),
        location: json['location'] ?? '',
      );

  // Convert the model into a Firestore-compatible map
  Map<String, dynamic> toJson() => {
        'name': name,
        'fieldType': fieldType,
        'cardImageUrl': cardImageUrl,  // Adjusted field
        'detailImageUrl': detailImageUrl,  // Adjusted for list of URLs
        'description': description,
        'ratings': ratings,
        'price': price,
        'location': location,
      };

  @override
  List<Object?> get props => [
        id, name, fieldType, cardImageUrl, detailImageUrl, description, ratings, price, location
      ];
}
