import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:road_trip_butler_client/road_trip_butler_client.dart';
import 'package:collection/collection.dart';
import 'package:road_trip_butler_flutter/screens/trip_map_screen.dart';
import '../main.dart';
import '../utils/map_utils.dart';

class TripBuildingScreen extends StatefulWidget {
  final Trip trip;

  const TripBuildingScreen({super.key, required this.trip});

  @override
  State<TripBuildingScreen> createState() => _TripBuildingScreenState();
}

class _TripBuildingScreenState extends State<TripBuildingScreen> {
  late GoogleMapController _mapController;
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};

  // Track selected stop IDs to visually indicate choice
  final Set<int> _selectedStopIds = {};

  @override
  void initState() {
    super.initState();
    //_initializeMapData();
  }

  void _initializeMapData() {
    // 1. Decode the Polyline
      final points = _decodePolyline(widget.trip.polyline);
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('trip_route'),
          points: points,
          color: Colors.blueAccent,
          width: 5,
        ),
      );
    

    // 2. Add Markers for stops
    // Note: Assuming 'stops' exists on Trip and has lat/lng fields based on your description
  for (var stop in widget.trip.stops!) { // Serverpod lists are often nullable, hence the !
    _markers.add(
      Marker(
        markerId: MarkerId(stop.id.toString()),
        position: LatLng(stop.latitude, stop.longitude),
        infoWindow: InfoWindow(title: stop.name, snippet: stop.butlerNote),
      ),
    );
  }
  }

  /// Decodes a Google Maps encoded polyline string into a list of LatLng
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
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
      final p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }

  Future<void> _onStopSelected(dynamic stop) async {
    setState(() {
      if (_selectedStopIds.contains(stop.id)) {
        _selectedStopIds.remove(stop.id);
      } else {
        _selectedStopIds.add(stop.id);
      }
    });

    try {
      // Call the Serverpod endpoint
      // Note: Ensure updateStopStatus is implemented in your Client/Endpoint
      // await client.trip.updateStopStatus(stopId: stop.id, status: 'selected');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update stop: $e")),
      );
      setState(() {
        _selectedStopIds.remove(stop.id);
      });
    }
  }

  String _getPriceDisplay(PriceLevel price) {
    switch (price) {
      case PriceLevel.low:
        return '\$';
      case PriceLevel.medium:
        return '\$\$';
      case PriceLevel.high:
        return '\$\$\$';
      default:
        return '\$';
    }
  }

  Future<void> _exportToGoogleMaps() async {
    final selectedStops = widget.trip.stops
            ?.where((stop) => _selectedStopIds.contains(stop.id))
            .toList() ??
        [];

    // Only block if no stops AND no start/end addresses (unlikely for a valid trip)
    if (selectedStops.isEmpty && (widget.trip.startAddress == null || widget.trip.startAddress!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nothing to export.")),
      );
      return;
    }

    await MapUtils().exportToGoogleMaps(
      selectedStops,
      startAddress: widget.trip.startAddress,
      endAddress: widget.trip.endAddress,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Group the stops by their slotTitle (e.g., "The Mid-Day Pitstop")
// Use the groupBy function from the collection package
  final groupedStops = groupBy(widget.trip.stops!, (Stop stop) => stop.slotTitle);
    
    // Placeholder data structure to allow compilation until model is updated
    //final Map<String, List<dynamic>> groupedStops = {}; 

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _exportToGoogleMaps,
        label: const Text('Export to Maps'),
        icon: const Icon(Icons.map),
      ),
      body: CustomScrollView(
        slivers: [
          // 1. SliverAppBar with Google Map
          SliverAppBar(
            
          
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
            background: TripMapScreen(trip: widget.trip)
            //GoogleMap(
          //     //   initialCameraPosition: CameraPosition(
          //     //     target: widget.trip.stops?.isNotEmpty == true
          //     //         ? LatLng(widget.trip.stops!.first.latitude, widget.trip.stops!.first.longitude)
          //     //         : const LatLng(37.7749, -122.4194),
          //     //     zoom: 10,
          //     //   ),
          //     //   //polylines: _polylines,
          //     //   //markers: _markers,
          //     //   zoomControlsEnabled: false,
          //     //   onMapCreated: (controller) => _mapController = controller,
          //     // ),
            ),
          ),

          // 2. SliverList for the Itinerary
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final slotTitle = groupedStops.keys.elementAt(index);
                final stopsForSlot = groupedStops[slotTitle]!;

                return ExpansionTile(
                  title: Text(
                    slotTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  initiallyExpanded: true,
                  children: [
                    SizedBox(
                      height: 240, // Height for the PageView cards
                      child: PageView.builder(
                        physics: const BouncingScrollPhysics(),
                        controller: PageController(viewportFraction: 0.9),
                        itemCount: stopsForSlot.length,
                        itemBuilder: (context, pageIndex) {
                          final stop = stopsForSlot[pageIndex];
                          final isSelected = _selectedStopIds.contains(stop.id);

                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: isSelected
                                  ? const BorderSide(color: Colors.green, width: 3)
                                  : BorderSide.none,
                            ),
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stop.name,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, size: 16, color: Colors.amber),
                                      const SizedBox(width: 4),
                                      Text(
                                        stop.rating.toString(),
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(_getPriceDisplay(stop.priceLevel), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Expanded(
                                    child: Text(
                                      stop.butlerNote,
                                      style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () => _onStopSelected(stop),
                                      icon: Icon(isSelected ? Icons.check : Icons.touch_app),
                                      label: Text(isSelected ? "Selected" : "Select this Stop"),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isSelected ? Colors.green : Colors.blueAccent,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
              childCount: groupedStops.length,
            ),
          ),
        ],
      ),
    );
  }
}