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
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Fetching the GeoPoint coordinates
        GeoPoint? geoPoint = data['coordinates'] as GeoPoint?;

        // Return the FieldModel object
        return FieldModel.fromJson(
          doc.id,  // Use Firestore's auto-generated ID
          {
            'name': data['name'] ?? '',
            'fieldType': data['fieldType'] ?? '',
            'cardImageUrl': data['cardImageUrl'] ?? '',
            'detailImageUrl': List<String>.from(data['detailImageUrl'] ?? []),
            'description': data['description'] ?? '',
            'ratings': (data['ratings'] ?? 0).toDouble(),
            'price': (data['price'] ?? 0).toDouble(),
            'location': data['location'] ?? '',
            'coordinates': geoPoint,  // Add coordinates to the data
          },
        );
      }).toList();

      return dataField;
    } catch (e) {
      print('Error fetching futsal fields: $e');
      rethrow;
    }
  }
}
