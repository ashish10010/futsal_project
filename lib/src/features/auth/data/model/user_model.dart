import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String? name;
  final String? email;
  final String? photo;

  static const empty = UserModel(id: '');

  const UserModel({
    required this.id,
    this.name,
    this.email,
    this.photo,
  });

  /// Convert UserModel to Map for API requests
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name ?? '',
      'email': email ?? '',
      'photo': photo ?? '',
    };
  }

  /// Create UserModel from API JSON response
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '', // Adjust to match the API's key for user ID
      name: map['name'],
      email: map['email'],
      photo: map['photo'],
    );
  }

  @override
  List<Object?> get props => [id, name, email, photo];
}
