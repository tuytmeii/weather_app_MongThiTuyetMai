// lib/services/weather_service.dart
// 🔧 VERSION với DEBUG - Sử dụng ApiConfig

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../config/api_config.dart';

class WeatherService {
  final String apiKey;

  WeatherService({required this.apiKey}) {
    // 🔍 DEBUG: Check API key
    print('🔑 WeatherService initialized');
    print('🔑 API Key: ${apiKey.isEmpty ? "EMPTY!" : "${apiKey.substring(0, 8)}..."}');
    print('🔑 ApiConfig.apiKey: ${ApiConfig.apiKey.isEmpty ? "EMPTY!" : "${ApiConfig.apiKey.substring(0, 8)}..."}');
  }

  // Get current weather by city name
  Future<WeatherModel> getCurrentWeatherByCity(String cityName) async {
    try {
      print('🌐 Fetching weather for city: $cityName');
      
      final url = ApiConfig.buildUrl(
        ApiConfig.currentWeather,
        {'q': cityName},
      );

      print('📡 Making HTTP request...');
      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      print('📊 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Weather data received successfully');
        return WeatherModel.fromJson(data);
      } else if (response.statusCode == 404) {
        print('❌ City not found: $cityName');
        throw Exception('City not found. Please check the city name.');
      } else if (response.statusCode == 401) {
        print('❌ Invalid API key - Status 401');
        print('🔍 Response body: ${response.body}');
        throw Exception('Invalid API key. Please check your configuration.');
      } else {
        print('❌ Failed with status: ${response.statusCode}');
        print('🔍 Response body: ${response.body}');
        throw Exception('Failed to load weather data. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception caught: $e');
      if (e.toString().contains('City not found') || 
          e.toString().contains('Invalid API key')) {
        rethrow;
      }
      throw Exception('Network error: Please check your internet connection.');
    }
  }

  // Get current weather by coordinates
  Future<WeatherModel> getCurrentWeatherByCoordinates(
    double lat,
    double lon,
  ) async {
    try {
      print('🌐 Fetching weather for coordinates: $lat, $lon');
      
      final url = ApiConfig.buildUrl(
        ApiConfig.currentWeather,
        {
          'lat': lat.toString(),
          'lon': lon.toString(),
        },
      );

      print('📡 Making HTTP request...');
      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      print('📊 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Weather data received successfully');
        return WeatherModel.fromJson(data);
      } else if (response.statusCode == 401) {
        print('❌ Invalid API key - Status 401');
        print('🔍 Response body: ${response.body}');
        throw Exception('Invalid API key');
      } else {
        print('❌ Failed with status: ${response.statusCode}');
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('❌ Exception caught: $e');
      throw Exception('Network error: Please check your internet connection.');
    }
  }

  // Get 5-day forecast
  Future<List<ForecastModel>> getForecast(String cityName) async {
    try {
      print('🌐 Fetching forecast for city: $cityName');
      
      final url = ApiConfig.buildUrl(
        ApiConfig.forecast,
        {'q': cityName},
      );

      print('📡 Making HTTP request...');
      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      print('📊 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> forecastList = data['list'] ?? [];
        print('✅ Forecast data received: ${forecastList.length} items');
        
        return forecastList
            .map((item) => ForecastModel.fromJson(item))
            .toList();
      } else if (response.statusCode == 401) {
        print('❌ Invalid API key - Status 401');
        throw Exception('Invalid API key');
      } else {
        print('❌ Failed with status: ${response.statusCode}');
        throw Exception('Failed to load forecast data');
      }
    } catch (e) {
      print('❌ Exception caught: $e');
      throw Exception('Failed to load forecast: ${e.toString()}');
    }
  }

  // Get weather icon URL
  String getIconUrl(String iconCode) {
    return ApiConfig.getIconUrl(iconCode);
  }

  // Get large weather icon URL
  String getLargeIconUrl(String iconCode) {
    return ApiConfig.getLargeIconUrl(iconCode);
  }
}