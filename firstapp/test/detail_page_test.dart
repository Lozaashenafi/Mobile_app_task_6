import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/screens/detail_page.dart';
import 'package:firstapp/providers/shoe_provider.dart';

void main() {
  testWidgets('DetailPage shows shoe details', (WidgetTester tester) async {
    // Create provider with existing shoes
    final provider = ShoeProvider();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: provider,
          child: DetailPage(shoeId: '1'), // Use ID from your hardcoded data
        ),
      ),
    );

    // Wait a bit for initial build
    await tester.pump();

    // Check for shoe name that exists in your provider
    expect(find.text('Running Shoe'), findsOneWidget);
    expect(find.text('Sports'), findsOneWidget);
  });

  testWidgets('DetailPage has update and delete buttons', (
    WidgetTester tester,
  ) async {
    final provider = ShoeProvider();

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: provider,
          child: DetailPage(shoeId: '1'),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('UPDATE'), findsOneWidget);
    expect(find.text('DELETE'), findsOneWidget);
  });
}
