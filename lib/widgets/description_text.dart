import 'package:flutter/material.dart';
import '../constants.dart';

class DescriptionText extends StatelessWidget {
  const DescriptionText({super.key, required this.title, required this.value});

  final String title, value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: lightTextStyle.copyWith(
            fontSize: 10,
            fontWeight: light,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: blackTextStyle.copyWith(
            fontSize: 12,
            fontWeight: semiBold,
          ),
        ),
      ],
    );
  }
}