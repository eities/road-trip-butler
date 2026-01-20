import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:serverpod/serverpod.dart';

class AiService {

  Future<List<dynamic>> generatePrompts({
    required Session session,
    required String startAddress,
    required String endAddress,
    required String personality,
    required String preferences,
    required int totalDurationMinutes,
    required List<String> routeAnchors,
  }) async {
    final apiKey = session.passwords['geminiApiKey'];
    if (apiKey == null) {
      throw Exception('Gemini API key is missing in passwords.yaml');
    }

    final systemInstruction = """
    You are the 'Road Trip Architect'. Your role is to analyze a driving route and user preferences to define optimal "Search Windows." 

TASKS:
1. Divide the total duration into 2-5 logical 'Time Slices' (e.g., 90-120 mins) based on the user's Persona. You should give the starting and ending time for each time slice.
2. For each slice, generate a specific 'googleSearchQuery'. 
3. The query should not be overly descriptive and should match the user's preferences.

STRICT QUERY FORMATTING:
- Do NOT include city names, state names, or "from/to" directions in the searchQuery.
- The location is already handled by a polyline.
- The query should only contain the type of place and the atmosphere.

CONSTRAINTS:
- Output must be STRICT JSON.
- Time must be in minutes from departure.
- Do not suggest names of places yet; only provide the search intent.
""";
    final schema = Schema.array(
      items: Schema.object(
        properties: {
          'timeSliceStartMinutes': Schema.number(),
          'timeSliceEndMinutes': Schema.number(),
          'googleSearchQuery': Schema.string(description: 'Chapter name, e.g., "The Morning Brew"'),
        },
        requiredProperties: ['timeSliceStartMinutes', 'timeSliceEndMinutes', 'googleSearchQuery'], 
      ),
    );

     final model = GenerativeModel(
      model: 'gemini-2.5-flash-lite',
      apiKey: apiKey,
      systemInstruction: Content.system(systemInstruction),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: schema,
      ),
    );

    // Generate
    final response = await model.generateContent([
      Content.text("""
      Trip duration: $totalDurationMinutes
      Start: $startAddress
      End: $endAddress
      User notes: $preferences
      Plan the search windows.
      """)
    ]);

    if (response.text == null) {
      throw Exception('Gemini returned empty response');
    }

    return jsonDecode(response.text!);
  }


  Future<List<dynamic>> generateStops({
    required Session session,
    required String personality,
    required String preferences,
    required List<Map<String, dynamic>> candidateStops,
  }) async {
    final apiKey = session.passwords['geminiApiKey'];
    if (apiKey == null) {
      throw Exception('Gemini API key is missing in passwords.yaml');
    }

    if (candidateStops.isEmpty) return [];

    final systemInstruction = """
    You are the 'Road Trip Butler', a world-class travel concierge. 
    
    INPUT DATA:
    I will provide a JSON list of 'candidateStops' found along a route, grouped by 'slotTitle'.

    YOUR TASK:
    1. Review the candidates for each 'slotTitle'.
    2. Select exactly 3 options per 'slotTitle' that best fit the '$personality' persona and user preferences: '$preferences'.
    3. If a slot has fewer than 3 candidates, return all of them.
    4. Rewrite the 'butlerNote' for each selected stop to explain why it fits the persona. Be persuasive and specific.

    OUTPUT FORMAT:
    - Return a JSON array of the selected stops.
    - Maintain the original fields: slotTitle, name, address, latitude, longitude, category, priceLevel.
    - Update 'butlerNote'.
    """;

    // The Official Schema
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
            enumValues: ['low', 'medium', 'high']
          ),
          'detourTimeMinutes': Schema.number(description: "The detour time in minutes"),
        },
        requiredProperties: ['slotTitle', 'name', 'latitude', 'longitude', 'butlerNote', 'priceLevel', 'detourTimeMinutes'],
      ),
    );

    final model = GenerativeModel(
      model: 'gemini-2.5-flash-lite',
      apiKey: apiKey,
      systemInstruction: Content.system(systemInstruction),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: schema,
      ),
    );

    // Generate
    final response = await model.generateContent([
      Content.text(jsonEncode(candidateStops))
    ]);

    if (response.text == null) {
      throw Exception('Gemini returned empty response');
    }

    return jsonDecode(response.text!);
  }
}