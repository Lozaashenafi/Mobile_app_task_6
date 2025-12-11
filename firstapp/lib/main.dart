import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/shoe_provider.dart';
import 'screens/home_page.dart';
import 'screens/add_edit_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ShoeProvider(),
      child: MaterialApp(
        title: 'Shoe E-commerce Demo',
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        routes: {'/add-edit': (ctx) => const AddEditPage()},
      ),
    );
  }
}
