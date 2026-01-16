import 'package:road_trip_butler_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import '../services/trip_manager_service.dart';

class TripEndpoint extends Endpoint {
  Future<Trip> createTrip(Session session, {
    required String startAddress,
    required String endAddress,
    required DateTime departureTime,
    required String personality,
    required String preferences,
  }) async {
    return await TripManagerService().createTrip(
      session,
      startAddress: startAddress,
      endAddress: endAddress,
      departureTime: departureTime,
      personality: personality,
      preferences: preferences,
    );
  }
}