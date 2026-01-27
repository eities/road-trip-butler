import 'package:road_trip_butler_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'map_service.dart';
import 'ai_service.dart';

class TripManagerService {
  final MapService _mapService = MapService();
  final AiService _aiService = AiService();

  Future<Trip> createTrip(Session session, {
    required String startAddress,
    required String endAddress,
    required DateTime departureTime,
    required String localDepartureTime,
    required String personality,
    required String personalityDescription,
    required String preferences,
  }) async {
    // Ensure departure time is not in the past for the API call.
    // If it is, clamp it to the future so the routing API doesn't error.
    var safeDepartureTime = departureTime;
    if (safeDepartureTime.isBefore(DateTime.now().add(const Duration(minutes: 1)))) {
      safeDepartureTime = DateTime.now().add(const Duration(minutes: 5));
    }

    // 1. Fetch Route
    final routeData = await _mapService.fetchRoutePolyline(session, startAddress, endAddress, safeDepartureTime);
    
    // 2. Create Trip Entry (In Memory)
    var trip = Trip(
      description: 'Trip from $startAddress to $endAddress',
      startAddress: startAddress,
      endAddress: endAddress,
      departureTime: departureTime,
      polyline: routeData.polyline,
      preferences: preferences,
      totalDurationMinutes: routeData.durationMinutes,
      personality: personality,
    );

    // 3. Generate Time Slices via AI

    final rawTimeSlices = await _aiService.generatePrompts(
      session: session,
      startAddress: startAddress,
      endAddress: endAddress,
      personality: personality,
      personalityDescription: personalityDescription,
      preferences: preferences,
      totalDurationMinutes: routeData.durationMinutes,
      departureTime: localDepartureTime,
      routeAnchors: routeData.anchors,
    );

    // 4. Query Google maps along route for stops
    final candidateStopsUnfiltered = await _mapService.fetchStopsFromQueries(
      session,
      routeData.routePoints,
      rawTimeSlices,
    );

    final candidateStops = candidateStopsUnfiltered.where((stop) => stop['detourTimeMinutes']! < 30 ).toList();

    // 5. Curate Stops via AI
    final curatedStops = await _aiService.generateStops(
      session: session,
      personality: personality,
      preferences: preferences,
      candidateStops: candidateStops,
      departureTime: localDepartureTime,
    );

    // 6. Create Stops (In Memory)
    List<Stop> stops = [];
    int tempId = 1;
    for (var data in curatedStops) {
      stops.add(Stop(
        id: tempId++, // Assign fake ID for UI uniqueness
        tripId: 0,
        name: data['name'],
        slotTitle: data['slotTitle'],
        address: data['address'] ?? '',
        latitude: (data['latitude'] as num).toDouble(),
        longitude: (data['longitude'] as num).toDouble(),
        category: data['category'] ?? 'general',
        butlerNote: data['butlerNote'],
        status: StopStatus.untouched,
        priceLevel: PriceLevel.values.byName(data['priceLevel'] ?? 'low'),
        detourTimeMinutes: data['detourTimeMinutes'],
        rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      ));
    }

    trip.stops = stops;

    return trip;
  }
}