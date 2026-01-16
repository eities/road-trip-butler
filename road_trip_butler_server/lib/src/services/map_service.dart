import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

class RouteData {
  final String polyline;
  final List<String> anchors;
  final int durationMinutes;

  RouteData({required this.polyline, required this.anchors, required this.durationMinutes});
}

class MapService {
  Future<RouteData> fetchRoutePolyline(
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

      List<String> routeAnchors = [];
      var steps = data['routes'][0]['legs'][0]['steps'];
      int stepsLength = steps.length ~/ 4;
      for (var i = 0; i < steps.length; i += stepsLength) {
        routeAnchors.add(steps[i]['end_location'].toString()); 
      }
      
      // 4. Extract overview_polyline
      final String polyline = data['routes'][0]['overview_polyline']['points'];
      
      final int durationMinutes = data['routes'][0]['legs'][0]['duration']['value'] ~/ 60;


      return RouteData(polyline: polyline, anchors: routeAnchors, durationMinutes: durationMinutes);
    } catch (e) {
      session.log('Error fetching polyline: $e', level: LogLevel.error);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchStopsFromQueries(
    Session session,
    String polyline,
    int totalDurationMinutes,
    List<dynamic> timeSlices,
  ) async {
    final apiKey = session.passwords['googleMapsApiKey'];
    if (apiKey == null) {
      throw Exception('Google Maps API key is missing in passwords.yaml');
    }

    final points = _decodePolyline(polyline);
    if (points.isEmpty) return [];

    // 1. Calculate total distance and cumulative distances for interpolation
    double totalDistanceKm = 0;
    List<double> cumulativeDistances = [0];
    for (int i = 0; i < points.length - 1; i++) {
      double dist = _calculateDistance(
          points[i]['lat']!, points[i]['lng']!, points[i + 1]['lat']!, points[i + 1]['lng']!);
      totalDistanceKm += dist;
      cumulativeDistances.add(totalDistanceKm);
    }

    List<Map<String, dynamic>> allStops = [];

    for (var slice in timeSlices) {
      int startMins = slice['timeSliceStartMinutes'];
      int endMins = slice['timeSliceEndMinutes'];
      String query = slice['googleSearchQuery'];

      // 2. Calculate segment based on time ratio
      double startRatio = totalDurationMinutes > 0 ? startMins / totalDurationMinutes : 0.0;
      double endRatio = totalDurationMinutes > 0 ? endMins / totalDurationMinutes : 1.0;
      
      startRatio = startRatio.clamp(0.0, 1.0);
      endRatio = endRatio.clamp(0.0, 1.0);
      if (startRatio > endRatio) {
         double temp = startRatio; startRatio = endRatio; endRatio = temp;
      }

      // Extract points for this segment
      List<Map<String, double>> segmentPoints = _getPolylineSegment(
        points, cumulativeDistances, totalDistanceKm, startRatio, endRatio
      );

      if (segmentPoints.isEmpty) continue;

      String encodedSegment = _encodePolyline(segmentPoints);

      // 3. Call Places API (New)
      final url = Uri.parse('https://places.googleapis.com/v1/places:searchText');
  
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': apiKey,
            'X-Goog-FieldMask': 'places.displayName,places.formattedAddress,places.location,places.types,places.rating,places.priceLevel',
          },
          body: jsonEncode({
            "textQuery": query,
            "searchAlongRouteParameters": {
              "polyline": {
                "encodedPolyline": encodedSegment
              }
            },
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final places = data['places'] as List?;
          
          if (places != null) {
             for (var place in places) {
                allStops.add({
                  'slotTitle': query,
                  'name': place['displayName']?['text'] ?? 'Unknown',
                  'address': place['formattedAddress'] ?? '',
                  'latitude': (place['location']?['latitude'] as num?)?.toDouble() ?? 0.0,
                  'longitude': (place['location']?['longitude'] as num?)?.toDouble() ?? 0.0,
                  'category': (place['types'] as List?)?.isNotEmpty == true ? place['types'][0] : 'general',
                  'butlerNote': 'Rated ${place['rating'] ?? 'N/A'} stars. Matched "$query".',
                  'priceLevel': _mapPriceLevel(place['priceLevel']),
                });
             }
          }
        } else {
          session.log('Failed to search places for "$query": ${response.body}', level: LogLevel.warning);
        }
      } catch (e) {
        session.log('Error searching places for "$query": $e', level: LogLevel.error);
      }
    }

    return allStops;
  }

  List<Map<String, double>> _getPolylineSegment(
      List<Map<String, double>> points, 
      List<double> cumulativeDistances, 
      double totalDistance, 
      double startRatio, 
      double endRatio) {
    
    double startDist = totalDistance * startRatio;
    double endDist = totalDistance * endRatio;

    int startIndex = 0;
    int endIndex = points.length - 1;

    for (int i = 0; i < cumulativeDistances.length; i++) {
      if (cumulativeDistances[i] >= startDist) {
        startIndex = max(0, i - 1); 
        break;
      }
    }

    for (int i = startIndex; i < cumulativeDistances.length; i++) {
      if (cumulativeDistances[i] >= endDist) {
        endIndex = i;
        break;
      }
    }
    
    if (startIndex > endIndex) return [points[startIndex]];

    return points.sublist(startIndex, endIndex + 1);
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

  void _encodeValue(StringBuffer result, int value) {
    value = value < 0 ? ~(value << 1) : (value << 1);
    while (value >= 0x20) {
      result.writeCharCode((0x20 | (value & 0x1f)) + 63);
      value >>= 5;
    }
    result.writeCharCode(value + 63);
  }

  String _mapPriceLevel(dynamic level) {
    if (level == null) return 'medium';
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
    return 'medium';
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

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Math.PI / 180
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }
}