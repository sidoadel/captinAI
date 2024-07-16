import 'package:flutter/material.dart';

class HeadCoachScreen extends StatelessWidget {
  const HeadCoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Head Coach Page'),
      ),
      body: const Center(
        child: Text('Head Coach Specific Content'),
      ),
    );
  }
}
