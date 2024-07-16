// session.dart

import 'package:captinai/models/player.dart';

class Session {
  final int id;
  final String date;
  final String time;
  final List<Player> players; // Assuming Player model is already defined

  Session({
    required this.id,
    required this.date,
    required this.time,
    required this.players,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    // Convert JSON data to Session object
    List<Player> playersList = (json['players'] as List)
        .map((playerJson) => Player.fromJson(playerJson))
        .toList();
    
    return Session(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      players: playersList,
    );
  }
}
