import 'package:flutter/foundation.dart';

import '../data/attraction_repository.dart';
import '../models/attraction.dart';

// Holds what the screen needs to show, and tells the screen when it changes.
class AttractionsViewModel extends ChangeNotifier {
  final AttractionRepository _repository = AttractionRepository();

  List<Attraction> _attractions = [];
  bool _isLoading = false;
  String? _errorMessage;

  // The View can read these, but only the ViewModel can change them
  List<Attraction> get attractions => List.unmodifiable(_attractions);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadAttractions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // "Something changed: redraw!"

    try {
      _attractions = await _repository.loadAttractions();
    } catch (error) {
      _errorMessage = 'Could not load the haunts: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}