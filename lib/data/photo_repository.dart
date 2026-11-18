import 'dart:typed_data';

import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../models/photo.dart';

// Knows WHERE the photos are kept and HOW to read and save them.
// Hive keeps them in the app's own storage: a folder on a phone, the browser's storage in Chrome.
// This is the only file in the app that uses Hive.
class PhotoRepository {
  static const String _boxName = 'ghost_photos';

  Box<Uint8List>? _box; // null until the first time we need it

  // Opens the storage the first time, then reuses it
  Future<Box<Uint8List>> _openBox() async {
    if (_box == null) {
      await Hive.initFlutter();
      _box = await Hive.openBox<Uint8List>(_boxName);
    }
    return _box!;
  }

  // Every saved photo, newest first
  Future<List<Photo>> loadPhotos() async {
    final Box<Uint8List> box = await _openBox();

    // Each photo is saved under its time, so the key tells us when it was taken
    final List<Photo> photos = box.keys.map((key) {
      return Photo(
        takenAt: DateTime.fromMillisecondsSinceEpoch(int.parse(key as String)),
        bytes: box.get(key)!,
      );
    }).toList();

    photos.sort((a, b) => b.takenAt.compareTo(a.takenAt)); // Newest first
    return photos;
  }

  // Saves one photo and returns it
  Future<Photo> savePhoto(Uint8List bytes) async {
    final Box<Uint8List> box = await _openBox();
    final DateTime now = DateTime.now();

    // The key is the time in milliseconds, like '1762300000000'
    await box.put(now.millisecondsSinceEpoch.toString(), bytes);
    return Photo(takenAt: now, bytes: bytes);
  }
}