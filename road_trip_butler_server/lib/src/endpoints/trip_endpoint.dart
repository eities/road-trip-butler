import 'package:road_trip_butler_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:dartantic_ai/dartantic_ai.dart';
import 'package:dartantic_chat/dartantic_chat.dart';


class TripEndpoint extends Endpoint {

  Future<Trip> createTrip(Session session, {
    required String startAddress,
    required String endAddress,
    required DateTime departureTime,
    required String personality,
    required String preferences
  }) async {
    var trip = Trip(
      description: 'Trip from $startAddress to $endAddress',
      startAddress: startAddress,
      endAddress: endAddress,
      departureTime: departureTime,
      polyline: '',
      preferences: preferences,
      totalDurationSeconds: 0,
    );
    trip = await Trip.db.insertRow(session, trip);

   final geminiApiKey = session.passwords['geminiApiKey'];
  
  // 1. Initialize Dartantic with Gemini
  final agent = Agent.forProvider(
    GoogleProvider(apiKey: geminiApiKey),
    chatModelName: 'gemini-2.5-flash-lite',
  );


  // 2. Define the exact structure you want
  // We use a Map representation that matches your 'Stop' model fields
  final stopSchema = {
    "slotTitle": "String",
    "name": "String",
    "address": "String",
    "latitude": "double",
    "longitude": "double",
    "butlerNote": "String",
    "category": "String",
  };

  // 3. Call the structured generation
  final List<dynamic> rawStops = await agent.generateList(
    prompt: "Plan a trip for a $personality from $startAddress to $endAddress.",
    schema: stopSchema,
    count: 12, // 4 chapters x 3 options
  );

  // 4. Convert and Save to Database
  var stops = <Stop>[];
  for (var i = 0; i < rawStops.length; i++) {
    final data = rawStops[i];
    var stop = Stop(
      stopId: i,
      tripId: trip.id!,
      name: data['name'],
      slotTitle: data['slotTitle'],
      address: data['address'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      category: data['category'],
      butlerNote: data['butlerNote'],
      status: StopStatus.untouched,
      priceLevel: PriceLevel.medium,
      estimatedArrivalTime: DateTime.now(), // We can calculate this later
    );
    stop = await Stop.db.insertRow(session, stop);
    stops.add(stop);
  }
  trip.stops = stops;

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

Trip dummyTrip() {

   final trip = Trip(
      description: 'Mock Trip Description',
      startAddress: 'Austin, TX',
      endAddress: 'Dallas, TX',
      departureTime: DateTime.now(),
      polyline: 'u|~nDlfr^',
      preferences: 'None',
      totalDurationSeconds: 3600,
      stops: [
    // CHAPTER 1: The Morning Caffeine Kick
    Stop(
      stopId: 1,
      tripId: 1,
      name: "Early Bird Coffee",
      slotTitle: "☕ The Morning Caffeine Kick",
      address: "123 Java Lane, Austin, TX",
      latitude: 30.2672,
      longitude: -97.7431,
      category: "coffee",
      butlerNote: "Your Butler noticed this place has a 4.9 rating for their nitro cold brew. Perfect for the first leg!",
      priceLevel: PriceLevel.low,
      status: StopStatus.untouched,
      estimatedArrivalTime: DateTime.now().add(const Duration(hours: 2)),
    ),
    Stop(
      stopId: 2,
      tripId: 1,
      name: "Donut Palace",
      slotTitle: "☕ The Morning Caffeine Kick",
      address: "456 Sugar Rd, Round Rock, TX",
      latitude: 30.5083,
      longitude: -97.6789,
      category: "pastry",
      butlerNote: "A quick, high-energy stop right off the exit. The Butler recommends the maple long johns.",
      priceLevel: PriceLevel.low,
      status: StopStatus.untouched,
      estimatedArrivalTime: DateTime.now().add(const Duration(hours: 2, minutes: 15)),
    ),
    Stop(
      stopId: 3,
      tripId: 1,
      name: "Whole Foods Market",
      slotTitle: "☕ The Morning Caffeine Kick",
      address: "525 N Lamar Blvd, Austin, TX",
      latitude: 30.2707,
      longitude: -97.7518,
      category: "healthy",
      butlerNote: "The Butler suggests this for a clean start. Great restrooms and a wide variety of juices.",
      priceLevel: PriceLevel.medium,
      status: StopStatus.untouched,
      estimatedArrivalTime: DateTime.now().add(const Duration(hours: 2, minutes: 5)),
    ),

    // // CHAPTER 2: The Local Legend Lunch
    Stop(
      stopId: 4,
      tripId: 1,
      name: "Salt Lick BBQ",
      slotTitle: "🍖 The Local Legend Lunch",
      address: "18300 FM 1826, Driftwood, TX",
      latitude: 30.1312,
      longitude: -98.0135,
      category: "lunch",
      butlerNote: "An iconic Texas experience. It's 15 minutes off the main route, but the brisket is worth the detour.",
      priceLevel: PriceLevel.medium,
      status: StopStatus.untouched,
      estimatedArrivalTime: DateTime.now().add(const Duration(hours: 5)),
    ),
    Stop(
      stopId: 5,
      tripId: 1,
      name: "Taco Deli",
      slotTitle: "🍖 The Local Legend Lunch",
      address: "Various Locations",
      latitude: 30.26,
      longitude: -97.74,
      category: "lunch",
      butlerNote: "Fast, local, and delicious. Your Butler suggests the 'Spyglass' taco for a true Austin flavor.",
      priceLevel: PriceLevel.low,
      status: StopStatus.untouched,
      estimatedArrivalTime: DateTime.now().add(const Duration(hours: 4, minutes: 45)),
    ),
    Stop(
      stopId: 6,
      tripId: 1,
      name: "The Picnic",
      slotTitle: "🍖 The Local Legend Lunch",
      address: "1720 Barton Springs Rd",
      latitude: 30.2635,
      longitude: -97.7628,
      category: "food_trucks",
      butlerNote: "A food truck park! Great if your group can't decide on one thing. Everyone gets what they want.",
      priceLevel: PriceLevel.medium,
      status: StopStatus.untouched,
      estimatedArrivalTime: DateTime.now().add(const Duration(hours: 5, minutes: 10)),
    ),
  ],
    );
    return trip;
}