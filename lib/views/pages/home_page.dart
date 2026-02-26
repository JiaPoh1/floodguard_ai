import 'package:floodguard_ai/views/pages/community_report_page.dart';
import 'package:floodguard_ai/views/pages/trends_page.dart';
import 'package:floodguard_ai/views/pages/weather_forecasts_page.dart';
import 'package:floodguard_ai/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'flood_map_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: CustomAppbar(
        title: "FloodGuard AI",
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Text
              Text('Welcome,', style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              Text(user?.email ?? "User", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

              const SizedBox(height: 25),

              // Flood Risk Card
              _floodRiskCard(),

              const SizedBox(height: 30),

              const Text("Quick Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              //Button Row
              Row(
                children: [
                  _actionButton(
                    context,
                    icon: Icons.map,
                    label: "View Map",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return FloodMapPage();
                          },
                        ),
                      );
                    },
                  ),
                  _actionButton(
                    context,
                    icon: Icons.report,
                    label: "Report Flood",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CommunityReportPage();
                          },
                        ),
                      );
                    },
                  ),
                  _actionButton(
                    context,
                    icon: Icons.cloud,
                    label: "Weather Forecasts",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return WeatherForecastsPage();
                          },
                        ),
                      );
                    },
                  ),
                  _actionButton(
                    context,
                    icon: Icons.bar_chart,
                    label: 'BigQuery',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return TrendsPage();
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _floodRiskCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Icon(Icons.warning, color: Colors.orange, size: 50),
          SizedBox(height: 10),
          Text("Flood Risk Level", style: TextStyle(fontSize: 16)),
          SizedBox(height: 5),
          Text(
            "MODERATE",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 30, color: const Color(0xFF0D47A1)),
                const SizedBox(height: 8),
                Text(label, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
