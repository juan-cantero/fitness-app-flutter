import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';

class MainNavigation extends StatelessWidget {
  final Widget child;

  const MainNavigation({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_gymnastics),
            label: 'Exercises',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: _shouldShowFAB(context) 
          ? FloatingActionButton(
              onPressed: () => context.push(AppConstants.createWorkoutRoute),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    
    if (location.startsWith(AppConstants.exercisesRoute)) {
      return 1;
    } else if (location.startsWith(AppConstants.profileRoute)) {
      return 2;
    } else {
      return 0; // Default to workouts/home
    }
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppConstants.homeRoute);
        break;
      case 1:
        context.go(AppConstants.exercisesRoute);
        break;
      case 2:
        context.go(AppConstants.profileRoute);
        break;
    }
  }

  bool _shouldShowFAB(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    // Show FAB on home/workouts screen
    return location == AppConstants.homeRoute;
  }
}