import 'package:flutter/material.dart';
import 'package:futsal_booking_app/models/field_model.dart';

class FutsalFieldCard extends StatelessWidget {
  final FieldModel
      fields; // FieldModel instance instead of individual properties

  const FutsalFieldCard({
    super.key,
    required this.fields, // Accepting a FieldModel instance
  });

  // A method to create a rating display with star icons
  Widget _buildRating(double? rating) {
    final fullStars = rating?.floor() ?? 0;
    final halfStars = (rating ?? 0) - fullStars > 0.0 ? 1 : 0;
    final emptyStars = 5 - fullStars - halfStars;

    return Row(
      children: List.generate(
              fullStars,
              (index) =>
                  const Icon(Icons.star, color: Colors.orange, size: 16)) +
          List.generate(
              halfStars,
              (index) =>
                  const Icon(Icons.star_half, color: Colors.orange, size: 16)) +
          List.generate(
              emptyStars,
              (index) => const Icon(Icons.star_border,
                  color: Colors.orange, size: 16)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/details',
          arguments: fields, // Passing the FieldModel instance to details page
        );
      },
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Futsal Field Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  fields
                      .cardImageUrl, // Using the FieldModel instance to access properties
                  height: 140,
                  width: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              // Field Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      fields.name, // Using FieldModel to get the name
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        // color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Location
                    Text(
                      'Location: ${fields.location}', // Using FieldModel to get the location
                      style: textTheme.bodyMedium?.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    // Ratings
                    _buildRating(
                        fields.ratings), // Using FieldModel to get the rating
                    const SizedBox(height: 6),
                    // Price
                    Text(
                      'Rs. ${fields.price}/hr', // Using FieldModel to get the price
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
