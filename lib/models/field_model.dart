import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class FieldModel extends Equatable {
  final String id; 
  final String name;
  final String fieldType;
  final String cardImageUrl;
  final List<String> detailImageUrl;
  final String description;
  final double ratings;
  final double price;
  final String location;
  final GeoPoint? coordinates;  // Add coordinates to the model

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
    this.coordinates,  // Include coordinates in the constructor
  });

  // Factory constructor to create a model from Firestore data
  factory FieldModel.fromJson(String id, Map<String, dynamic> json) => FieldModel(
        id: id,
        name: json['name'] ?? '',
        fieldType: json['fieldType'] ?? '',
        cardImageUrl: json['cardImageUrl'] ?? '',
        detailImageUrl: List<String>.from(json['detailImageUrl'] ?? []),
        description: json['description'] ?? '',
        ratings: (json['ratings'] ?? 0).toDouble(),
        price: (json['price'] ?? 0).toDouble(),
        location: json['location'] ?? '',
        coordinates: json['coordinates'] is GeoPoint ? json['coordinates'] : null,  // Fetch coordinates (GeoPoint)
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'fieldType': fieldType,
        'cardImageUrl': cardImageUrl,
        'detailImageUrl': detailImageUrl,
        'description': description,
        'ratings': ratings,
        'price': price,
        'location': location,
        'coordinates': coordinates,  // Include coordinates in the map
      };

  @override
  List<Object?> get props => [
        id, name, fieldType, cardImageUrl, detailImageUrl, description, ratings, price, location, coordinates
      ];
}
