import 'package:latlong2/latlong.dart';

// The kinds of haunt the app knows about. Lesson 3 picks a pin icon for each one.
enum AttractionType { hauntedHouse, pumpkinPatch, cornMaze }

class Attraction {
  final String id;
  final String name;
  final AttractionType type;
  final int scareLevel; // 1 = mild, 2 = medium, 3 = terrifying
  final LatLng location;
  final String address;
  final String description;

  const Attraction({
    required this.id,
    required this.name,
    required this.type,
    required this.scareLevel,
    required this.location,
    required this.address,
    required this.description,
  });

  // Builds an Attraction from one { ... } object in attractions.json
  factory Attraction.fromJson(Map<String, dynamic> json) {
    return Attraction(
      id: json['id'] as String,
      name: json['name'] as String,
      type: AttractionType.values.byName(json['type'] as String),
      scareLevel: json['scareLevel'] as int,
      // JSON numbers can arrive as int (40) or double (40.5), so convert to double
      location: LatLng(
        (json['latitude'] as num).toDouble(),
        (json['longitude'] as num).toDouble(),
      ),
      address: json['address'] as String,
      description: json['description'] as String,
    );
  }

  @override
  String toString() => '$name (${type.name}, scare level $scareLevel)';
}