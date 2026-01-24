import 'dart:convert';
import 'dart:io';
import 'package:serverpod/serverpod.dart';
import 'package:http/http.dart' as http;

class AiService {
  static const _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  Future<List<dynamic>> generatePrompts({
    required Session session,
    required String startAddress,
    required String endAddress,
    required String personality,
    required String personalityDescription,
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

You are acting as $personality . Description: $personalityDescription

TASKS:
1. Determine the 'Departure Clock Time'. 
2. For every stop, you MUST first calculate the "Clock Time" (e.g., 12:30 PM) and then convert that to "Minutes from Departure" based on the Start Time provided.
3. Lunch Window: Default 11:00 AM - 1:00 PM.
4. Dinner Window (optional): Default 4:00 PM - 7:00 PM.
5. Look for roadside attractions, viewpoints, and quick stops on the route.
6. Create 5-10 total time slices, time slices can overlap.

STRICT QUERY FORMATTING:
- No city/state names.
- Use | for multiple intents.
- Minimum slice duration: 120 minutes.
- Do not stop for the first 60 minutes of the trip.

STRICT JSON FORMAT:
Every object in the array must follow this structure to ensure mathematical accuracy:
{
  "calculation_logic": "Show your math: [Target Clock Time] minus [Start Clock Time] = X minutes",
  "timeSliceStartMinutes": 0,
  "timeSliceEndMinutes": 0,
  "googleSearchQuery": "..."
}

<example>
  <user_input>
    Trip: Chicago, IL to St. Louis, MO. 
    Start: 08:30 (0 mins). Total Duration: 360 mins. 
    Preferences: Coffee lover, artisan bakeries, vegetarian
    Personality: The Efficient
  </user_input>
  <ideal_output>
    [
      {
        "label": "Morning Coffee & Pastry",
        "calculationLogic": "Targeting 90 minutes after start for a break. 08:30 AM + 90 mins = 10:00 AM.",
        "timeSliceStartMinutes": 60,
        "timeSliceEndMinutes": 180,
        "googleSearchQuery": "artisan bakery | coffee shop | independent bookstore"
      },
      {
        "label": "Vegetarian Lunch",
        "calculationLogic": "12:30 PM is 4 hours after 08:30 AM start. 4 * 60 = 240 minutes.",
        "timeSliceStartMinutes": 180,
        "timeSliceEndMinutes": 270,
        "googleSearchQuery": "vegetarian friendly cafe | quick vegetarian lunch"
      },
      {
        "label": "Scenic/Quick Stop",
        "calculationLogic": "Mid-afternoon stretch. 12:30 PM lunch + 2 hours = 2:30 PM. 08:30 to 2:30 is 6 hours (360 mins).",
        "timeSliceStartMinutes": 270,
        "timeSliceEndMinutes": 360,
        "googleSearchQuery": "roadside attraction | roadside art installation"
      },
      {
        "label": "General Travel Stops",
        "calculationLogic": "Standard window from 1 hour in (60 mins) to 1 hour before arrival (300 mins).",
        "timeSliceStartMinutes": 60,
        "timeSliceEndMinutes": 300,
        "googleSearchQuery": "scenic overlook | clean rest area"
      }
    ]
  </ideal_output>
</example>
""";
    
    // Define generationConfig as a Map so you can add missing parameters
    final generationConfig = {
      'responseMimeType': 'application/json',
      'responseSchema': {
        'type': 'ARRAY',
        'items': {
          'type': 'OBJECT',
          'properties': {
            'calculationLogic': {'type': 'STRING'},
            'timeSliceStartMinutes': {'type': 'NUMBER'},
            'timeSliceEndMinutes': {'type': 'NUMBER'},
            'googleSearchQuery': {'type': 'STRING', 'description': 'Chapter name, e.g., "The Morning Brew"'},
          },
          'required': ['timeSliceStartMinutes', 'timeSliceEndMinutes', 'googleSearchQuery'],
        },
      },
      // Example: Add your missing parameter here
      // 'thinking_config': {'include_thoughts': true, 'budget_token_count': 1024},
    };

    final url = Uri.parse('$_baseUrl?key=$apiKey');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'systemInstruction': {
          'parts': [{'text': systemInstruction}]
        },
        'generationConfig': generationConfig,
        'contents': [{
          'parts': [{'text': """
      Trip duration: $totalDurationMinutes
      Start: $startAddress
      End: $endAddress
      User notes: $preferences
      Plan the search windows.
      """}]
        }]
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gemini API Error: ${response.statusCode} ${response.body}');
    }

    final jsonResponse = jsonDecode(response.body);
    final text = jsonResponse['candidates']?[0]?['content']?['parts']?[0]?['text'];

    if (text == null) {
      throw Exception('Gemini returned empty response');
    }
    print(text);

    return jsonDecode(text);
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

    final generationConfig = {
      'responseMimeType': 'application/json',
      'responseSchema': {
        'type': 'ARRAY',
        'items': {
          'type': 'OBJECT',
          'properties': {
            'slotTitle': {'type': 'STRING', 'description': 'Chapter name, e.g., "The Morning Brew"'},
            'name': {'type': 'STRING', 'description': 'Place name'},
            'address': {'type': 'STRING'},
            'latitude': {'type': 'NUMBER'},
            'longitude': {'type': 'NUMBER'},
            'category': {'type': 'STRING'},
            'butlerNote': {'type': 'STRING', 'description': 'Why the butler picked this based on $personality and the user notes'},
            'priceLevel': {'type': 'STRING', 'enum': ['low', 'medium', 'high'], 'description': 'Cost of venue'},
            'detourTimeMinutes': {'type': 'NUMBER', 'description': "The detour time in minutes"},
          },
          'required': ['slotTitle', 'name', 'latitude', 'longitude', 'butlerNote', 'priceLevel', 'detourTimeMinutes'],
        },
      },
      // Add your custom parameters here
    };

    final url = Uri.parse('$_baseUrl?key=$apiKey');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'systemInstruction': {
          'parts': [{'text': systemInstruction}]
        },
        'generationConfig': generationConfig,
        'contents': [{
          'parts': [{'text': jsonEncode(candidateStops)}]
        }]
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Gemini API Error: ${response.statusCode} ${response.body}');
    }

    final jsonResponse = jsonDecode(response.body);
    final text = jsonResponse['candidates']?[0]?['content']?['parts']?[0]?['text'];

    if (text == null) {
      throw Exception('Gemini returned empty response');
    }

    return jsonDecode(text);
  }
}