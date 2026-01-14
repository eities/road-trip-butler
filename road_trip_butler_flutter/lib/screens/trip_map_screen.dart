import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:road_trip_butler_client/road_trip_butler_client.dart'; 

class TripMapScreen extends StatefulWidget {
  final Trip trip;

  const TripMapScreen({super.key, required this.trip});

  @override
  State<TripMapScreen> createState() => _TripMapScreenState();
}

class _TripMapScreenState extends State<TripMapScreen> {
  late GoogleMapController _mapController;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  List<LatLng> _polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    _initMapData();
  }

  void _initMapData() {
    // 1. Decode Polyline
    //PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> result = PolylinePoints.decodePolyline(widget.trip.polyline);

    if (result.isNotEmpty) {
      _polylineCoordinates = result.map((p) => LatLng(p.latitude, p.longitude)).toList();
      _polylines.add(
        Polyline(
          polylineId: const PolylineId("route"),
          color: Colors.blueAccent,
          points: _polylineCoordinates,
          width: 5,
        ),
      );
    }

    // 2. Create Markers
    if (widget.trip.stops != null) {
      for (var stop in widget.trip.stops!) {
        _markers.add(
          Marker(
            markerId: MarkerId(stop.id.toString()),
            position: LatLng(stop.latitude, stop.longitude),
            onTap: () => _showStopDetails(stop),
            infoWindow: InfoWindow(title: stop.name), // Fallback
          ),
        );
      }
    }
  }

  void _showStopDetails(Stop stop) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(stop.name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(stop.category.toUpperCase(), 
                   style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
              const Divider(),
              Text(stop.butlerNote, style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Back to Map"),
              )
            ],
          ),
        );
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _fitMapToPolyline();
  }

  void _fitMapToPolyline() {
    if (_polylineCoordinates.isEmpty) return;

    double minLat = _polylineCoordinates.first.latitude;
    double minLng = _polylineCoordinates.first.longitude;
    double maxLat = _polylineCoordinates.first.latitude;
    double maxLng = _polylineCoordinates.first.longitude;

    for (var point in _polylineCoordinates) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    // Add trip stops to the bounds calculation just in case they aren't exactly on the polyline
    for (var stop in widget.trip.stops ?? []) {
        if (stop.latitude < minLat) minLat = stop.latitude;
        if (stop.latitude > maxLat) maxLat = stop.latitude;
        if (stop.longitude < minLng) minLng = stop.longitude;
        if (stop.longitude > maxLng) maxLng = stop.longitude;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text("Your Butler-Curated Journey")),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _polylineCoordinates.isNotEmpty 
              ? _polylineCoordinates.first 
              : const LatLng(0, 0),
          zoom: 12,
        ),
        polylines: _polylines,
        markers: _markers,
        myLocationButtonEnabled: false,
        mapToolbarEnabled: false,
      ),
    );
  }
}