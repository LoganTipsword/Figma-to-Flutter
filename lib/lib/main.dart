import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'view_models/attractions_view_model.dart';

Future<void> main() async {
  // Lets the app read its asset files before runApp()
  WidgetsFlutterBinding.ensureInitialized();

  // TEST DRIVE (Lesson 2): load the haunts and print them to the Debug Console.
  // Lesson 3 moves this into the home screen.
  final viewModel = AttractionsViewModel();
  await viewModel.loadAttractions();
  debugPrint('👻 Loaded ${viewModel.attractions.length} haunts');
  for (final attraction in viewModel.attractions) {
    debugPrint('  • $attraction');
  }
  if (viewModel.errorMessage != null) {
    debugPrint('❌ ${viewModel.errorMessage}');
  }

  runApp(const SpookyFindApp());
}

class SpookyFindApp extends StatelessWidget {
  const SpookyFindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpookyFind',
      // debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}