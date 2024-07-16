import 'package:flutter/material.dart';

class YouthPlayerScreen extends StatelessWidget {
  const YouthPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Youth Player Page'),
      ),
      body: const Center(
        child: Text('Youth Player Specific Content'),
      ),
    );
  }
}
