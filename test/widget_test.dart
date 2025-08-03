// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app_flutter/core/config/theme_config.dart';

void main() {
  testWidgets('Theme configuration test', (WidgetTester tester) async {
    // Test that theme configuration works correctly
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeConfig.lightTheme,
        home: const Scaffold(
          body: Center(
            child: Text('Test App'),
          ),
        ),
      ),
    );

    // Verify that the app loads with correct theme
    expect(find.text('Test App'), findsOneWidget);
    
    // Verify theme colors are applied
    final theme = Theme.of(tester.element(find.text('Test App')));
    expect(theme.colorScheme.primary, ThemeConfig.primaryColor);
  });
}
