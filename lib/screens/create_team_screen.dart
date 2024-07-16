// Assuming you have already imported necessary packages and models

// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:captinai/api_service.dart'; // Replace with your API service

class CreateTeamScreen extends StatefulWidget {
  final int headCoachId; // Replace with your head coach ID

  const CreateTeamScreen({super.key, required this.headCoachId});

  @override
  _CreateTeamScreenState createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final TextEditingController teamNameController = TextEditingController();
  final TextEditingController memberEmailController = TextEditingController();

  ApiService apiService = ApiService(); // Replace with your API service instance

  void createTeam(BuildContext context) async {
    String teamName = teamNameController.text;
    String memberEmail = memberEmailController.text;
    try {
      var response = await apiService.createTeam(teamName, [memberEmail], widget.headCoachId);
      // Handle success or show confirmation
      if (kDebugMode) {
        print('Team created successfully');
      }
      Navigator.pop(context); // Navigate back to previous screen after creating team
    } catch (e) {
      if (kDebugMode) {
        print('Error creating team: $e');
      }
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create team. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Team'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: teamNameController,
              decoration: const InputDecoration(
                labelText: 'Team Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: memberEmailController,
              decoration: const InputDecoration(
                labelText: 'Member Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => createTeam(context),
              child: const Text('Create Team'),
            ),
          ],
        ),
      ),
    );
  }
}
