import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/config/supabase_config.dart';

// Core providers
final supabaseProvider = Provider<SupabaseClient>((ref) {
  return SupabaseConfig.client;
});

// Auth providers
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(supabaseProvider).auth.onAuthStateChange;
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.session?.user,
    loading: () => null,
    error: (error, stack) => null,
  );
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

// These will be implemented by our specialized agents
// For now, they're placeholders that will be expanded

// Exercise providers (to be implemented by Exercise Agent)
// final exercisesProvider = StateNotifierProvider<ExercisesNotifier, AsyncValue<List<Exercise>>>((ref) {
//   return ExercisesNotifier(ref.read(exerciseRepositoryProvider));
// });

// Workout providers (to be implemented by Workout Agent)
// final workoutsProvider = StateNotifierProvider<WorkoutsNotifier, AsyncValue<List<Workout>>>((ref) {
//   return WorkoutsNotifier(ref.read(workoutRepositoryProvider));
// });

// User profile providers (to be implemented by Profile Agent)
// final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
//   final user = ref.watch(currentUserProvider);
//   if (user == null) return null;
//   return ref.read(userProfileRepositoryProvider).getUserProfile(user.id);
// });

// App state providers
final appInitializationProvider = FutureProvider<void>((ref) async {
  // Skip Supabase initialization for local-first development
  // We'll initialize it later when we're ready for remote sync
  try {
    // For now, just initialize local database and core services
    debugPrint('App initialization: Running in local-first mode');
    
    // TODO: Initialize local database here when ready
    // final dbManager = DatabaseManager();
    // await dbManager.database;
    
    // Simulate initialization delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    debugPrint('App initialization completed successfully');
  } catch (e) {
    debugPrint('App initialization error: $e');
    // Don't rethrow - let the app continue in offline mode
  }
});

// Theme and UI providers
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  // This will be connected to shared preferences later
  return ThemeMode.system;
});

// Connectivity provider
final connectivityProvider = StreamProvider<bool>((ref) {
  // This will be implemented with connectivity_plus
  return Stream.value(true); // Placeholder
});

// Loading state providers
final globalLoadingProvider = StateProvider<bool>((ref) => false);

// Error state providers
final globalErrorProvider = StateProvider<String?>((ref) => null);