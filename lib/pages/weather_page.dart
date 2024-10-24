import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('ed6690e498bcf96c7328ed598d2456e9');
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    // handle errors
    catch (e) {
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; // default to sunny weather

    switch (mainCondition.toLowerCase()) {
      case 'cloud':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2), // Pushes the content up

            // Location Icon
            Icon(
              Icons.location_on,
              color: Colors.grey[500],
              size: 22,
            ),

            // city name
            Padding(
              padding: const EdgeInsets.only(top: 8.0), // Padding above the city name
              child: Text(
                _weather?.cityName ?? "loading city...",
                style: GoogleFonts.oswald(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[500],
                ),
              ),
            ),

            const Spacer(flex: 1), // Space between the city name and the animation

            // weather animations
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            const Spacer(flex: 1), // Additional space between animation and temperature

            // temperature
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0), // Padding to move the temperature down
              child: Text(
                '${_weather?.temperature.round() ?? 0}°',
                style: GoogleFonts.oswald(
                  fontSize: 55,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500],
                ),
              ),
            ),

            const Spacer(flex: 2), // Ensures content is well spaced on the screen
          ],
        ),
      ),
    );
  }
}

