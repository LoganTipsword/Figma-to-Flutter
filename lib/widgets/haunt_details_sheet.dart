import 'package:flutter/material.dart';

import '../data/maps_link_service.dart';
import '../models/attraction.dart';

// The popup that slides up when a pin is tapped. It only draws the haunt it's given.
class HauntDetailsSheet extends StatelessWidget {
  const HauntDetailsSheet({super.key, required this.attraction});

  final Attraction attraction;

  // Words for each kind of haunt. Dart checks that every AttractionType is covered.
  String _typeLabel(AttractionType type) {
    return switch (type) {
      AttractionType.hauntedHouse => 'Haunted house',
      AttractionType.pumpkinPatch => 'Pumpkin patch',
      AttractionType.cornMaze => 'Corn maze',
    };
  }

  Future<void> _openInMaps(BuildContext context) async {
    // Grab these now: after the await, this sheet might already be closed
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final bool opened = await MapsLinkService().open(attraction);
    if (!opened) {
      navigator.pop(); // Close the sheet first, or it would hide the message
      messenger.showSnackBar(
        const SnackBar(content: Text("Couldn't open a maps app")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Only as tall as what's inside
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(attraction.name, style: textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(
              '${_typeLabel(attraction.type)} · Scare level ${attraction.scareLevel}',
              style: textTheme.titleSmall?.copyWith(color: colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(attraction.description, style: textTheme.bodyLarge),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.place, size: 20, color: colorScheme.onSurface),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(attraction.address, style: textTheme.bodyMedium),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _openInMaps(context),
              icon: const Icon(Icons.directions),
              label: const Text('Open in Maps'),
            ),
          ],
        ),
      ),
    );
  }
}