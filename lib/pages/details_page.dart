import 'package:flutter/material.dart';
import 'package:futsal_booking_app/pages/booking_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/field_model.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the FieldModel from the arguments
    final field = ModalRoute.of(context)!.settings.arguments as FieldModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(field.name), // Access the name directly from the FieldModel
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _imageCarousel(field),
            _fieldInformation(field),
            _fieldMap(field),
            _availabilityButton(context, field),
          ],
        ),
      ),
    );
  }

  Widget _imageCarousel(FieldModel field) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        itemCount: field.detailImageUrl.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Image.asset(field.detailImageUrl[index], fit: BoxFit.cover),
          );
        },
      ),
    );
  }

  Widget _fieldInformation(FieldModel field) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            field.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Location: ${field.location}",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Price: \$${field.price.toStringAsFixed(2)} per hour",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 20),
              const SizedBox(width: 4),
              Text(
                "${field.ratings} / 5.0",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

Widget _fieldMap(FieldModel field) {
  return Container(
    height: 250,
    padding: const EdgeInsets.all(16.0),
    child: GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
          field.coordinates?.latitude ?? 0.0,  // Use null-coalescing operator for fallback
          field.coordinates?.longitude ?? 0.0,  // Use null-coalescing operator for fallback
        ),
        zoom: 14,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('futsalField'),
          position: LatLng(
            field.coordinates?.latitude ?? 0.0,  // Use null-coalescing operator for fallback
            field.coordinates?.longitude ?? 0.0,  // Use null-coalescing operator for fallback
          ),
          infoWindow: InfoWindow(
            title: field.name,
            snippet: field.location,
          ),
        ),
      },
    ),
  );
}

  Widget _availabilityButton(BuildContext context, FieldModel field) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingPage(
                  field: field), // Pass the FieldModel to the BookingPage
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "Check Availability",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
