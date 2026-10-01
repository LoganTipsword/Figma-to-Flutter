import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SpookyFindApp());
}

class SpookyFindApp extends StatelessWidget {
  const SpookyFindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'SpookyFind',
      home: HomeScreen(),
    );
  }
}