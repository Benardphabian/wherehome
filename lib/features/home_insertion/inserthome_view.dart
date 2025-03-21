import 'package:flutter/material.dart';
import 'package:wherehome/features/home_insertion/home_insertion_navigation.dart';

class HomeInsertion extends StatelessWidget {
  const HomeInsertion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Home'),
      ),
      body: const HomeInsertionNavigation(),
    );
  }
}
