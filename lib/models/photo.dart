import 'dart:typed_data';

// One photo taken with the app's camera.
class Photo {
  final DateTime takenAt; // When the shutter was pressed
  final Uint8List bytes; // The picture itself: a JPEG, as a list of numbers

  const Photo({
    required this.takenAt,
    required this.bytes,
  });

 // "Photo taken 11/15/2026 7:05 PM": the words a screen reader says for this photo
  String get description {
    final int hour = takenAt.hour % 12 == 0 ? 12 : takenAt.hour % 12;
    final String minute = takenAt.minute.toString().padLeft(2, '0');
    final String amPm = takenAt.hour < 12 ? 'AM' : 'PM';
    return 'Photo taken ${takenAt.month}/${takenAt.day}/${takenAt.year} $hour:$minute $amPm';
  }

  @override
  String toString() => 'Photo taken $takenAt (${bytes.length} bytes)';
}