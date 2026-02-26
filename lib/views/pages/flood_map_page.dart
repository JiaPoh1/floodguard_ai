import 'package:floodguard_ai/services/ai_service.dart';
import 'package:floodguard_ai/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/flood_data_service.dart';
import '../../services/google_weather_services.dart';

class FloodMapPage extends StatefulWidget {
  const FloodMapPage({super.key});

  @override
  State<FloodMapPage> createState() => _FloodMapPageState();
}

class _FloodMapPageState extends State<FloodMapPage> {
  late GoogleMapController mapController;

  final FloodDataService _service = FloodDataService();
  Set<Marker> markers = {};
  Marker? _markers;
  String aiAnalysis = "Select a marker to see AI analysis.";
  String riskLevel = "N/A";
  bool isThinking = false;
  String currentRain = "--";
  String currentCondition = "--";

  @override
  void initState() {
    super.initState();
  }

  void _handleTap(LatLng position) async {
    setState(() {
      isThinking = true;
      aiAnalysis = "Gemini is analyzing weather patterns...";
      _markers = Marker(
        markerId: const MarkerId('selected_spot'),
        position: position,
        infoWindow: const InfoWindow(title: 'Analyzing...'),
      );
    });

    try {
      // 1. Fetch Google Weather
      final weather = await WeatherService.getWeatherData(position.latitude, position.longitude);
      
      // 2. Run Gemini AI Analysis
      final result = await AIService().getAnalysis(weather);

      setState(() {
        currentRain = "${weather['precipitation']?['probability'] ?? 0}%";
        currentCondition = weather['weatherCondition']?['description']?['text']??"Unknown";
        
        aiAnalysis = result['analysis'];
        riskLevel = result['risk_level'];
        
        _markers = Marker(
          markerId: const MarkerId('selected_spot'),
          position: position,
          infoWindow: InfoWindow(
            title: '$currentCondition',
            snippet: 'Risk: $riskLevel',
          ),
        );
        isThinking = false;
      });
    } catch (e) {
      setState(() {
        isThinking = false;
        aiAnalysis = "Error analyzing this location. Please try again.";
      });
    }
  }

  Future<void> loadMarkers() async {
    final data = await _service.getFloodHistory();

    setState(() {
      print("Data received: ${data.length} items");
      markers = data.map((record) {
        print("Marker at ${record.lat}, ${record.lng}");
        return Marker(
          markerId: MarkerId(
            "${record.location}_${record.date.millisecondsSinceEpoch}",
          ),
          position: LatLng(record.lat, record.lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            record.flooded
                ? BitmapDescriptor.hueRed
                : BitmapDescriptor.hueGreen,
          ),
          infoWindow: InfoWindow(
            title: record.location,
            snippet: record.flooded
                ? "Flooded • ${record.date.year}"
                : "No Flood",
          ),
        );
      }).toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Rain and Flood Predictions", actions: []),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(4.7406, 103.4111),
                zoom: 6,
              ),
              onTap: _handleTap,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                loadMarkers();
              },
              markers: {...markers, if (_markers != null) _markers!,
              }
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
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.psychology,
                          color: Colors.blue,
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "AI Flood Analysis",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        if (!isThinking && riskLevel != "N/A")
                          Chip(
                            label: Text(riskLevel),
                            backgroundColor: _getRiskColor(riskLevel),
                          ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    isThinking
                        ? const LinearProgressIndicator()
                        : Text(
                            aiAnalysis,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                    const SizedBox(height: 20),
                    _buildStatTile(Icons.water_drop, "Rainfall", currentRain),
                    _buildStatTile(Icons.waves, "River Level", currentCondition),
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
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Color _getRiskColor(String level) {
    switch (level.toUpperCase()) {
      case 'EXTREME': return Colors.red;
      case 'HIGH': return Colors.orange;
      case 'MODERATE': return Colors.yellow[700]!;
      default: return Colors.green;
    }
  }
}
