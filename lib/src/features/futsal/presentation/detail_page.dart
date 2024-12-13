import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:futsal_booking_app/src/features/futsal/data/models/field_model.dart';
import '../../../core/constants/constants.dart';
import '../../../core/widgets/gradient_button.dart';

class DetailPage extends StatelessWidget {
  final FieldModel field;

  const DetailPage({
    super.key,
    required this.field,
  });

  // Predefined map of field names (or IDs) to their latitude and longitude
  static final Map<String, LatLng> coordinatesMap = {
    "ABC Futsal": const LatLng(28.235454, 83.989304),
    "Chin Futsal": const LatLng(28.251275, 83.985669),
    "Tutisal Arena": const LatLng(28.335721, 83.986700),
    "Khelkunj Arena Swimminpool and Futsal": const LatLng(28.211924, 84.014808),
    "Ranipauwa Sports Center": const LatLng(28.220292, 83.998779),
  };

  @override
  Widget build(BuildContext context) {
    final LatLng? coordinates = coordinatesMap[field.name];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          field.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Palette.primaryGreen,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _imageCarousel(field),
              _fieldInformation(field),
              if (coordinates != null)
                _fieldMap(coordinates)
              else
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Location not available for this field.",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              _availabilityButton(context, field),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageCarousel(FieldModel field) {
    return CarouselSlider(
      items: [
        Image.network(
          field.img1,
          fit: BoxFit.cover,
          width: double.infinity,
          loadingBuilder: _loadingBuilder,
          errorBuilder: _errorBuilder,
        ),
        Image.network(
          field.img2,
          fit: BoxFit.cover,
          width: double.infinity,
          loadingBuilder: _loadingBuilder,
          errorBuilder: _errorBuilder,
        ),
      ],
      options: CarouselOptions(
        height: 220,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: true,
        viewportFraction: 0.8,
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
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.location_pin,
                color: Palette.darkGreen,
              ),
              const SizedBox(width: 8),
              Text(
                field.location,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Hourly Price: Rs. ${field.hourlyPrice}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Monthly Price: Rs. ${field.monthlyPrice}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Court Size: ${field.courtSize}",
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.phone,
                color: Palette.primaryGreen,
              ),
              const SizedBox(width: 8),
              Text(
                "Contact: ${field.contact}",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fieldMap(LatLng coordinates) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 230,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Palette.grey, width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: coordinates,
              zoom: 14,
            ),
            markers: {
              Marker(
                markerId: const MarkerId("futsal_location"),
                position: coordinates,
                infoWindow: InfoWindow(
                  title: field.name,
                  snippet: field.location,
                ),
              ),
            },
          ),
        ),
      ),
    );
  }

  Widget _availabilityButton(BuildContext context, FieldModel field) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AuthGradientButton(
        buttonText: "Check Availability",
        onTap: () {
          Navigator.pushNamed(
            context,
            '/booking',
            arguments: field,
          );
        },
      ),
    );
  }

  Widget _loadingBuilder(
      BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) return child;
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded /
                (loadingProgress.expectedTotalBytes ?? 1)
            : null,
      ),
    );
  }

  Widget _errorBuilder(BuildContext context, Object error, StackTrace? stack) {
    return const Center(
      child: Icon(Icons.error, color: Colors.red, size: 50),
    );
  }
}
