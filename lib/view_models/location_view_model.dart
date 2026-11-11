import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import '../data/location_service.dart';

// Remembers where the user is (if we're allowed to know) and tells the screen when that changes.
class LocationViewModel extends ChangeNotifier {
  final LocationService _service = LocationService();

  LatLng? _userLocation; // null until we know where the user is
  bool _isLocating = false;
  String? _problem; // Why we couldn't find the user, if we couldn't

  LatLng? get userLocation => _userLocation;
  bool get isLocating => _isLocating;
  String? get problem => _problem;

  Future<void> findUser() async {
    _isLocating = true;
    _problem = null;
    notifyListeners();

    try {
      _userLocation = await _service.getCurrentLocation();
    } on LocationException catch (error) {
      _problem = error.message; // We know exactly what went wrong
    } catch (error) {
      _problem = "couldn't get a location fix"; // Timed out, or something unexpected
    } finally {
      _isLocating = false;
      notifyListeners();
    }
  }
}