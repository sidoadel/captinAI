class Coach {
  final int id;
  final String name;
  final String role;

  Coach({required this.id, required this.name, required this.role});

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      id: json['id'],
      name: json['name'],
      role: json['role'],
    );
  }
}
