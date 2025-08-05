import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_manager.dart';
import '../../../../core/database/web_database_manager.dart';

class DatabaseDebugScreen extends ConsumerStatefulWidget {
  const DatabaseDebugScreen({super.key});

  @override
  ConsumerState<DatabaseDebugScreen> createState() => _DatabaseDebugScreenState();
}

class _DatabaseDebugScreenState extends ConsumerState<DatabaseDebugScreen> {
  String? selectedTable;
  List<Map<String, dynamic>> tableData = [];
  Map<String, int> tableCounts = {};
  bool isLoading = false;

  final List<String> availableTables = [
    'users',
    'user_profiles', 
    'categories',
    'equipment',
    'user_equipment',
    'exercises',
    'exercise_categories',
    'workouts',
    'workout_exercises',
    'workout_sessions',
    'exercise_logs',
    'favorites',
    'workout_shares',
    'workout_comments',
    'workout_ratings',
    'user_progress',
    'personal_records',
    'sync_status',
    'sync_conflicts',
  ];

  @override
  void initState() {
    super.initState();
    _loadTableCounts();
  }

  Future<void> _loadTableCounts() async {
    setState(() => isLoading = true);
    
    Map<String, int> counts = {};
    
    if (kIsWeb) {
      // Use web-compatible database manager
      final webDb = WebDatabaseManager();
      await webDb.initialize();
      
      for (final table in availableTables) {
        try {
          counts[table] = await webDb.getCount(table);
        } catch (e) {
          counts[table] = -1; // Error indicator
        }
      }
    } else {
      // Use SQLite for mobile/desktop
      try {
        final dbManager = DatabaseManager();
        final db = await dbManager.database;
        
        for (final table in availableTables) {
          try {
            final result = await db.rawQuery('SELECT COUNT(*) as count FROM $table');
            counts[table] = result.first['count'] as int;
          } catch (e) {
            counts[table] = -1; // Error indicator
          }
        }
      } catch (e) {
        // If SQLite fails, set all to error state
        for (final table in availableTables) {
          counts[table] = -1;
        }
      }
    }
    
    setState(() {
      tableCounts = counts;
      isLoading = false;
    });
  }

  Future<void> _loadTableData(String tableName) async {
    setState(() {
      selectedTable = tableName;
      isLoading = true;
      tableData = [];
    });
    
    try {
      List<Map<String, dynamic>> result;
      
      if (kIsWeb) {
        // Use web-compatible database manager
        final webDb = WebDatabaseManager();
        await webDb.initialize();
        result = await webDb.query(tableName, limit: 50);
      } else {
        // Use SQLite for mobile/desktop
        final dbManager = DatabaseManager();
        final db = await dbManager.database;
        result = await db.query(tableName, limit: 50);
      }
      
      setState(() {
        tableData = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        tableData = [];
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading $tableName: $e')),
        );
      }
    }
  }

  Future<void> _initializeDatabase() async {
    setState(() => isLoading = true);
    
    try {
      int count = 0;
      
      if (kIsWeb) {
        // Initialize web database
        final webDb = WebDatabaseManager();
        await webDb.initialize();
        count = await webDb.getCount('categories');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Web database initialized! Found $count categories in seed data.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Initialize SQLite database
        final dbManager = DatabaseManager();
        final db = await dbManager.database;
        
        // Verify initialization by checking a key table
        final categoryCount = await db.rawQuery('SELECT COUNT(*) as count FROM categories');
        count = categoryCount.first['count'] as int;
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('SQLite database initialized! Found $count categories in seed data.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
      
      await _loadTableCounts();
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Database initialization failed: $e';
        
        // Provide helpful error messages for common issues
        if (e.toString().contains('libsqlite3.so')) {
          errorMessage = 'SQLite3 library not found on this system.\n'
              'For testing on desktop, install: sudo apt-get install libsqlite3-dev\n'
              'The app will work normally on mobile devices.';
        } else if (e.toString().contains('databaseFactory not initialized')) {
          errorMessage = 'Database factory not initialized.\n'
              'This usually happens on desktop platforms.\n'
              'The app will work normally on mobile devices.';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 6),
          ),
        );
      }
    }
    
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Debug'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTableCounts,
          ),
          IconButton(
            icon: const Icon(Icons.storage),
            onPressed: _initializeDatabase,
          ),
        ],
      ),
      body: Row(
        children: [
          // Table List Sidebar
          Container(
            width: 250,
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  child: Row(
                    children: [
                      const Icon(Icons.table_chart),
                      const SizedBox(width: 8),
                      const Text(
                        'Tables',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      if (isLoading) 
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: availableTables.length,
                    itemBuilder: (context, index) {
                      final table = availableTables[index];
                      final count = tableCounts[table];
                      final isSelected = selectedTable == table;
                      
                      return ListTile(
                        title: Text(
                          table,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Theme.of(context).primaryColor : null,
                          ),
                        ),
                        subtitle: count != null
                            ? Text(
                                count == -1 ? 'Error' : '$count rows',
                                style: TextStyle(
                                  color: count == -1 ? Colors.red : Colors.grey.shade600,
                                ),
                              )
                            : null,
                        trailing: count != null && count > 0
                            ? Icon(
                                Icons.data_array,
                                color: Colors.green.shade600,
                                size: 16,
                              )
                            : count == 0
                                ? Icon(
                                    Icons.inbox,
                                    color: Colors.grey.shade400,
                                    size: 16,
                                  )
                                : count == -1
                                    ? Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: 16,
                                      )
                                    : null,
                        selected: isSelected,
                        onTap: count != null && count > 0
                            ? () => _loadTableData(table)
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Data Display Area
          Expanded(
            child: selectedTable == null
                ? _buildWelcomeScreen()
                : _buildTableDataView(),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    final totalRecords = tableCounts.values
        .where((count) => count > 0)
        .fold(0, (sum, count) => sum + count);
    
    final tablesWithData = tableCounts.entries
        .where((entry) => entry.value > 0)
        .length;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.storage,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Database Debug Console',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            totalRecords == 0 
                ? 'Click the storage icon (🗄️) above to initialize database with seed data'
                : 'Select a table from the sidebar to view its data',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bar_chart, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      const Text(
                        'Database Statistics',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildStatCard('Tables', '${availableTables.length}', Icons.table_chart),
                      const SizedBox(width: 16),
                      _buildStatCard('With Data', '$tablesWithData', Icons.data_array),
                      const SizedBox(width: 16),
                      _buildStatCard('Total Records', '$totalRecords', Icons.storage),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableDataView() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading table data...'),
          ],
        ),
      );
    }
    
    if (tableData.isEmpty) {
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
              'No data in $selectedTable',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'This table exists but contains no records',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }
    
    final columns = tableData.first.keys.toList();
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          child: Row(
            children: [
              Icon(Icons.table_rows, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                '$selectedTable (${tableData.length} records)',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${columns.length} columns',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                columns: columns
                    .map((column) => DataColumn(
                          label: Text(
                            column,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ))
                    .toList(),
                rows: tableData
                    .map((row) => DataRow(
                          cells: columns
                              .map((column) => DataCell(
                                    Text(
                                      _formatCellValue(row[column]),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatCellValue(dynamic value) {
    if (value == null) return 'NULL';
    if (value is String) {
      if (value.length > 50) {
        return '${value.substring(0, 50)}...';
      }
      return value;
    }
    return value.toString();
  }
}