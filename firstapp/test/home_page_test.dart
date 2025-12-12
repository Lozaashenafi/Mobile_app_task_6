import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/screens/home_page.dart';
import 'package:firstapp/providers/shoe_provider.dart';

void main() {
  testWidgets('HomePage shows available products text', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (context) => ShoeProvider(),
          child: const HomePage(),
        ),
      ),
    );

    // Check for text that appears in HomePage
    expect(find.text('Available Products'), findsOneWidget);
    expect(find.text('Hello, Yohannes'), findsOneWidget);
  });

  testWidgets('HomePage shows search icon', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (context) => ShoeProvider(),
          child: const HomePage(),
        ),
      ),
    );

    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
