import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Simple smoke test', (WidgetTester tester) async {
    // Build a simple widget to test the framework works
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('Test'))),
    );

    expect(find.text('Test'), findsOneWidget);
  });
}
