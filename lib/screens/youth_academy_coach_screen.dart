import 'package:flutter/material.dart';

class YouthAcademyCoachScreen extends StatelessWidget {
  const YouthAcademyCoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Youth Academy Coach Page'),
      ),
      body: const Center(
        child: Text('Youth Academy Coach Specific Content'),
      ),
    );
  }
}
