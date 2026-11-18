import 'dart:typed_data';

// One photo taken with the app's camera.
class Photo {
  final DateTime takenAt; // When the shutter was pressed
  final Uint8List bytes; // The picture itself: a JPEG, as a list of numbers

  const Photo({
    required this.takenAt,
    required this.bytes,
  });

  @override
  String toString() => 'Photo taken $takenAt (${bytes.length} bytes)';
}