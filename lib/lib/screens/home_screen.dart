import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> _scareLevels = const [
    'Mildly Haunted',
    'Zombies Ahead',
    'Absolute Terror',
  ];

  @override
  Widget build(BuildContext context) {
    const selectedLevel = 'Mildly Haunted';
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const AppHeader(
        title: 'Spooky Find',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            ScareLevelDropdown(
              selectedValue: selectedLevel,
              items: _scareLevels,
            ),
            const SizedBox(height: 40),
            const SpookyMap(), 
            const SizedBox(height: 24),
            // 3. Camera & Gallery Action Row (Lesson A Placeholders)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/icons/home/camera_icon.svg',
                    colorFilter: ColorFilter.mode(
                      colorScheme.secondary, // The color token
                      BlendMode.srcIn,       // Replaces all colored vector paths with the token color
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/icons/home/gallery_icon.svg',
                  colorFilter: ColorFilter.mode(
                      colorScheme.secondary, // The color token
                      BlendMode.srcIn,       // Replaces all colored vector paths with the token color
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}