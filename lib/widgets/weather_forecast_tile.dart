import 'package:floodguard_ai/services/weather_forecasts_service.dart';
import 'package:flutter/material.dart';

class WeatherForecastTile extends StatelessWidget {
  const WeatherForecastTile({
    super.key,
    required this.docId,
    required this.location,
    required this.weatherCondition,
    required this.temperature,
    required this.loadPage,
  });

  final String docId;
  final String location;
  final String weatherCondition;
  final String temperature;
  final Function loadPage;

  void _deleteWeatherForecast() async {
    await deleteWeatherForecast(docId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1000,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // location
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(location, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirmation'),
                          content: Text('Are you want to delete this weather forecast?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                _deleteWeatherForecast();

                                if (context.mounted) Navigator.pop(context);
                                loadPage();
                              },
                              child: Text("Confirm"),
                            ),
                            TextButton(
                              onPressed: () {
                                if (context.mounted) Navigator.pop(context);
                              },
                              child: Text("Cancel"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(Icons.delete),
                ),
              ],
            ),

            SizedBox(height: 5),

            // weather condition
            Text(
              weatherCondition,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.grey[700]),
            ),

            SizedBox(height: 5),

            // temperature
            Text(
              temperature,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
