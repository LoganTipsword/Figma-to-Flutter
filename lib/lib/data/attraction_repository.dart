import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:spooky_find/models/attraction.dart';

// Knows WHERE the haunts are stored and HOW to read them.
// Nothing else in the app needs to know the data comes from a JSON file.
class AttractionRepository {
  static const String _path = 'assets/data/attractions.json';

  Future<List<Attraction>> loadAttractions() async {
    // Reading a file takes time, so wait for it without freezing the app
    final String text = await rootBundle.loadString(_path);

    // Text → a List of Maps → a List of Attractions
    final List<dynamic> items = jsonDecode(text);
    return items
        .map((item) => Attraction.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}