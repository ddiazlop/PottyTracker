import 'package:flutter/foundation.dart';
import '../models/walk_event.dart';
import '../services/api_service.dart';

class WalkEventProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<WalkEvent> _walkEvents = [];
  bool _isLoading = false;

  List<WalkEvent> get walkEvents => _walkEvents;
  bool get isLoading => _isLoading;

  Future<void> loadWalkEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      _walkEvents = await _apiService.getWalkEvents();
    } catch (e) {
      // Handle error
      debugPrint('Error loading walk events: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addWalkEvent(WalkEvent walkEvent) async {
    try {
      final newEvent = await _apiService.createWalkEvent(walkEvent);
      _walkEvents.insert(0, newEvent);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding walk event: $e');
      rethrow;
    }
  }

  Future<void> updateWalkEvent(String id, WalkEvent updatedEvent) async {
    try {
      final event = await _apiService.updateWalkEvent(id, updatedEvent);
      final index = _walkEvents.indexWhere((e) => e.id == id);
      if (index != -1) {
        _walkEvents[index] = event;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating walk event: $e');
      rethrow;
    }
  }

  Future<void> deleteWalkEvent(String id) async {
    try {
      await _apiService.deleteWalkEvent(id);
      _walkEvents.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting walk event: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getStats() async {
    try {
      return await _apiService.getStats();
    } catch (e) {
      debugPrint('Error getting stats: $e');
      rethrow;
    }
  }
}