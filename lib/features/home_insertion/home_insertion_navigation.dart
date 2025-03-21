import 'package:flutter/material.dart';
import 'package:wherehome/features/home_insertion/steps/basic_info_step.dart';
import 'package:wherehome/features/home_insertion/steps/location_step.dart';
import 'package:wherehome/features/home_insertion/steps/features_step.dart';
import 'package:wherehome/features/home_insertion/steps/images_step.dart';
import 'package:wherehome/features/home_insertion/steps/timetable_step.dart';
import 'package:wherehome/features/home_insertion/steps/review_step.dart';

class HomeInsertionNavigation extends StatefulWidget {
  const HomeInsertionNavigation({super.key});

  @override
  State<HomeInsertionNavigation> createState() => _HomeInsertionNavigationState();
}

class _HomeInsertionNavigationState extends State<HomeInsertionNavigation> {
  int _currentStep = 0;

  final List<Widget> _steps = [
    BasicInfoStep(),
    const LocationStep(),
    FeaturesStep(),
    const ImagesStep(),
    const TimetableStep(),
    const ReviewStep(),
  ];

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Steps View
          Positioned.fill(
            child: Column(
              children: [
                Expanded(child: _steps[_currentStep]),
              ],
            ),
          ),

          /// Progress Bar Positioned at the Top (touching app bar)
          Positioned(
            top: 0, // Move to the top
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / _steps.length,
              backgroundColor: Colors.grey[300], // Light grey background
              color: Colors.blueAccent, // Lighter blue for contrast
              minHeight: 6, // Make it slightly thicker
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            Padding(
              padding: const EdgeInsets.only(left: 16.0), // Added padding to move it away from edge
              child: FloatingActionButton(
                onPressed: _previousStep,
                backgroundColor: Colors.blue,
                child: const Icon(Icons.arrow_back),
              ),
            ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 16.0), // Balanced padding for forward button
            child: FloatingActionButton(
              onPressed: _nextStep,
              backgroundColor: Colors.blue,
              child: Icon(_currentStep == _steps.length - 1 ? Icons.check : Icons.arrow_forward),
            ),
          ),
        ],
      ),
    );
  }
}
