import 'package:flutter/material.dart';
import '../../services/trends_service.dart';

class AISummaryWidget extends StatefulWidget {
  final String monthName;
  final List<Map<String, dynamic>> records;

  const AISummaryWidget({
    super.key,
    required this.monthName,
    required this.records,
  });

  @override
  State<AISummaryWidget> createState() => _AISummaryWidgetState();
}

class _AISummaryWidgetState extends State<AISummaryWidget> {
  late Future<String> _aiFuture;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  void _loadSummary() {
    setState(() {
      _aiFuture = TrendsService().getAISummaryForMonth(
        widget.monthName,
        widget.records,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.psychology, color: Colors.blue[800]),
                  const SizedBox(width: 10),
                  const Text(
                    "Gemini Climate Insight",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              // THE RETRY BUTTON
              ElevatedButton.icon(
                onPressed: _loadSummary,
                icon: const Icon(Icons.refresh),
                label: const Text("Refresh Insight"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FutureBuilder<String>(
            future: _aiFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LinearProgressIndicator();
              }

              if (snapshot.hasError ||
                  (snapshot.data != null && snapshot.data!.contains("Error"))) {
                return Column(
                  children: [
                    Text(
                      "Failed to load analysis. Check your connection or API key.",
                      style: TextStyle(color: Colors.red[700], fontSize: 13),
                    ),
                  ],
                );
              }

              return Text(
                snapshot.data ?? "No analysis available.",
                style: const TextStyle(fontStyle: FontStyle.italic),
              );
            },
          ),
        ],
      ),
    );
  }
}
