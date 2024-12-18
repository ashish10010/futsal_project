import 'package:flutter/material.dart';
import 'package:futsal_booking_app/src/features/futsal/data/models/field_model.dart';

class FutsalFieldCard extends StatelessWidget {
  final FieldModel fields;

  const FutsalFieldCard({
    super.key,
    required this.fields,
  });

  // Widget _buildRating() {
  //   final fullStars = double.parse(fields.hourlyPrice).floor() % 5;
  //   final emptyStars = 5 - fullStars;

  //   return Row(
  //     children: List.generate(
  //           fullStars,
  //           (index) => const Icon(Icons.star, color: Colors.orange, size: 16),
  //         ) +
  //         List.generate(
  //           emptyStars,
  //           (index) =>
  //               const Icon(Icons.star_border, color: Colors.orange, size: 16),
  //         ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/details',
          arguments: fields, // Pass FieldModel instance to details page
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
                  fields.cardImg,
                  height: 140,
                  width: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 80,
                    );
                  },
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
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
                      fields.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Location
                    Text(
                      fields.location,
                      style: textTheme.bodySmall?.copyWith(
                          // color: Colors.grey,
                          ),
                    ),
                    const SizedBox(height: 8),
                    // Ratings
                    // _buildRating(),
                    // const SizedBox(height: 8),
                    // Price
                    Text(
                      'Hourly: Rs. ${fields.hourlyPrice}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      'Monthly: Rs. ${fields.monthlyPrice}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
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
