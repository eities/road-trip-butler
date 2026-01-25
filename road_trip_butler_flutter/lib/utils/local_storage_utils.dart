import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:road_trip_butler_client/road_trip_butler_client.dart';

class LocalStorageService {
  static const String _boxName = 'saved_trips';
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    await Hive.initFlutter();
    await Hive.openBox<String>(_boxName);
    _isInitialized = true;
  }

  Box<String> get _box {
    if (!Hive.isBoxOpen(_boxName)) {
      throw Exception('Hive box $_boxName is not open');
    }
    return Hive.box<String>(_boxName);
  }

  Future<void> saveTrip(Trip trip) async {
    if (!_isInitialized) await init();
    
    // Use trip ID as key if available, otherwise a generated timestamp key
    final key = trip.id?.toString() ?? 'local_${DateTime.now().millisecondsSinceEpoch}';
    
    // Serialize trip to JSON using Serverpod's toJson
    final jsonMap = trip.toJson();
    final jsonString = jsonEncode(jsonMap);
    
    await _box.put(key, jsonString);
  }

  Future<List<Trip>> getSavedTrips() async {
    if (!_isInitialized) await init();
    
    final trips = <Trip>[];

    for (var jsonString in _box.values) {
      try {
        final jsonMap = jsonDecode(jsonString);
        // Deserialize using Serverpod's fromJson
        final trip = Trip.fromJson(jsonMap);
        trips.add(trip);
      } catch (e) {
        print('Error parsing saved trip: $e');
      }
    }
    
    // Sort by departure time (newest first)
    trips.sort((a, b) => b.departureTime.compareTo(a.departureTime));
    return trips;
  }

  Future<void> deleteTrip(String key) async {
    if (!_isInitialized) await init();
    await _box.delete(key);
  }
}
