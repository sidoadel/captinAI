import 'package:flutter/material.dart';

class CoachScreen extends StatelessWidget {
  const CoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach Page'),
      ),
      body: const Center(
        child: Text('Coach Specific Content'),
      ),
    );
  }
}
