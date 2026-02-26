import 'package:floodguard_ai/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/flood_data_service.dart';

class FloodMapPage extends StatefulWidget {
  const FloodMapPage({super.key});

  @override
  State<FloodMapPage> createState() => _FloodMapPageState();
}

class _FloodMapPageState extends State<FloodMapPage> {
  late GoogleMapController mapController;

  final FloodDataService _service = FloodDataService();
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
  }

  Future<void> loadMarkers() async {
    final data = await _service.getFloodHistory();

    setState(() {
      print("Data received: ${data.length} items");
      markers = data.map((record) {
        print("Marker at ${record.lat}, ${record.lng}");
        return Marker(
          markerId: MarkerId("${record.location}_${record.date.millisecondsSinceEpoch}"),
          position: LatLng(record.lat, record.lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            record.flooded ? BitmapDescriptor.hueRed : BitmapDescriptor.hueGreen,
          ),
          infoWindow: InfoWindow(
            title: record.location,
            snippet: record.flooded ? "Flooded • ${record.date.year}" : "No Flood",
          ),
        );
      }).toSet();
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("FloodGuard AI")),
    body: Column(
      children: [
        Expanded(
          flex: 3,
          child: GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(4.7406, 103.4111), 
              zoom: 12,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              loadMarkers();
            },
            markers: markers,
            myLocationEnabled: true,
          ),
        ),

        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.psychology, color: Colors.blue, size: 30),
                      const SizedBox(width: 10),
                      Text("AI Flood Analysis", 
                        style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    "Select a marker on the map to see real-time AI risk assessment and safety recommendations for that area.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  _buildStatTile(Icons.water_drop, "Rainfall", ""),
                  _buildStatTile(Icons.waves, "River Level", ""),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildStatTile(IconData icon, String label, String value) {
  return ListTile(
    leading: Icon(icon, color: Colors.blueGrey),
    title: Text(label),
    trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}
}
