// lib/views/pages/month_detail_page.dart

import 'package:floodguard_ai/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import '../../services/trends_service.dart';
import '../../widgets/ai_summary_widget.dart';

class MonthDetailPage extends StatelessWidget {
  final String monthName;
  const MonthDetailPage({super.key, required this.monthName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "$monthName Deep Dive", actions: []),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: TrendsService().getDetailsForMonth(monthName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final records = snapshot.data ?? [];

          return Column(
            children: [
              // AI SUMMARY SECTION
              AISummaryWidget(monthName: monthName, records: records),

              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Historical Records", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),

              // DATA LIST
              Expanded(
                child: ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final r = records[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: Icon(Icons.location_on, color: r['flooded'] == true ? Colors.red : Colors.green),
                        title: Text(r['location']),
                        subtitle: Text("Rain: ${r['rainfall_mm']}mm | River: ${r['river_level_m']}m"),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
