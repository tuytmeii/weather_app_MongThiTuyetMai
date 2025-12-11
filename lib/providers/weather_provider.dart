import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService;
  final LocationService _locationService;
  final StorageService _storageService;

  WeatherModel? _currentWeather;
  List<ForecastModel> _forecast = [];
  WeatherState _state = WeatherState.initial;
  String _errorMessage = '';
  bool _isOffline = false;

  WeatherProvider(
    this._weatherService,
    this._locationService,
    this._storageService,
  );

  // Getters
  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get forecast => _forecast;
  WeatherState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isOffline => _isOffline;

  // Get hourly forecast (next 24 hours)
  List<ForecastModel> get hourlyForecast {
    if (_forecast.isEmpty) return [];
    final now = DateTime.now();
    return _forecast
        .where((f) => f.dateTime.isAfter(now) && 
                     f.dateTime.isBefore(now.add(const Duration(hours: 24))))
        .toList();
  }

  // Get daily forecast (grouped by day)
  List<List<ForecastModel>> get dailyForecast {
    if (_forecast.isEmpty) return [];
    
    Map<String, List<ForecastModel>> grouped = {};
    
    for (var forecast in _forecast) {
      final dateKey = '${forecast.dateTime.year}-${forecast.dateTime.month}-${forecast.dateTime.day}';
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(forecast);
    }
    
    return grouped.values.toList();
  }

  // Fetch weather by city
  Future<void> fetchWeatherByCity(String cityName) async {
    _state = WeatherState.loading;
    _isOffline = false;
    notifyListeners();

    try {
      _currentWeather = await _weatherService.getCurrentWeatherByCity(cityName);
      _forecast = await _weatherService.getForecast(cityName);
      
      await _storageService.saveWeatherData(_currentWeather!);
      await _storageService.saveLastCity(cityName);
      await _storageService.addRecentSearch(cityName);
      
      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      
      // Try to load cached data
      await loadCachedWeather();
    }
    
    notifyListeners();
  }

  // Fetch weather by current location
  Future<void> fetchWeatherByLocation() async {
    _state = WeatherState.loading;
    _isOffline = false;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();
      
      _currentWeather = await _weatherService.getCurrentWeatherByCoordinates(
        position.latitude,
position.longitude,
      );
      
      final cityName = await _locationService.getCityName(
        position.latitude,
        position.longitude,
      );
      
      _forecast = await _weatherService.getForecast(cityName);
      
      await _storageService.saveWeatherData(_currentWeather!);
      await _storageService.saveLastCity(cityName);
      
      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      
      // Try to load cached data
      await loadCachedWeather();
    }
    
    notifyListeners();
  }

  // Load cached weather
  Future<void> loadCachedWeather() async {
    final cachedWeather = await _storageService.getCachedWeather();
    
    if (cachedWeather != null) {
      _currentWeather = cachedWeather;
      _isOffline = true;
      
      // If we have cached data, set state to loaded
      if (_state == WeatherState.error) {
        _state = WeatherState.loaded;
      }
      
      notifyListeners();
    }
  }

  // Refresh weather data
  Future<void> refreshWeather() async {
    if (_currentWeather != null) {
      await fetchWeatherByCity(_currentWeather!.cityName);
    } else {
      await fetchWeatherByLocation();
    }
  }

  // Initialize - load last weather or use location
  Future<void> initialize() async {
    // Try to load cached weather first
    await loadCachedWeather();
    
    // Then try to fetch fresh data
    final lastCity = await _storageService.getLastCity();
    
    if (lastCity != null) {
      await fetchWeatherByCity(lastCity);
    } else {
      await fetchWeatherByLocation();
    }
  }

  // Get cache age message
  Future<String?> getCacheAgeMessage() async {
    final ageMinutes = await _storageService.getCacheAgeMinutes();
    
    if (ageMinutes == null) return null;
    
    if (ageMinutes < 60) {
      return 'Updated $ageMinutes min ago';
    } else {
      final hours = ageMinutes ~/ 60;
      return 'Updated $hours hour${hours > 1 ? 's' : ''} ago';
    }
  }
}