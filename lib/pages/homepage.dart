import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:minimalweather/consts.dart';
import 'package:intl/intl.dart'; // Import intl package for DateFormat

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherFactory _wf =
      WeatherFactory(OPNENWEATHERAPIKEY); // Corrected API key
  Weather? _weather;
  String _selectedUnit = 'C'; // Default unit is Celsius

  @override
  void initState() {
    super.initState();
    _wf.currentWeatherByCityName("Waterloo").then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  // Dropdown widget to select the unit (Celsius or Fahrenheit)
  Widget _unitDropdown() {
    return DropdownButton<String>(
      value: _selectedUnit,
      items: [
        DropdownMenuItem(value: 'C', child: Text('Celsius')),
        DropdownMenuItem(value: 'F', child: Text('Fahrenheit')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedUnit = value ?? 'C'; // Change the selected unit
        });
      },
    );
  }

  // Convert temperature between Celsius and Fahrenheit
  double? _convertTemp(double? tempInCelsius) {
    if (tempInCelsius == null) return null;
    if (_selectedUnit == 'F') {
      return (tempInCelsius * 9 / 5) + 32; // Celsius to Fahrenheit
    }
    return tempInCelsius; // Return Celsius by default
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _locationHeader(),
          _unitDropdown(), // Add dropdown for unit selection
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          _dateTimeInfo(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          _weatherIcon(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          _currentTemp(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          _extraInfo(),
        ],
      ),
    );
  }

  Widget _dateTimeInfo() {
    DateTime? now = _weather?.date; // Handle null date
    if (now == null) {
      return const Text("Date not available");
    }
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: const TextStyle(
            fontSize: 35,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEE, MMM d")
                  .format(now), // Date in a more readable format
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _locationHeader() {
    return Text(
      _weather?.areaName ?? "",
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _weatherIcon() {
    // Fallback to empty string if weatherIcon is null
    String iconUrl = _weather?.weatherIcon != null
        ? "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"
        : "";

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
            image: DecorationImage(
              image:
                  NetworkImage(iconUrl), // Set network image for weather icon
              fit: BoxFit.contain,
            ),
          ),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    double? tempInSelectedUnit = _convertTemp(_weather?.temperature?.celsius);
    return Text(
      "${tempInSelectedUnit?.toStringAsFixed(0)}°${_selectedUnit}",
      style: const TextStyle(
        color: Colors.black,
        fontSize: 90,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _extraInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
        color: Colors.deepPurpleAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Max: ${_convertTemp(_weather?.tempMax?.celsius)?.toStringAsFixed(0)}°$_selectedUnit",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                "Min: ${_convertTemp(_weather?.tempMin?.celsius)?.toStringAsFixed(0)}°$_selectedUnit",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Wind: ${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              Text(
                "Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
