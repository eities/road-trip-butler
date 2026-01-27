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
    
    // Ensure trip has an ID. If it's null, assign a unique ID based on time.
    if (trip.id == null) {
      trip.id = DateTime.now().millisecondsSinceEpoch;
    }
    
    final key = trip.id.toString();

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
