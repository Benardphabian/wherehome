import 'package:flutter/material.dart';

class ReviewStep extends StatelessWidget {
  const ReviewStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Review & Submit',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        // Add review content here
        ElevatedButton(
          onPressed: () {
            // Handle submission
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}