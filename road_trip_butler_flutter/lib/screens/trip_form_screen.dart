// lib/screens/trip_form_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:road_trip_butler_client/road_trip_butler_client.dart';
import 'trip_building_screen.dart';
import 'trip_map_screen.dart';
import '../main.dart';


class TripFormScreen extends StatefulWidget {
  @override
  _TripFormScreenState createState() => _TripFormScreenState();
}

class _TripFormScreenState extends State<TripFormScreen> {
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedPersona = 'The Explorer'; // Default

  static const List<Map<String, String>> _personas = [
  {'name': 'The Explorer', 'icon': '🧭', 'desc': 'Scenic & unique', 'detailed_description': 'scenic and unique, quirky attractions, slightly longer detours allowed if the stop is epic, prioritize making the driving stops memorable'},
  {'name': 'The Efficient', 'icon': '⚡', 'desc': 'Fast & direct', 'detailed_description': 'fast and direct, rest stops, quick stops, quick restaurants, fast food, or fast casual dining'},
  {'name': 'The Family Aide', 'icon': '🧸', 'desc': 'Kid-friendly stops', 'detailed_description': 'kid-friendly stops, playgrounds, more frequent quick stops'},
];

  Future<void> _pickDateTime() async {
    // 1. Pick the Date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(), // Can't start a road trip in the past!
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate == null) return; // User cancelled

    // 2. Pick the Time
    if (!mounted) return;
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );

    if (pickedTime == null) return; // User cancelled

    // 3. Combine them into one DateTime object
    setState(() {
      _selectedDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _planTrip() async {
    // 1. Show a loading dialog (The "Butler is Thinking" state)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Your Butler is planning the route..."),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      // 2. Build the Trip object from your form fields
      // final trip = Trip(
      //   description: "${_startController.text} to ${_endController.text}",
      //   startAddress: _startController.text,
      //   endAddress: _endController.text,
      //   departureTime: _selectedDate,
      //   personality: _selectedPersona,
      // );


      final startDateTime = DateTime.parse(_selectedDate.toString()).toLocal();
      final localDepartureTime = DateFormat('h:mm a').format(startDateTime);
  
      // 3. Call Serverpod (Wait for Gemini and Google Maps to respond)
      final completedTrip = await client.trip.createTrip(
        startAddress: _startController.text,
        endAddress: _endController.text,
        departureTime: _selectedDate,
        localDepartureTime: localDepartureTime,
        personality: _selectedPersona,
        personalityDescription: _personas.firstWhere((p) => p['name'] == _selectedPersona)['detailed_description']!,
        preferences: _notesController.text,
      );

      // 4. Close the loading dialog
      if (!mounted) return;
      Navigator.of(context).pop();

      // 5. Navigate to the Selection Screen with the REAL data from the server
      Navigator.of(context).push(
        MaterialPageRoute(
          //builder: (context) => TripMapScreen(trip: completedTrip),
          builder: (context) => TripBuildingScreen(trip: completedTrip),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close dialog on error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Butler Error: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Road Trip Butler"),
              centerTitle: true,
              background: Icon(Icons.directions_car, size: 80, color: Colors.blueGrey),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Where are we heading?", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _startController,
                    decoration: const InputDecoration(labelText: "Starting Point", prefixIcon: Icon(Icons.my_location)),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _endController,
                    decoration: const InputDecoration(labelText: "Destination", prefixIcon: Icon(Icons.place)),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    title: const Text("Departure Time"),
                    subtitle: Text(
                      DateFormat('EEEE, MMM d @ h:mm a').format(_selectedDate),
                      style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                    ),
                    leading: const Icon(Icons.calendar_month),
                    trailing: const Icon(Icons.edit, size: 20),
                    onTap: _pickDateTime, // Triggers the combined picker logic
                  ),
                  const Divider(),


                  const SizedBox(height: 10),
                  Text("Notes for the Butler", style: Theme.of(context).textTheme.titleMedium),
                  const Text("e.g. 'We need a vegetarian lunch stop around 1pm and a park for the kids.'", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _notesController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Tell your butler the vibes...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Butler Personality", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        children: _personas.map((persona) {
                          return ChoiceChip(
                            label: Text("${persona['icon']} ${persona['name']}"),
                            selected: _selectedPersona == persona['name'],
                            onSelected: (selected) {
                              setState(() => _selectedPersona = persona['name']!);
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _personas.firstWhere((p) => p['name'] == _selectedPersona)['desc']!,
                    style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        _planTrip();
                      },
                      child: const Text("Plan My Route"),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}