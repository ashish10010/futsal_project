import 'package:equatable/equatable.dart';

class FieldModel extends Equatable {
  final String id;
  final String? name;
  final String? fieldType;
  final String? imageUrl;
  final String? description;
  final double? rating;
  final double? price;

 const FieldModel(
      {required this.id,
      this.name = '',
      this.fieldType = '',
      this.imageUrl = '',
      this.description = '',
      this.rating = 0.0,
      this.price = 0.0});

  factory FieldModel.fromJson(String id, Map<String, dynamic> json) =>
      FieldModel(
        id: id,
        name: json['name'],
        imageUrl: json['imageUrl'],
        fieldType: json['fieldType'],
        description: json['description'],
        rating: json['rating'],
        price: json['price'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name' : name,
    'imageUrl' : imageUrl,
    'fieldType': fieldType,
    'description': description,
    'rating' : rating,
    'price' : price,
  };

  @override
    List<Object?> get props => [id, name, imageUrl,fieldType,rating,price];
  
}
