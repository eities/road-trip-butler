import 'package:road_trip_butler_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:dartantic_ai/dartantic_ai.dart';
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

class TripEndpoint extends Endpoint {

  Future<String> _fetchRoutePolyline(
    Session session, 
    String startAddress, 
    String endAddress
  ) async {
    // 1. Get API Key from Serverpod passwords
    final apiKey = session.passwords['googleMapsApiKey'];
    if (apiKey == null) {
      throw Exception('Google Maps API key is missing in passwords.yaml');
    }

    // 2. Construct the URL (Uri.https handles encoding spaces/special characters)
    final url = Uri.https('maps.googleapis.com', '/maps/api/directions/json', {
      'origin': startAddress,
      'destination': endAddress,
      'key': apiKey,
      'mode': 'driving',
    });

    try {
      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Failed to connect to Google API: ${response.statusCode}');
      }

      final data = jsonDecode(response.body);

      // 3. Error Handling for Google-specific status codes
      if (data['status'] == 'ZERO_RESULTS') {
        throw Exception('No route found between "$startAddress" and "$endAddress".');
      } else if (data['status'] != 'OK') {
        throw Exception('Google Directions API error: ${data['status']} - ${data['error_message'] ?? ''}');
      }

      // 4. Extract overview_polyline
      // Routes is an array, overview_polyline is inside the first route
      final String polyline = data['routes'][0]['overview_polyline']['points'];
      
      return polyline;
    } catch (e) {
      session.log('Error fetching polyline: $e', level: LogLevel.error);
      rethrow; // Pass the error up to the caller
    }
  }



  Future<Trip> createTrip(Session session, {
    required String startAddress,
    required String endAddress,
    required DateTime departureTime,
    required String personality,
    required String preferences,
  }) async {
    // 1. Create the Trip
    // A simplified route from Austin to Dallas along the I-35 corridor
    final systemInstruction = """
    You are the 'Road Trip Butler', a world-class travel concierge. 
    Your goal is to curate a highly personalized journey between a start and end location.

    PERSONALITY GUIDELINES:
    - Adapt your 'butlerNote' to the user's chosen personality:
      - If 'The Explorer', suggest the highest value stops, even if they are a slight detour or take a little longer; 
      - if The Efficient', suggest high-value quick stops;
      - If "The Family Aide" suggest family friendly stops;
    - Be polite, insightful, and helpful.

    LOGIC RULES:
    - Chapters: Group stops into logical 'Chapters' (e.g., 'The Morning Caffeine Kick', 'The Local Legend Lunch').
    - Stay between 2 - 4 chapters, each chapter about 2 hours further along the route. Each meal time that the trip will span over will usually need a chapter. Usually 1 to 2 additional stops can occur between meal times.
    - Provide 3 distinct options per Chapter so the user has choices. Each option should have the same chapter name which is put in the slotTitle field.
    - Relevance: Only suggest stops that are reasonably near the route between the start and end points.
    - Coordinates: Ensure latitude and longitude are precise for map rendering.
    - LOGIC RULES:
    - REQUIRED QUANTITY: You must generate exactly 3 unique options for every single Chapter. 
    - TOTAL COUNT: If you have 4 chapters, the final JSON array must contain exactly 12 objects.
    - GROUPING: Every stop in a group must share the EXACT same 'slotTitle' (e.g., stops 1, 2, and 3 all have 'Morning Caffeine Kick').
    - UNIQUENESS: Each of the 3 options per chapter must be a geographically different location.
    DATA CONSTRAINTS:
    - priceLevel: Must be EXACTLY 'cheap', 'medium', or 'expensive'.
    - category: Use single-word descriptors like 'coffee', 'sightseeing', 'dining', 'park'.
    """;

    final polyline = await _fetchRoutePolyline(session, startAddress, endAddress);
    //print(polyline);
    var trip = await Trip.db.insertRow(session, Trip(
      description: 'Trip from $startAddress to $endAddress',
      startAddress: startAddress,
      endAddress: endAddress,
      departureTime: departureTime,
      polyline: polyline,
      preferences: preferences,
      totalDurationSeconds: 0,
      personality: personality,
    ));

    final apiKey = session.passwords['geminiApiKey'];

    // 2. The Official Schema (This is the most reliable way)
    final schema = Schema.array(
      items: Schema.object(
        properties: {
          'slotTitle': Schema.string(description: 'Chapter name, e.g., "The Morning Brew"'),
          'name': Schema.string(description: 'Place name'),
          'address': Schema.string(),
          'latitude': Schema.number(),
          'longitude': Schema.number(),
          'category': Schema.string(),
          'butlerNote': Schema.string(description: 'Why the butler picked this based on $personality and the user notes'),
          'priceLevel': Schema.enumString(
            description: 'Cost of venue',
            enumValues: ['low', 'medium', 'high'], // Correct Native Syntax
          ),
        },
        requiredProperties: ['slotTitle', 'name', 'latitude', 'longitude', 'butlerNote', 'priceLevel'],
      ),
    );

    final model = GenerativeModel(
      model: 'gemini-2.5-flash-lite',
      apiKey: apiKey!,
      systemInstruction: Content.system(systemInstruction),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: schema,
      ),
    );

    // 3. Generate
    final response = await model.generateContent([
      Content.text("Plan a trip from $startAddress to $endAddress for a $personality persona. User notes: $preferences")
    ]);

    // 4. Parse & Save
    final List<dynamic> rawStops = jsonDecode(response.text!);
  

    for (var data in rawStops) {
      await Stop.db.insertRow(session, Stop(
        tripId: trip.id!,
        name: data['name'],
        slotTitle: data['slotTitle'],
        address: data['address'] ?? '',
        latitude: (data['latitude'] as num).toDouble(),
        longitude: (data['longitude'] as num).toDouble(),
        category: data['category'] ?? 'general',
        butlerNote: data['butlerNote'],
        status: StopStatus.untouched,
        priceLevel: PriceLevel.values.byName(data['priceLevel'] ?? 'medium'),
        estimatedArrivalTime: departureTime, 
      ));
    }

    // 5. Final Fetch with Includes
    final finalTrip = await Trip.db.findById(
      session,
      trip.id!,
      include: Trip.include(stops: Stop.includeList()),
    );

    return finalTrip!;
  }
}