import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:captinai/models/player.dart';

class ApiService {
  final String baseUrl = 'http://localhost:3000'; // Replace with your server URL

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (kDebugMode) {
        print('Login Response: ${response.statusCode} - ${response.body}');
      }

      return jsonDecode(response.body);
    } catch (e) {
      if (kDebugMode) {
        print('Error logging in: $e');
      }
      throw Exception('Error logging in: $e');
    }
  }

  Future<Map<String, dynamic>> signup(String email, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {
          'Content-Type': 'application/json',
          // Add additional headers if needed
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      if (kDebugMode) {
        print('Signup Response: ${response.statusCode} - ${response.body}');
      }

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to sign up: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error signing up: $e');
      }
      throw Exception('Error signing up: $e');
    }
  }

  Future<Map<String, dynamic>> createTeam(String teamName, List<String> members, int headCoachId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/createTeam'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'teamName': teamName,
          'members': members,
          'headCoachId': headCoachId,
        }),
      );

      if (kDebugMode) {
        print('Create Team Response: ${response.statusCode} - ${response.body}');
      }

      return jsonDecode(response.body);
    } catch (e) {
      if (kDebugMode) {
        print('Error creating team: $e');
      }
      throw Exception('Error creating team: $e');
    }
  }

  Future<Map<String, dynamic>> fetchSessions(int coachId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/fetchSessions/$coachId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (kDebugMode) {
        print('Fetch Sessions Response: ${response.statusCode} - ${response.body}');
      }

      return jsonDecode(response.body);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching sessions: $e');
      }
      throw Exception('Error fetching sessions: $e');
    }
  }

  // Add debug messages to other methods similarly...

  Future<List<Player>> fetchPlayers(int teamId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/teams/$teamId/players'),
        headers: {'Content-Type': 'application/json'},
      );

      if (kDebugMode) {
        print('Fetch Players Response: ${response.statusCode} - ${response.body}');
      }

      if (response.statusCode == 200) {
        List<dynamic> playerJsonList = jsonDecode(response.body);
        List<Player> players = playerJsonList.map((json) => Player.fromJson(json)).toList();
        return players;
      } else {
        throw Exception('Failed to fetch players: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching players: $e');
      }
      throw Exception('Error fetching players: $e');
    }
  }

  getSessionDetails(int sessionId) {}

  sendAnalysisReport(int coachId, int playerId, String content) {}


}
