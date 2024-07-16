import 'package:captinai/screens/head_coach_screen.dart';
import 'package:flutter/material.dart';
import 'package:captinai/user_roles.dart';
import 'package:captinai/screens/coach_screen.dart'; // Import screens for different roles
import 'package:captinai/screens/player_screen.dart';
import 'package:captinai/screens/youth_academy_coach_screen.dart';
import 'package:captinai/screens/youth_player_screen.dart';

class HomeScreen extends StatelessWidget {
  final String role;

  const HomeScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home - $role'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to CaptainAI!'),
            const SizedBox(height: 20),
            if (role == UserRoles.headCoach) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HeadCoachScreen(),
                    ),
                  );
                },
                child: const Text('Go to Head Coach Page'),
              ),
            ],
            if (role == UserRoles.coach) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CoachScreen(),
                    ),
                  );
                },
                child: const Text('Go to Coach Page'),
              ),
            ],
            if (role == UserRoles.youthAcademyCoach) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const YouthAcademyCoachScreen(),
                    ),
                  );
                },
                child: const Text('Go to Youth Academy Coach Page'),
              ),
            ],
            if (role == UserRoles.player) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlayerScreen(),
                    ),
                  );
                },
                child: const Text('Go to Player Page'),
              ),
            ],
            if (role == UserRoles.youthPlayer) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const YouthPlayerScreen(),
                    ),
                  );
                },
                child: const Text('Go to Youth Player Page'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
