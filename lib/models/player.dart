class Player {
  final int id;
  final String name;
  final String role;

  Player({required this.id, required this.name, required this.role});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      role: json['role'],
    );
  }
}
