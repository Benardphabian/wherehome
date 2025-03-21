import 'package:flutter/material.dart';
import 'package:wherehome/features/home_insertion/widgets/switch_buttons_room_number.dart';
import 'package:wherehome/features/home_insertion/widgets/filter_features.dart';

class FeaturesStep extends StatelessWidget {
  final TextEditingController areaController = TextEditingController();
  int rooms = 1;
  List<String> features = [];

  FeaturesStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Features',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        SwitchButtonsRooms(
          onSwitched: (int number) {
            rooms = number;
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: areaController,
          decoration: const InputDecoration(
            labelText: 'Area (m²)',
            hintText: 'Enter the area',
          ),
        ),
        const SizedBox(height: 16),
        FilterFeatures(
          features: const [], // Add your features list here
          onSelectionChanged: (selected) {
            features = selected;
          },
        ),
      ],
    );
  }
}