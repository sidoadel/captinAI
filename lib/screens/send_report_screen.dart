import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:captinai/models/player.dart';
import 'package:captinai/api_service.dart';

class AnalysisReportsScreen extends StatefulWidget {
  final int coachId;

  const AnalysisReportsScreen({super.key, required this.coachId});

  @override
  _AnalysisReportsScreenState createState() => _AnalysisReportsScreenState();
}

class _AnalysisReportsScreenState extends State<AnalysisReportsScreen> {
  List<Player> players = [];

  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchPlayers();
  }

  Future<void> fetchPlayers() async {
    int coachId = widget.coachId;
    try {
      var response = await apiService.fetchPlayers(coachId);
      setState(() {
        players = response; // List of Player objects
      });
    } catch (error) {
      if (kDebugMode) {
        print('Failed to fetch players: $error');
      }
    }
  }

  void sendReport(int playerId, String content) async {
    try {
      var response = await apiService.sendAnalysisReport(widget.coachId, playerId, content);
      if (kDebugMode) {
        print('Report sent successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending report: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Reports'),
      ),
      body: ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(players[index].name),
            subtitle: Text(players[index].role),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Send Report'),
                    content: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Report Content',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        // Store report content
                      },
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          sendReport(players[index].id, 'Report content');
                          Navigator.pop(context);
                        },
                        child: const Text('Send'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
