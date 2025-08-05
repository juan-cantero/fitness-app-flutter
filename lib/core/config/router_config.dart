import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/exercises/presentation/screens/exercises_screen.dart';
import '../../features/workouts/presentation/screens/workouts_screen.dart';
import '../../features/workouts/presentation/screens/create_workout_screen.dart';
import '../../features/workouts/presentation/screens/workout_detail_screen.dart';
import '../../features/exercises/presentation/screens/exercise_detail_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/debug/presentation/screens/database_debug_screen.dart';
import '../../shared/widgets/main_navigation.dart';
import '../../shared/widgets/splash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppConstants.homeRoute,
    routes: [
      // Splash screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Auth routes
      GoRoute(
        path: AppConstants.loginRoute,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppConstants.registerRoute,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Main app shell with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigation(child: child);
        },
        routes: [
          // Home/Workouts
          GoRoute(
            path: AppConstants.homeRoute,
            name: 'home',
            builder: (context, state) => const WorkoutsScreen(),
          ),
          
          // Exercises
          GoRoute(
            path: AppConstants.exercisesRoute,
            name: 'exercises',
            builder: (context, state) => const ExercisesScreen(),
          ),
          
          // Profile
          GoRoute(
            path: AppConstants.profileRoute,
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      
      // Detail routes (outside of shell to allow full-screen)
      GoRoute(
        path: AppConstants.workoutDetailRoute,
        name: 'workout-detail',
        builder: (context, state) {
          final workoutId = state.pathParameters['id']!;
          return WorkoutDetailScreen(workoutId: workoutId);
        },
      ),
      GoRoute(
        path: AppConstants.exerciseDetailRoute,
        name: 'exercise-detail',
        builder: (context, state) {
          final exerciseId = state.pathParameters['id']!;
          return ExerciseDetailScreen(exerciseId: exerciseId);
        },
      ),
      
      // Create workout (full-screen)
      GoRoute(
        path: AppConstants.createWorkoutRoute,
        name: 'create-workout',
        builder: (context, state) => const CreateWorkoutScreen(),
      ),
      
      // Debug routes (development only)
      GoRoute(
        path: '/debug/database',
        name: 'debug-database',
        builder: (context, state) => const DatabaseDebugScreen(),
      ),
    ],
    
    // Redirect logic for authentication
    redirect: (context, state) {
      // This will be implemented with proper auth state checking
      // For now, allow all routes
      return null;
    },
    
    // Error handling
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.error?.toString() ?? 'Unknown error',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppConstants.homeRoute),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});

// Route extensions for easy navigation
extension GoRouterExtensions on GoRouter {
  void pushWorkoutDetail(String workoutId) {
    push('/workout/$workoutId');
  }
  
  void pushExerciseDetail(String exerciseId) {
    push('/exercise/$exerciseId');
  }
  
  void pushCreateWorkout() {
    push(AppConstants.createWorkoutRoute);
  }
  
  void goToLogin() {
    go(AppConstants.loginRoute);
  }
  
  void goToRegister() {
    go(AppConstants.registerRoute);
  }
  
  void goToHome() {
    go(AppConstants.homeRoute);
  }
}