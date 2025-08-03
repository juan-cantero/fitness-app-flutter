import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateWorkoutScreen extends StatelessWidget {
  const CreateWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Workout'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Create Workout Screen',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'This will be implemented by the Workout Agent',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}