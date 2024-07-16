// Assuming you have already imported necessary packages and models

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:captinai/api_service.dart';
import 'package:captinai/models/session.dart'; // Replace with your session model


class TrainingSessionsScreen extends StatefulWidget {
  final int coachId; // Replace with your coach ID

  const TrainingSessionsScreen({super.key, required this.coachId});

  @override
  _TrainingSessionsScreenState createState() => _TrainingSessionsScreenState();
}

class _TrainingSessionsScreenState extends State<TrainingSessionsScreen> {
  List<Session> sessions = []; // Replace with your session model

  ApiService apiService = ApiService(); // Replace with your API service instance

  @override
  void initState() {
    super.initState();
    fetchSessions();
  }

  Future<void> fetchSessions() async {
    int coachId = widget.coachId;
    try {
      var response = await apiService.fetchSessions(coachId);
      setState(() {
        sessions = response['sessions'].map<Session>((session) => Session.fromJson(session)).toList(); // Replace with your session model mapping
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching sessions: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Sessions'),
      ),
      body: ListView.builder(
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Session ${sessions[index].id}'), // Replace with your session model property
            subtitle: Text('Date: ${sessions[index].date}, Time: ${sessions[index].time}'), // Replace with your session model properties
            onTap: () {
              // Navigate to session details screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SessionDetailsScreen(sessionId: sessions[index].id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add session screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditSessionScreen(),
            ),
          ).then((_) {
            // Refresh sessions list after adding session
            fetchSessions();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddEditSessionScreen extends StatelessWidget {
  const AddEditSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Session'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement add session logic here
              },
              child: const Text('Add Session'),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SessionDetailsScreen extends StatelessWidget {
  final int sessionId; // Replace with your session ID

  SessionDetailsScreen({super.key, required this.sessionId});

  ApiService apiService = ApiService(); // Replace with your API service instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Details'),
      ),
      body: FutureBuilder(
        future: apiService.getSessionDetails(sessionId),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Session session = Session.fromJson(snapshot.data!); // Replace with your session model
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: ${session.date}'), // Replace with your session model property
                  Text('Time: ${session.time}'), // Replace with your session model property
                  // Add more session details and AI feedback display
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
