import 'package:road_trip_butler_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:dartantic_ai/dartantic_ai.dart';

class TripEndpoint extends Endpoint {

  Future<Trip> createTrip(Session session, {
    required String startAddress,
    required String endAddress,
    required DateTime departureTime,
    required String personality,
    required String preferences
  }) async {
    //await Trip.db.insertRow(session, trip);

    final trip = Trip(
      description: 'Mock Trip Description',
      startAddress: startAddress,
      endAddress: endAddress,
      departureTime: departureTime,
      polyline: 'mock_polyline_string',
      preferences: preferences,
      totalDurationSeconds: 3600,
    );

    return trip;
  }

  // Future<> updateStopStatus(Session session, {
  //   required int stopId,
  //   required StopStatus status
  // }) async {

  // }

  // Future<> getTripDetails(Session session, int tripId) async {

  // }

  // Future<> getFinalItinerary(Session session, int tripId) async {

  // }
}

