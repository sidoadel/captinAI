
// team.dart
class Team {
  final int id;
  final String name;
  final int headCoachId;
  final List<int> players;
  final List<int> sessions;

  Team({
    required this.id,
    required this.name,
    required this.headCoachId,
    required this.players,
    required this.sessions,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      headCoachId: json['headCoachId'],
      players: List<int>.from(json['players']),
      sessions: List<int>.from(json['sessions']),
    );
  }
}
