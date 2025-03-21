import 'package:flutter/material.dart';

class ImagesStep extends StatelessWidget {
  const ImagesStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Images',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        // Add your image picker widget here
      ],
    );
  }
}