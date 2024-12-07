import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:futsal_booking_app/models/field_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:futsal_booking_app/src/core/constants/constants.dart';
import 'package:futsal_booking_app/src/core/widgets/gradient_button.dart';

class DetailPage extends StatelessWidget {
  final FieldModel field;

  const DetailPage({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          field.name,
          style: whiteTextStyle.copyWith(fontSize: 20, fontWeight: semiBold),
        ),
        backgroundColor: Palette.primaryGreen,
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
    return CarouselSlider.builder(
      itemCount: field.detailImageUrl.length,
      itemBuilder: (context, index, realIndex) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              field.detailImageUrl[index],
              fit: BoxFit.cover,
              width: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.error, color: Colors.red),
                );
              },
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 250,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
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
            style: headlineTextStyle,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_pin, color: Palette.darkGreen),
              const SizedBox(width: 8),
              Text(
                field.location,
                style: bodyTextStyle,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Price: Rs.${field.price.toStringAsFixed(2)} per hour",
            style: subtitleTextStyle.copyWith(fontWeight: semiBold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 20),
              const SizedBox(width: 4),
              Text(
                "${field.ratings} / 5.0",
                style: bodyTextStyle,
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
            field.coordinates?.latitude ?? 0.0,
            field.coordinates?.longitude ?? 0.0,
          ),
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('futsalField'),
            position: LatLng(
              field.coordinates?.latitude ?? 0.0,
              field.coordinates?.longitude ?? 0.0,
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
      child: AuthGradientButton(
        buttonText: "Check Availability",
        onTap: () {
          Navigator.pushNamed(context, '/booking', arguments: field);
        },
      ),
    );
  }
}
