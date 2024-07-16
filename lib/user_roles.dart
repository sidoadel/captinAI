class UserRoles {
  static const headCoach = 'Head Coach (مدير فني)';
  static const coach = 'Coach (مدرب)';
  static const youthAcademyCoach = 'Youth Academy Coach (مدرب الأكاديمية)';
  static const player = 'Player (لاعب)';
  static const youthPlayer = 'Youth Player (لاعب شباب)';

  static bool isValidRole(String role) {
    return [
      headCoach,
      coach,
      youthAcademyCoach,
      player,
      youthPlayer,
    ].contains(role);
  }
}
