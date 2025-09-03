import 'package:flutter/material.dart';
import 'features/workout/create_workout_screen.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Navigation',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Test Navigation'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CreateWorkoutScreen(),
                ),
              );
            },
            child: const Text('Navigate to Create Workout'),
          ),
        ),
      ),
    );
  }
}
