import 'package:equatable/equatable.dart';

class FieldModel extends Equatable {
  final String id; // Firestore's auto-generated document ID
  final String name; 
  final String fieldType; 
  final String imageUrl;
  final String description; 
  final double ratings; 
  final double price; 
  final String location; 

 const FieldModel({
    required this.id,
    this.name = '', 
    this.fieldType = '', 
    this.imageUrl = '',
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
        imageUrl: json['imageUrl'] ?? '',
        description: json['description'] ?? '',
        ratings: (json['ratings'] ?? 0).toDouble(),
        price: (json['price'] ?? 0).toDouble(),
        location: json['location'] ?? '',
      );

  // Convert the model into a Firestore-compatible map
  Map<String, dynamic> toJson() => {
        'name': name,
        'fieldType': fieldType,
        'imageUrl': imageUrl,
        'description': description,
        'ratings': ratings,
        'price': price,
        'location': location,
      };

  @override
  List<Object?> get props => [id, name, fieldType, imageUrl, description, ratings, price, location];
}
