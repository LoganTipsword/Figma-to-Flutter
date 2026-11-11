import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

// Thrown when we can't get the user's location. The message says why.
class LocationException implements Exception {
  final String message;
  const LocationException(this.message);

  @override
  String toString() => message;
}

// Knows HOW to ask the device (phone, emulator, or browser) where it is.
// This is the only file in the app that uses the geolocator package.
class LocationService {
  Future<LatLng> getCurrentLocation() async {
    // 1. Is location turned on at all?
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const LocationException('location is turned off on this device');
    }

    // 2. Do we have permission? If we haven't asked yet, ask now.
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission(); // Shows the "Allow?" pop-up
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const LocationException('location permission was denied');
    }

    // 3. Ask for the position, but don't wait forever
    final Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        timeLimit: Duration(seconds: 10),
      ),
    );
    return LatLng(position.latitude, position.longitude);
  }
}