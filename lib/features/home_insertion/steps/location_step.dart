import 'package:flutter/material.dart';
import 'package:wherehome/features/home_insertion/widgets/address_search_widget.dart';

class LocationStep extends StatelessWidget {
  const LocationStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Location',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        AddressSearchWidget(onSelected: (suggestion) {
          // Handle selected location
        }),
      ],
    );
  }
}