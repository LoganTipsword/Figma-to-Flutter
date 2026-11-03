import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SpookyMap extends StatelessWidget {
  const SpookyMap({super.key});

  // Home base: where the map starts. Replace with your school's coordinates.
  static const LatLng homeBase = LatLng(39.608858, -105.019089);

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
          const SimpleAttributionWidget(
            source: Text('OpenStreetMap contributors'),
          ),
        ],
      ),
    );
  }
}