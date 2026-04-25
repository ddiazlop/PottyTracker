import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/walk_event.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:4000'; // Change for production

  Future<List<WalkEvent>> getWalkEvents() async {
    final response = await http.get(Uri.parse('$baseUrl/api/walk_events'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List)
          .map((json) => WalkEvent.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load walk events');
    }
  }

  Future<WalkEvent> createWalkEvent(WalkEvent walkEvent) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/walk_events'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'walk_event': walkEvent.toJson()}),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return WalkEvent.fromJson(data['data']);
    } else {
      throw Exception('Failed to create walk event');
    }
  }

  Future<WalkEvent> updateWalkEvent(String id, WalkEvent walkEvent) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/walk_events/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'walk_event': walkEvent.toJson()}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WalkEvent.fromJson(data['data']);
    } else {
      throw Exception('Failed to update walk event');
    }
  }

  Future<void> deleteWalkEvent(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/walk_events/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete walk event');
    }
  }

  Future<Map<String, dynamic>> getStats() async {
    final response = await http.get(Uri.parse('$baseUrl/api/walk_events/stats'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load stats');
    }
  }
}