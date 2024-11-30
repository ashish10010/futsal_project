import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_models.dart';

class UserService {
  final CollectionReference _userReference =
      FirebaseFirestore.instance.collection('users');

  /// Save a user to Firestore
  Future<void> setUser(UserModel user) async {
    try {
      DocumentSnapshot snapshot = await _userReference.doc(user.id).get();
      if (!snapshot.exists) {
        //create a new document if it doesnot exits
        await _userReference.doc(user.id).set(({
              'name': user.name,
              'email': user.email,
              'photo': user.photo ?? '',
            }));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Retrieve a user by their ID
  Future<UserModel> getUserById(String id) async {
    try {
      DocumentSnapshot snapshot = await _userReference.doc(id).get();
      //check if the document exists
      if (snapshot.exists) {
        return UserModel(
          id: id,
          name: snapshot['name'],
          email: snapshot['email'],
          photo: snapshot['photo'] ?? '',
        );
      } else {
        throw Exception('User Document not found');
      }
    } catch (e) {
      throw Exception(e.toString()); // Handle errors
    }
  }
}
