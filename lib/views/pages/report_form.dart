import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportForm extends StatefulWidget {
  const ReportForm({super.key});

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final _locationController = TextEditingController();
  final _commentController = TextEditingController();
  String _waterLevel = 'Low';

  void _submitReport() async {
    await FirebaseFirestore.instance.collection('reports').add({
      'location': _locationController.text,
      'waterLevel': _waterLevel,
      'comment': _commentController.text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _locationController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report Flood")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: "Location"),
            ),
            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: _waterLevel,
              items: ['Low', 'Medium', 'High']
                  .map(
                    (level) =>
                        DropdownMenuItem(value: level, child: Text(level)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _waterLevel = value!),
              decoration: const InputDecoration(labelText: "Water Level"),
            ),

            const SizedBox(height: 10),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(labelText: "Comment"),
              maxLines: 3,
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitReport,
              child: const Text("Submit Report"),
            ),
          ],
        ),
      ),
    );
  }
}
