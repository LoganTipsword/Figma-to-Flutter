import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/attraction.dart';

// Knows HOW to open a haunt in the device's maps app.
// No API key needed: these are ordinary web links that maps apps know how to open.
class MapsLinkService {
  // Apple Maps on iPhone and iPad, Google Maps everywhere else
  Uri linkFor(Attraction attraction) {
    final double lat = attraction.location.latitude;
    final double lng = attraction.location.longitude;

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // ll = where to drop the pin, q = the label on the pin
      return Uri.https('maps.apple.com', '/', {
        'll': '$lat,$lng',
        'q': attraction.name,
      });
    }
    return Uri.https('www.google.com', '/maps/search/', {
      'api': '1', // Part of Google's free link format, not a key
      'query': '$lat,$lng',
    });
  }

  // Returns true if a maps app (or browser tab) opened
  Future<bool> open(Attraction attraction) async {
    try {
      return await launchUrl(
        linkFor(attraction),
        mode: LaunchMode.externalApplication, // Open the maps app, not a page inside ours
      );
    } catch (error) {
      return false;
    }
  }
}