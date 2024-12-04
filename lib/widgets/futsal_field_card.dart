import 'package:flutter/material.dart';

class FutsalFieldCard extends StatelessWidget {
  final String name;
  final double price;
  final String location;
  final String imageUrl;
  final double? ratings;

  const FutsalFieldCard({
    super.key,
    required this.name,
    required this.price,
    required this.location,
    required this.imageUrl,
    this.ratings = 0.0,
  });

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
        );
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Futsal Field Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imageUrl,
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
                    Text(name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                    const SizedBox(height: 4),
                    Text(
                      'Location: $location',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Rs. $price/hr',
                      style: const TextStyle(
                        fontSize: 14,
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
