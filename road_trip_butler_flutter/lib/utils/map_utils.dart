// lib/utils/map_utils.dart
import 'package:url_launcher/url_launcher.dart';
import 'package:road_trip_butler_client/road_trip_butler_client.dart'; // Import your client models

class MapUtils {
  Future<void> exportToGoogleMaps(List<Stop> selectedStops, {String? startAddress, String? endAddress}) async {
    // If no stops and no addresses, do nothing
    if (selectedStops.isEmpty && (startAddress == null || startAddress.isEmpty)) return;

    String origin;
    String destination;
    List<Stop> waypointsList = [];

    String getStopLocation(Stop stop) {
      if (stop.name.isNotEmpty) {
        String cleanName = stop.name.replaceAll('|', ' ').replaceAll(',', ' ');
        return "$cleanName, ${stop.latitude},${stop.longitude}";
      }
      return "${stop.latitude},${stop.longitude}";
    }

    // 1. Define Origin
    if (startAddress != null && startAddress.isNotEmpty) {
      origin = startAddress;
      waypointsList = List.from(selectedStops);
    } else {
      // Fallback: Use first stop as origin
      origin = getStopLocation(selectedStops.first);
      if (selectedStops.length > 1) waypointsList = selectedStops.sublist(1);
    }

    // 2. Define Destination
    if (endAddress != null && endAddress.isNotEmpty) {
      destination = endAddress;
    } else if (waypointsList.isNotEmpty) {
      // Fallback: Use last stop/waypoint as destination
      final last = waypointsList.last;
      destination = getStopLocation(last);
      waypointsList.removeLast();
    } else {
      destination = origin;
    }

    // 3. Build Waypoints String
    String? waypoints;
    if (waypointsList.isNotEmpty) {
      waypoints = waypointsList.map((s) => getStopLocation(s)).join('|');
    }

    // 4. Build URL with proper encoding
    final params = {
      'api': '1',
      'origin': origin,
      'destination': destination,
      'travelmode': 'driving',
    };
    if (waypoints != null && waypoints.isNotEmpty) {
      params['waypoints'] = waypoints;
    }

    final url = Uri.https('www.google.com', '/maps/dir/', params);

    // 5. Launch it!
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }
}