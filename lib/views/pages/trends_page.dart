import 'package:floodguard_ai/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import '../../services/trends_service.dart';
import 'month_detail_page.dart';

class TrendsPage extends StatelessWidget {
  const TrendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Climate Action Insights", actions: []),
      body: FutureBuilder<Map<String, int>>(
        future: TrendsService().getMonthlyTrends(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final data = snapshot.data ?? {};

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text("BigQuery Trend Analysis", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text("Click a month to view hyperlocal data points."),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: data.entries
                        .map(
                          (e) => Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: const Icon(Icons.analytics, color: Colors.blue),
                              title: Text(e.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text("${e.value} Historic Flood Events"),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                // Navigate to the Detail Page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MonthDetailPage(monthName: e.key)),
                                );
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
