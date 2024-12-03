import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/ratings_cubit.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          BlocBuilder<RatingCubit, double>(
            builder: (context, rating) {
              return Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      // When a star is tapped, update the rating
                      context.read<RatingCubit>().setRating(index + 1.0);
                    },
                    child: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                      size: 24.0,
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
