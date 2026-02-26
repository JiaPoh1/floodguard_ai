import 'package:floodguard_ai/widgets/custom_appbar.dart';
import 'package:floodguard_ai/widgets/weather_forecast_tile.dart';
import 'package:floodguard_ai/views/pages/add_weather_forecast_page.dart';
import 'package:flutter/material.dart';
import 'package:floodguard_ai/services/weather_forecasts_service.dart';

class WeatherForecastsPage extends StatefulWidget {
  const WeatherForecastsPage({super.key});

  @override
  State<WeatherForecastsPage> createState() => _WeatherForecastsPageState();
}

class _WeatherForecastsPageState extends State<WeatherForecastsPage> {
  List<Map<String, dynamic>>? weatherForecasts;
  final List<Widget> pages = [WeatherForecastsPage()];

  Future<void> getWeatherForecasts() async {
    final data = await getAllWeatherForecasts();

    setState(() {
      weatherForecasts = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getWeatherForecasts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Weather Forecasts", actions: []),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: weatherForecasts == null
            ? Center(child: CircularProgressIndicator())
            : weatherForecasts!.isEmpty
            ? Center(child: Text("No weather forecasts"))
            : ListView.builder(
                itemCount: weatherForecasts!.length,
                itemBuilder: (context, index) {
                  final docId = weatherForecasts![index]['docId'];
                  final location = weatherForecasts![index]['name'];
                  final weatherCondition = weatherForecasts![index]['weather'][0]['main'];
                  final double tempInKelvin = weatherForecasts![index]['main']['temp'];
                  final String temperature = (tempInKelvin - 273).toStringAsFixed(2);

                  return WeatherForecastTile(
                    docId: docId,
                    location: location,
                    weatherCondition: weatherCondition,
                    temperature: "$temperature °C",
                    loadPage: getWeatherForecasts,
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddWeatherForecastPage(loadPage: getWeatherForecasts)),
          );
          await getWeatherForecasts();
        },
        backgroundColor: Color(0xFFBBDEFB),
        child: Text("+", style: TextStyle(fontSize: 25)),
      ),
    );
  }
}
