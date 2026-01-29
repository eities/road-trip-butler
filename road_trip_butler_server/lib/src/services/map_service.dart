import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

class RouteData {
  final String polyline;
  final List<String> anchors;
  final int durationMinutes;
  final List<Map<String, dynamic>> routePoints;

  RouteData({
    required this.polyline,
    required this.anchors,
    required this.durationMinutes,
    required this.routePoints,
  });
}

class MapService {
  Future<RouteData> fetchRoutePolyline(
    Session session,
    String startAddress,
    String endAddress,
    DateTime departureTime,
  ) async {
    // 1. Get API Key from Serverpod passwords
    //final apiKey = session.passwords['googleMapsApiKey'];
    final apiKey = await session.serverpod.getPassword('googleMapsApiKey');
    if (apiKey == null) {
      throw Exception('Google Maps API key is missing in passwords.yaml');
    }

    // 2. Construct the URL for Google Routes API
    final url = Uri.parse(
      'https://routes.googleapis.com/directions/v2:computeRoutes',
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': apiKey,
          'X-Goog-FieldMask':
              'routes.duration,routes.polyline.encodedPolyline,routes.legs.steps.staticDuration,routes.legs.steps.polyline.encodedPolyline,routes.legs.steps.endLocation',
        },
        body: jsonEncode({
          'origin': {'address': startAddress},
          'destination': {'address': endAddress},
          'travelMode': 'DRIVE',
          'routingPreference': 'TRAFFIC_AWARE',
          'departureTime': departureTime.toUtc().toIso8601String(),
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to connect to Google Routes API: ${response.statusCode} - ${response.body}',
        );
      }

      final data = jsonDecode(response.body);

      if (data['routes'] == null || (data['routes'] as List).isEmpty) {
        throw Exception(
          'No route found between "$startAddress" and "$endAddress".',
        );
      }

      final route = data['routes'][0];

      // 3. Extract polyline
      final String polyline = route['polyline']['encodedPolyline'];

      // 4. Extract duration (format is "123s")
      String durationStr = route['duration'] ?? '0s';
      if (durationStr.endsWith('s')) {
        durationStr = durationStr.substring(0, durationStr.length - 1);
      }
      final int durationMinutes = (int.tryParse(durationStr) ?? 0) ~/ 60;

      List<String> routeAnchors = [];
      List<Map<String, dynamic>> routePoints = [];
      int currentElapsedSeconds = 0;

      if (route['legs'] != null) {
        for (var leg in route['legs']) {
          if (leg['steps'] != null) {
            for (var step in leg['steps']) {
              String stepDurationStr = step['staticDuration'] ?? '0s';
              if (stepDurationStr.endsWith('s')) {
                stepDurationStr = stepDurationStr.substring(
                  0,
                  stepDurationStr.length - 1,
                );
              }
              int stepSeconds = int.tryParse(stepDurationStr) ?? 0;

              String stepPolyline = step['polyline']?['encodedPolyline'] ?? '';
              List<Map<String, double>> stepPoints = _decodePolyline(
                stepPolyline,
              );

              if (stepPoints.isNotEmpty) {
                for (int i = 0; i < stepPoints.length; i++) {
                  int pointTime =
                      currentElapsedSeconds +
                      (stepSeconds * (i + 1) / stepPoints.length).round();
                  routePoints.add({
                    'lat': stepPoints[i]['lat'],
                    'lng': stepPoints[i]['lng'],
                    'elapsedSeconds': pointTime,
                  });
                }
                currentElapsedSeconds += stepSeconds;
              }
            }
          }
        }
      }

      if (route['legs'] != null && (route['legs'] as List).isNotEmpty) {
        var steps = route['legs'][0]['steps'] as List;
        if (steps.isNotEmpty) {
          int stepsLength = steps.length ~/ 4;
          if (stepsLength == 0) stepsLength = 1;

          for (var i = 0; i < steps.length; i += stepsLength) {
            final endLocation = steps[i]['endLocation']['latLng'];
            if (endLocation != null) {
              // Convert to legacy format {lat: ..., lng: ...} string representation
              routeAnchors.add(
                {
                  'lat': endLocation['latitude'],
                  'lng': endLocation['longitude'],
                }.toString(),
              );
            }
          }
        }
      }

      return RouteData(
        polyline: polyline,
        anchors: routeAnchors,
        durationMinutes: durationMinutes,
        routePoints: routePoints,
      );
    } catch (e) {
      session.log('Error fetching polyline: $e', level: LogLevel.error);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchStopsFromQueries(
    Session session,
    List<Map<String, dynamic>> routePoints,
    List<dynamic> timeSlices,
  ) async {
    // final apiKey = session.passwords['googleMapsApiKey'];
    final apiKey = await session.serverpod.getPassword('googleMapsApiKey');
    if (apiKey == null) {
      throw Exception('Google Maps API key is missing in passwords.yaml');
    }

    if (routePoints.isEmpty) return [];

    List<Map<String, dynamic>> allStops = [];

    for (var slice in timeSlices) {
      int startMins = slice['timeSliceStartMinutes'];
      int endMins = slice['timeSliceEndMinutes'];
      String query = slice['googleSearchQuery'];

      int startSeconds = startMins * 60;
      int endSeconds = endMins * 60;

      int actualStartSeconds = -1;
      int actualEndSeconds = 0;
      List<Map<String, double>> segmentPoints = [];
      for (var p in routePoints) {
        int t = p['elapsedSeconds'];
        if (t >= startSeconds && t <= endSeconds) {
          segmentPoints.add({'lat': p['lat'], 'lng': p['lng']});
          if (actualStartSeconds == -1) actualStartSeconds = t;
          actualEndSeconds = t;
        }
      }

      if (segmentPoints.isEmpty) continue;

      int baselineDurationSeconds = max(
        0,
        actualEndSeconds - actualStartSeconds,
      );
      String encodedSegment = _encodePolyline(segmentPoints);

      // 3. Call Places API (New)
      final url = Uri.parse(
        'https://places.googleapis.com/v1/places:searchText',
      );

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': apiKey,
            'X-Goog-FieldMask':
                'places.displayName,places.formattedAddress,places.location,places.types,places.rating,places.priceLevel,routingSummaries',
          },
          body: jsonEncode({
            "textQuery": query,
            "searchAlongRouteParameters": {
              "polyline": {"encodedPolyline": encodedSegment},
            },
            // "routingParameters": {
            //   "origin": {
            //     "latitude": segmentPoints.first['lat'],
            //     "longitude": segmentPoints.first['lng']
            //   }
            // },
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final places = data['places'] as List?;
          final routingSummaries = data['routingSummaries'] as List?;
          //print(routingSummaries);
          if (places != null) {
            for (int i = 0; i < places.length; i++) {
              final place = places[i];
              int detourMinutes = 0;

              if (routingSummaries != null && i < routingSummaries.length) {
                final legs = routingSummaries[i]['legs'] as List?;
                if (legs != null && legs.length == 2) {
                  final durationToPlace = _parseDurationSeconds(
                    legs[0]['duration'],
                  );
                  final durationFromPlace = _parseDurationSeconds(
                    legs[1]['duration'],
                  );
                  final detourSeconds =
                      (durationToPlace + durationFromPlace) -
                      baselineDurationSeconds;
                  detourMinutes = max(0, (detourSeconds / 60).round());
                  //print(detourMinutes);
                }
              }
              // print(place['priceLevel']);
              // print(place['rating'])
              allStops.add({
                'slotTitle': query,
                'name': place['displayName']?['text'] ?? 'Unknown',
                'address': place['formattedAddress'] ?? '',
                'latitude':
                    (place['location']?['latitude'] as num?)?.toDouble() ?? 0.0,
                'longitude':
                    (place['location']?['longitude'] as num?)?.toDouble() ??
                    0.0,
                'category': (place['types'] as List?)?.isNotEmpty == true
                    ? place['types'][0]
                    : 'general',
                'butlerNote':
                    'Rated ${place['rating'] ?? 'N/A'} stars. Matched "$query".',
                'priceLevel': _mapPriceLevel(place['priceLevel']),
                'rating': place['rating'],
                'detourTimeMinutes': detourMinutes,
              });
            }
          }
        } else {
          session.log(
            'Failed to search places for "$query": ${response.body}',
            level: LogLevel.warning,
          );
        }
      } catch (e) {
        session.log(
          'Error searching places for "$query": $e',
          level: LogLevel.error,
        );
      }
    }

    return allStops;
  }

  String _encodePolyline(List<Map<String, double>> points) {
    var result = StringBuffer();
    int lastLat = 0;
    int lastLng = 0;

    for (final point in points) {
      int lat = (point['lat']! * 1e5).round();
      int lng = (point['lng']! * 1e5).round();

      _encodeValue(result, lat - lastLat);
      _encodeValue(result, lng - lastLng);

      lastLat = lat;
      lastLng = lng;
    }
    return result.toString();
  }

  int _parseDurationSeconds(String? duration) {
    if (duration == null) return 0;
    if (duration.endsWith('s')) {
      return int.tryParse(duration.substring(0, duration.length - 1)) ?? 0;
    }
    return int.tryParse(duration) ?? 0;
  }

  void _encodeValue(StringBuffer result, int value) {
    value = value < 0 ? ~(value << 1) : (value << 1);
    while (value >= 0x20) {
      result.writeCharCode((0x20 | (value & 0x1f)) + 63);
      value >>= 5;
    }
    result.writeCharCode(value + 63);
  }

  String _mapPriceLevel(dynamic level) {
    if (level == null) return 'low';
    if (level is String) {
      if (level.contains('FREE') || level.contains('INEXPENSIVE')) return 'low';
      if (level.contains('MODERATE')) return 'medium';
      if (level.contains('EXPENSIVE')) return 'high';
    }
    if (level is int) {
      if (level <= 1) return 'low';
      if (level == 2) return 'medium';
      return 'high';
    }
    return 'low';
  }

  List<Map<String, double>> _decodePolyline(String encoded) {
    List<Map<String, double>> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      poly.add({'lat': (lat / 1E5).toDouble(), 'lng': (lng / 1E5).toDouble()});
    }
    return poly;
  }
}
