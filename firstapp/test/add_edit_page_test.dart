import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:firstapp/screens/add_edit_page.dart';
import 'package:firstapp/providers/shoe_provider.dart';

void main() {
  testWidgets('AddEditPage shows correct title for new product', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (context) => ShoeProvider(),
          child: const AddEditPage(),
        ),
      ),
    );

    expect(find.text('Add Product'), findsOneWidget);
  });

  testWidgets('AddEditPage has form fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (context) => ShoeProvider(),
          child: const AddEditPage(),
        ),
      ),
    );

    // Check for form field labels
    expect(find.text('Product Name'), findsOneWidget);
    expect(find.text('Category'), findsOneWidget);
  });
}
