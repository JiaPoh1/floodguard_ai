import 'package:floodguard_ai/services/weather_forecasts_service.dart';
import 'package:floodguard_ai/widgets/custom_appbar.dart';
import 'package:floodguard_ai/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:country_state_city/country_state_city.dart' as csc;

class AddWeatherForecastPage extends StatefulWidget {
  const AddWeatherForecastPage({super.key, required this.loadPage});

  final Function loadPage;

  @override
  State<AddWeatherForecastPage> createState() => _AddWeatherForecastPageState();
}

class _AddWeatherForecastPageState extends State<AddWeatherForecastPage> {
  String? selectedState;
  String? selectedStateIso;
  String? selectedCity;
  List<csc.State> states = [];
  List<csc.City> cities = [];

  void _onAddClicked() async {
    final status = await addWeatherForecast(selectedCity!);

    if (status == 0) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Warning"),
            content: Text("This location cannot be found in the forecast. Please try another location."),
            actions: [
              TextButton(
                onPressed: () {
                  if (mounted) Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    await widget.loadPage();
    if (mounted) Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _loadStates();
  }

  void _loadStates() async {
    final allStates = await getAllStates();

    setState(() {
      states = allStates;
    });
  }

  void _loadCities() async {
    setState(() {
      cities = [];
      selectedCity = null;
    });

    final allCities = await getAllCitiesByState(selectedStateIso!);

    setState(() {
      cities = allCities;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Add Weather Forecast", actions: []),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // state select label
            Text("Choose a state", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            SizedBox(height: 10),

            // dropdown for all states in Malaysia
            states.isNotEmpty
                ? DropdownButtonFormField<String>(
                    decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
                    initialValue: selectedStateIso,
                    items: states.map((state) {
                      return DropdownMenuItem(value: state.isoCode, child: Text(state.name));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedState = value!;
                        selectedStateIso = value;
                      });

                      _loadCities();
                    },
                  )
                : Center(child: CircularProgressIndicator()),

            SizedBox(height: 30),

            // city select label
            Text("Choose a city", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            SizedBox(height: 10),

            // dropdown for all cities in chosen state in Malaysia
            if (selectedStateIso != null)
              cities.isNotEmpty
                  ? DropdownButtonFormField<String>(
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
                      initialValue: selectedCity,
                      items: cities.map((city) {
                        return DropdownMenuItem(value: city.name, child: Text(city.name));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCity = value!;
                        });
                      },
                    )
                  : CircularProgressIndicator()
            else
              Text('Please select a state first', style: TextStyle(fontSize: 18)),

            SizedBox(height: 30),

            // add button
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: CustomButton(buttonText: "Add", callback: _onAddClicked),
            ),
          ],
        ),
      ),
    );
  }
}
