import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // Import the geocoding package
import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather'; // Correct API URL
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    // Check and request location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Handle the case where permission is permanently denied
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    // Define the location settings
    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, // High accuracy
      distanceFilter: 100, // Only updates when the device moves by at least 100 meters
    );

    // Fetch the current location with the new locationSettings
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    // Convert the location into a list of placemark objects
    List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, position.longitude);

    // Extract the city name from the first placemark
    String? city = placemarks.isNotEmpty ? placemarks[0].locality : null;

    return city ?? "Unknown city";
  }
}
