import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import 'package:http/http.dart' as http;

class AiService {
  static const _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  Future<List<dynamic>> generatePrompts({
    required Session session,
    required String startAddress,
    required String endAddress,
    required String personality,
    required String personalityDescription,
    required String preferences,
    required int totalDurationMinutes,
    required String departureTime,
    required List<String> routeAnchors,
  }) async {
    final apiKey = await session.serverpod.getPassword('geminiApiKey');
    if (apiKey == null) {
      throw Exception('Gemini API key is missing in passwords.yaml');
    }

    final systemInstruction =
        """
    You are the 'Road Trip Architect'. Your role is to analyze a driving route and user preferences to define optimal "Search Windows." 

You are acting as $personality . Description: $personalityDescription

TASKS:
1. Determine the 'Departure Clock Time'. 
2. For every stop, you MUST first calculate the "Clock Time" (e.g., 12:30 PM) and then convert that to "Minutes from Departure" based on the Start Time provided.
3. Lunch Window: Default 11:00 AM - 1:00 PM.
4. Dinner Window (optional): Default 4:00 PM - 7:00 PM.
5. Look for roadside attractions, roadside viewpoints, travel stops, and quick stops on the route.
6. Create 5-8 total time slices, time slices can overlap.
7. Aim for a stop option every 2 hours.

STRICT QUERY FORMATTING:
- No city/state names.
- Use | for multiple intents.
- Minimum slice duration: 120 minutes.
- Do not stop for the first 30 minutes of the trip.

STRICT JSON FORMAT:
Every object in the array must follow this structure to ensure mathematical accuracy:
{
  "calculation_logic": "Show your math: [Target Clock Time] minus [Start Clock Time] = X minutes",
  "timeSliceStartMinutes": 0,
  "timeSliceEndMinutes": 0,
  "googleSearchQuery": "..."
}


""";
    // Define generationConfig as a Map so you can add missing parameters
    final generationConfig = {
      'responseMimeType': 'application/json',
      'thinkingConfig': {
        'includeThoughts': false, // Recommended so you can debug the math
        'thinkingBudget': 1024, // Range: 512 to 24,576
      },
      'responseSchema': {
        'type': 'ARRAY',
        'items': {
          'type': 'OBJECT',
          'properties': {
            'calculationLogic': {'type': 'STRING'},
            'timeSliceStartMinutes': {'type': 'NUMBER'},
            'timeSliceEndMinutes': {'type': 'NUMBER'},
            'googleSearchQuery': {
              'type': 'STRING',
              'description': 'Chapter name, e.g., "The Morning Brew"',
            },
          },
          'required': [
            'timeSliceStartMinutes',
            'timeSliceEndMinutes',
            'googleSearchQuery',
          ],
        },
      },
    };

    final url = Uri.parse('$_baseUrl?key=$apiKey');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'systemInstruction': {
          'parts': [
            {'text': systemInstruction},
          ],
        },
        'generationConfig': generationConfig,
        'contents': [
          {
            'parts': [
              {
                'text':
                    """
      Trip duration: $totalDurationMinutes
      Start: $startAddress
      End: $endAddress
      Departure Time: $departureTime
      User notes: $preferences
      Plan the search windows.
      """,
              },
            ],
          },
        ],
      }),
    );

    if (response.statusCode != 200) {
      String errorMsg = response.body;
      try {
        final jsonErr = jsonDecode(response.body);
        if (jsonErr['error'] != null && jsonErr['error']['message'] != null) {
          errorMsg = jsonErr['error']['message'];
        }
      } catch (_) {}
      
      throw Exception(
        'Gemini API Error: ${response.statusCode} - $errorMsg',
      );
    }

    final jsonResponse = jsonDecode(response.body);
    final text =
        jsonResponse['candidates']?[0]?['content']?['parts']?[0]?['text'];

    if (text == null) {
      throw Exception('Gemini returned empty response');
    }

    return jsonDecode(text);
  }

  Future<List<dynamic>> generateStops({
    required Session session,
    required String personality,
    required String preferences,
    required String departureTime,
    required List<Map<String, dynamic>> candidateStops,
  }) async {
    final apiKey = await session.serverpod.getPassword('geminiApiKey');
    if (apiKey == null) {
      throw Exception('Gemini API key is missing in passwords.yaml');
    }

    if (candidateStops.isEmpty) return [];

    final systemInstruction =
        """
    You are the 'Road Trip Butler', a world-class travel concierge. 
    
    INPUT DATA:
    I will provide a JSON list of 'candidateStops' found along a route, grouped by 'slotTitle'.

    YOUR TASK:
    1. Review the candidates for each 'slotTitle'.
    2. Select exactly 3 options per 'slotTitle' that best fit the '$personality' persona and user preferences: '$preferences'.
    3. If a slot has fewer than 3 candidates, return all of them.
    4. Rewrite the 'butlerNote' for each selected stop to explain why it fits the persona. Explain what the stop is and why they should pick it. Be persuasive and specific. Use up to 2 sentences.
    5. Rename the 'slotTitle' to be something short and descriptive. It should be the same 'slotTitle' for all three candidates.

    OUTPUT FORMAT:
    - Return a JSON array of the selected stops.
    - Maintain the original fields: slotTitle, name, address, latitude, longitude, category, priceLevel, rating.
    - Update 'butlerNote'.
    """;

    final generationConfig = {
      'responseMimeType': 'application/json',
      'thinkingConfig': {
        'includeThoughts': false, // Recommended so you can debug the math
        'thinkingBudget': 0, // Range: 512 to 24,576
      },
      'responseSchema': {
        'type': 'ARRAY',
        'items': {
          'type': 'OBJECT',
          'properties': {
            'slotTitle': {
              'type': 'STRING',
              'description': 'Chapter name, e.g., "The Morning Brew"',
            },
            'name': {'type': 'STRING', 'description': 'Place name'},
            'address': {'type': 'STRING'},
            'latitude': {'type': 'NUMBER'},
            'longitude': {'type': 'NUMBER'},
            'category': {'type': 'STRING'},
            'butlerNote': {
              'type': 'STRING',
              'description':
                  'Why the butler picked this based on $personality and the user notes',
            },
            'priceLevel': {
              'type': 'STRING',
              'enum': ['low', 'medium', 'high'],
              'description': 'Cost of venue',
            },
            'rating': {'type': 'NUMBER'},
            'detourTimeMinutes': {
              'type': 'NUMBER',
              'description': "The detour time in minutes",
            },
          },
          'required': [
            'slotTitle',
            'name',
            'latitude',
            'longitude',
            'butlerNote',
            'priceLevel',
            'detourTimeMinutes',
            'rating',
          ],
        },
      },
    };

    final url = Uri.parse('$_baseUrl?key=$apiKey');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'systemInstruction': {
          'parts': [
            {'text': systemInstruction},
          ],
        },
        'generationConfig': generationConfig,
        'contents': [
          {
            'parts': [
              {'text': jsonEncode(candidateStops)},
            ],
          },
        ],
      }),
    );

    if (response.statusCode != 200) {
      String errorMsg = response.body;
      try {
        final jsonErr = jsonDecode(response.body);
        if (jsonErr['error'] != null && jsonErr['error']['message'] != null) {
          errorMsg = jsonErr['error']['message'];
        }
      } catch (_) {}

      throw Exception(
        'Gemini API Error: ${response.statusCode} - $errorMsg',
      );
    }

    final jsonResponse = jsonDecode(response.body);
    final text =
        jsonResponse['candidates']?[0]?['content']?['parts']?[0]?['text'];

    if (text == null) {
      throw Exception('Gemini returned empty response');
    }

    return jsonDecode(text);
  }
}
