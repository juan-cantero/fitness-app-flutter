import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/repositories/mock/mock_repositories.dart';

/// Demo screen showing mock data when real database isn't available
class DatabaseDemoScreen extends ConsumerStatefulWidget {
  const DatabaseDemoScreen({super.key});

  @override
  ConsumerState<DatabaseDemoScreen> createState() => _DatabaseDemoScreenState();
}

class _DatabaseDemoScreenState extends ConsumerState<DatabaseDemoScreen> {
  String? selectedCategory;
  late MockExerciseRepository mockRepository;

  @override
  void initState() {
    super.initState();
    mockRepository = MockExerciseRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Demo (Mock Data)'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Row(
        children: [
          // Categories Sidebar
          Container(
            width: 250,
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.grey.shade300)),
              color: Colors.orange.withValues(alpha: 0.1),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.orange.withValues(alpha: 0.2),
                  child: const Row(
                    children: [
                      Icon(Icons.category, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Mock Data Categories',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      _buildCategoryTile('Exercises', Icons.fitness_center, 'exercises'),
                      _buildCategoryTile('Equipment', Icons.sports_gymnastics, 'equipment'),
                      _buildCategoryTile('Categories', Icons.category, 'categories'),
                      _buildCategoryTile('User Profiles', Icons.person, 'profiles'),
                      _buildCategoryTile('Workouts', Icons.assignment, 'workouts'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content Area
          Expanded(
            child: selectedCategory == null
                ? _buildWelcomeScreen()
                : _buildCategoryContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTile(String title, IconData icon, String category) {
    final isSelected = selectedCategory == category;
    
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.orange : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.orange : null,
        ),
      ),
      selected: isSelected,
      onTap: () => setState(() => selectedCategory = category),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.preview,
            size: 64,
            color: Colors.orange.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Database Demo Mode',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This demo shows mock data that represents what you\'ll see\nwhen the database is working on mobile devices',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Card(
            color: Colors.orange.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.orange.shade700),
                      const SizedBox(width: 8),
                      const Text(
                        'Expected Database Content',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildExpectedDataRow('Categories', '11 items', 'Strength, Cardio, Flexibility, etc.'),
                  _buildExpectedDataRow('Equipment', '12+ items', 'Dumbbells, Barbells, Pull-up bars, etc.'),
                  _buildExpectedDataRow('Exercises', '3-5 items', 'Push-ups, Squats, Pull-ups with metadata'),
                  _buildExpectedDataRow('User Profiles', '0 items', 'Empty until users sign up'),
                  _buildExpectedDataRow('Workouts', '0 items', 'Empty until users create workouts'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpectedDataRow(String table, String count, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              table,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              count,
              style: TextStyle(color: Colors.orange.shade700),
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryContent() {
    switch (selectedCategory) {
      case 'exercises':
        return _buildExercisesDemo();
      case 'equipment':
        return _buildEquipmentDemo();
      case 'categories':
        return _buildCategoriesDemo();
      case 'profiles':
        return _buildEmptyDemo('User Profiles', 'Users will appear here after registration');
      case 'workouts':
        return _buildEmptyDemo('Workouts', 'Workouts will appear here after users create them');
      default:
        return _buildWelcomeScreen();
    }
  }

  Widget _buildExercisesDemo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.orange.withValues(alpha: 0.1),
          child: Row(
            children: [
              Icon(Icons.fitness_center, color: Colors.orange.shade700),
              const SizedBox(width: 8),
              const Text(
                'Sample Exercises (Mock Data)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildExerciseCard('Push-ups', 'Basic bodyweight exercise for chest and arms', 
                  'Chest, Triceps', 'Beginner', 'No equipment'),
              _buildExerciseCard('Squats', 'Fundamental lower body exercise', 
                  'Quadriceps, Glutes', 'Beginner', 'No equipment'),
              _buildExerciseCard('Pull-ups', 'Upper body pulling exercise', 
                  'Back, Biceps', 'Intermediate', 'Pull-up bar'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseCard(String name, String description, String muscles, String difficulty, String equipment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(description),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoChip('Muscles', muscles, Icons.fitness_center),
                const SizedBox(width: 8),
                _buildInfoChip('Level', difficulty, Icons.signal_cellular_alt),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoChip('Equipment', equipment, Icons.sports_gymnastics),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.orange.shade700),
          const SizedBox(width: 4),
          Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 12,
              color: Colors.orange.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentDemo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.orange.withValues(alpha: 0.1),
          child: Row(
            children: [
              Icon(Icons.sports_gymnastics, color: Colors.orange.shade700),
              const SizedBox(width: 8),
              const Text(
                'Sample Equipment (Mock Data)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(16),
            children: [
              _buildEquipmentCard('Dumbbells', 'Adjustable weights', 'Medium cost'),
              _buildEquipmentCard('Barbell', 'Olympic barbell', 'High cost'),
              _buildEquipmentCard('Pull-up Bar', 'Doorway mounted', 'Low cost'),
              _buildEquipmentCard('Kettlebells', 'Cast iron weights', 'Medium cost'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEquipmentCard(String name, String description, String cost) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_gymnastics,
              size: 32,
              color: Colors.orange.shade700,
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                cost,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.orange.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesDemo() {
    final categories = [
      'Strength Training', 'Cardiovascular', 'Flexibility & Mobility',
      'Functional Training', 'Sports Specific', 'Rehabilitation',
      'Upper Body', 'Lower Body', 'Core', 'Full Body', 'HIIT'
    ];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.orange.withValues(alpha: 0.1),
          child: Row(
            children: [
              Icon(Icons.category, color: Colors.orange.shade700),
              const SizedBox(width: 8),
              const Text(
                'Exercise Categories (Mock Data)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange.withValues(alpha: 0.2),
                    child: Icon(
                      Icons.category,
                      color: Colors.orange.shade700,
                    ),
                  ),
                  title: Text(categories[index]),
                  subtitle: Text('Category ${index + 1} of ${categories.length}'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyDemo(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}