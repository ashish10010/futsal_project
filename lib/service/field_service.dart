import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:futsal_booking_app/models/field_model.dart';

class FieldService {
  final CollectionReference _fieldRef =
      FirebaseFirestore.instance.collection('futsalFields');

  // Fetch all fields from Firestore
  Future<List<FieldModel>> fetchFields() async {
    try {
      // Retrieve data from Firestore
      QuerySnapshot result = await _fieldRef.get();

      // Map Firestore documents to a list of FieldModel objects
      List<FieldModel> dataField = result.docs.map((doc) {
        return FieldModel.fromJson(
          doc.id, // Use Firestore's auto-generated ID
          doc.data() as Map<String, dynamic>,
        );
      }).toList();

      return dataField;
    } catch (e) {
      print('Error fetching futsal fields: $e');
      rethrow;
    }
  }
}
