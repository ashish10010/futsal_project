import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_models.dart';
import '../service/user_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign in with email and password
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel user =
          await UserService().getUserById(userCredential.user!.uid);
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  /// Sign up a new user
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      //create the user using firebase auth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      //Usermodel object to represent new user
      UserModel user = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
      );
      //save the user's data in firestore(users collection)
      await UserService().setUser(user);
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  //Signout the current User
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
