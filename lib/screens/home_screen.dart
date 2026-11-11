import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/widgets.dart';
import '../view_models/attractions_view_model.dart';
import '../view_models/location_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _scareLevels = const [
    'Mildly Haunted',
    'Zombies Ahead',
    'Absolute Terror',
  ];
 // In order from mildest to scariest: the first item is scare level 1
// Created once, when the screen first appears, and kept between rebuilds
  final AttractionsViewModel _viewModel = AttractionsViewModel();
  final LocationViewModel _locationViewModel = LocationViewModel();

  @override
  void initState() {
    super.initState();
    // No await: the screen draws right away, and the pins appear when the haunts arrive
    _viewModel.loadAttractions();
    _locationViewModel.findUser(); // Runs at the same time as loading the haunts
  }

  @override
  void dispose() {
    _viewModel.dispose(); // The screen is gone, so stop listening for changes
    _locationViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const AppHeader(
        title: 'Spooky Find',
      ),
      // Rebuilds everything inside whenever the ViewModel calls notifyListeners()
      body: ListenableBuilder(
        listenable: Listenable.merge([_viewModel, _locationViewModel]),
        builder: (context, child) {
          final visible = _viewModel.visibleAttractions;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                 ScareLevelDropdown(
                  selectedValue: _scareLevels[_viewModel.maxScareLevel - 1],
                  items: _scareLevels,
                  onChanged: (String label) {
                    // 'Mildly Haunted' is item 0, so it's scare level 1
                    _viewModel.setMaxScareLevel(_scareLevels.indexOf(label) + 1);
                  },
                ),
                const SizedBox(height: 40),
                                if (_viewModel.isLoading)
                  const LinearProgressIndicator()
                else if (_viewModel.errorMessage != null)
                  Text(
                    _viewModel.errorMessage!,
                    style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                  )
                else
                  Text(
                    'Showing ${visible.length} of ${_viewModel.attractions.length} haunts',
                    style: textTheme.bodyMedium,
                  ),
                   if (_locationViewModel.isLocating)
                  Text('Finding your location…', style: textTheme.bodySmall)
                else if (_locationViewModel.problem != null)
                  Text(
                    'Showing home base: ${_locationViewModel.problem}',
                    style: textTheme.bodySmall,
                  ),
                const SizedBox(height: 16),
                SpookyMap(
                  attractions: visible,
                  userLocation: _locationViewModel.userLocation,
                ),
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
          );
        }
      ),
    );
  }
}