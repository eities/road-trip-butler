import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:road_trip_butler_client/road_trip_butler_client.dart'; 

class TripMapScreen extends StatefulWidget {
  final Trip trip;
  final Stop? focusedStop;

  const TripMapScreen({super.key, required this.trip, this.focusedStop});

  @override
  State<TripMapScreen> createState() => _TripMapScreenState();
}

class _TripMapScreenState extends State<TripMapScreen> {
  late GoogleMapController _mapController;
  bool _isMapReady = false;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  List<LatLng> _polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    _initMapData();
  }

  @override
  void didUpdateWidget(TripMapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Always regenerate markers when the widget updates (e.g. parent setState called)
    setState(() {
      _generateMarkers();
    });

    if (widget.focusedStop != oldWidget.focusedStop && widget.focusedStop != null) {
      _zoomToChapter(widget.focusedStop!);
    }
  }

  void _initMapData() {
    // 1. Decode Polyline
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
    _generateMarkers();
  }

  void _generateMarkers() {
    _markers.clear();
    if (widget.trip.stops != null) {
      for (var stop in widget.trip.stops!) {
        final isSelected = stop.status == StopStatus.selected;
        final isFocused = widget.focusedStop?.id == stop.id;
        
        double hue;
        if (isSelected) {
          hue = BitmapDescriptor.hueGreen;
        } else if (isFocused) {
          hue = BitmapDescriptor.hueAzure; // Highlight focused stop
        } else {
          hue = BitmapDescriptor.hueRed;
        }

        _markers.add(
          Marker(
            markerId: MarkerId(stop.id.toString()),
            position: LatLng(stop.latitude, stop.longitude),
            onTap: () => _showStopDetails(stop),
            infoWindow: InfoWindow(title: stop.name), // Fallback
            icon: BitmapDescriptor.defaultMarkerWithHue(hue),
            zIndex: isFocused ? 10 : 0, // Bring focused marker to front
          ),
        );
      }
    }
  }

  void _zoomToChapter(Stop stop) {
    if (!_isMapReady) return;

    // Find all stops with the same slotTitle (Chapter)
    final chapterStops = widget.trip.stops
            ?.where((s) => s.slotTitle == stop.slotTitle)
            .toList() ??
        [];

    if (chapterStops.isEmpty) {
      _animateToStop(stop);
      return;
    }

    double minLat = chapterStops.first.latitude;
    double maxLat = chapterStops.first.latitude;
    double minLng = chapterStops.first.longitude;
    double maxLng = chapterStops.first.longitude;

    for (var s in chapterStops) {
      if (s.latitude < minLat) minLat = s.latitude;
      if (s.latitude > maxLat) maxLat = s.latitude;
      if (s.longitude < minLng) minLng = s.longitude;
      if (s.longitude > maxLng) maxLng = s.longitude;
    }

    // If points are identical or single point, just zoom to point. Otherwise fit bounds.
    if (minLat == maxLat && minLng == maxLng) {
      _animateToStop(stop);
    } else {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );
      _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      _mapController.showMarkerInfoWindow(MarkerId(stop.id.toString()));
    }
  }

  void _animateToStop(Stop stop) {
    if (!_isMapReady) return;
    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(stop.latitude, stop.longitude), 14),
    );
    _mapController.showMarkerInfoWindow(MarkerId(stop.id.toString()));
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
    _isMapReady = true;
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
      body: Stack(
        children: [
          GoogleMap(
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
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton.small(
              heroTag: 'reset_view_btn',
              onPressed: _fitMapToPolyline,
              backgroundColor: Colors.white,
              child: const Icon(Icons.zoom_out_map, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}