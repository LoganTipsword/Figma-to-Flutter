import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/attraction.dart';

class SpookyMap extends StatelessWidget {
 const SpookyMap({super.key, this.attractions = const []});

  // The haunts to pin on the map. The home screen passes these in.
  final List<Attraction> attractions;

  // Home base: where the map starts. Replace with your school's coordinates.
  static const LatLng homeBase = LatLng(39.608858, -105.019089);
    // One icon per kind of haunt. Dart checks that every AttractionType is covered.
  IconData _iconFor(AttractionType type) {
    return switch (type) {
      AttractionType.hauntedHouse => Icons.cottage,
      AttractionType.pumpkinPatch => Icons.agriculture,
      AttractionType.cornMaze => Icons.grass,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 300,
      width: double.infinity,
      clipBehavior: Clip.antiAlias, // Clips the map tiles to the rounded corners
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          width: 1,
          color: colorScheme.outline,
        ),
      ),
      child: FlutterMap(
        options: const MapOptions(
          initialCenter: homeBase,
          initialZoom: 13,
          minZoom: 3,
          maxZoom: 18,
          interactionOptions: InteractionOptions(
            // Every gesture except rotation, so north always stays up
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.spooky_finder',
            // Inverts the tile colors when the app is in dark mode
            tileBuilder: isDark ? darkModeTileBuilder : null,
          ),
           // One pin per haunt, drawn on top of the street tiles
          MarkerLayer(
            markers: [
              for (final attraction in attractions)
                Marker(
                  point: attraction.location,
                  width: 40,
                  height: 40,
                  child: Tooltip(
                    message: attraction.name, // Shown on hover or long-press, and read by screen readers
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(width: 2, color: colorScheme.surface),
                      ),
                      child: Icon(
                        _iconFor(attraction.type),
                        color: colorScheme.onPrimary,
                        size: 22,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SimpleAttributionWidget(
            source: Text('OpenStreetMap contributors'),
          ),
        ],
      ),
    );
  }
}