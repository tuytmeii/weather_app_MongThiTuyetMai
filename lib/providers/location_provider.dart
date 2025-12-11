import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/location_model.dart';
import '../services/location_service.dart';

enum LocationState { initial, loading, loaded, error, permissionDenied }

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService;
  
  LocationModel? _currentLocation;
  LocationState _state = LocationState.initial;
  String _errorMessage = '';
  bool _isLocationServiceEnabled = false;
  bool _hasPermission = false;

  LocationProvider(this._locationService);

  LocationModel? get currentLocation => _currentLocation;
  LocationState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isLocationServiceEnabled => _isLocationServiceEnabled;
  bool get hasPermission => _hasPermission;

  Future<bool> checkLocationService() async {
    try {
      _isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
      notifyListeners();
      return _isLocationServiceEnabled;
    } catch (e) {
      _isLocationServiceEnabled = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> checkLocationPermission() async {
    try {
      _hasPermission = await _locationService.checkPermission();
      
      if (!_hasPermission) {
        _state = LocationState.permissionDenied;
        _errorMessage = 'Location permission is required to get weather for your location';
      }
      
      notifyListeners();
      return _hasPermission;
    } catch (e) {
      _hasPermission = false;
      _state = LocationState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<LocationModel?> getCurrentLocation() async {
    _state = LocationState.loading;
    notifyListeners();

    try {
      final serviceEnabled = await checkLocationService();
      if (!serviceEnabled) {
        _state = LocationState.error;
        _errorMessage = 'Location services are disabled. Please enable them in settings.';
        notifyListeners();
        return null;
      }

      final hasPermission = await checkLocationPermission();
      if (!hasPermission) {
        _state = LocationState.permissionDenied;
        notifyListeners();
        return null;
      }

      final position = await _locationService.getCurrentLocation();
      
      final cityName = await _locationService.getCityName(
        position.latitude,
        position.longitude,
      );

      _currentLocation = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        cityName: cityName,
      );

      _state = LocationState.loaded;
      _errorMessage = '';
      notifyListeners();
      return _currentLocation;
    } catch (e) {
      _state = LocationState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  Future<LocationModel?> getCurrentLocationWithAddress() async {
    _state = LocationState.loading;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();
      final fullAddress = await _locationService.getFullAddress(
        position.latitude,
        position.longitude,
      );
      
      final parts = fullAddress.split(', ');
      
      _currentLocation = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        cityName: parts.isNotEmpty ? parts[0] : 'Unknown',
        country: parts.length > 1 ? parts[1] : null,
      );

      _state = LocationState.loaded;
      _errorMessage = '';
      notifyListeners();
      
      return _currentLocation;
    } catch (e) {
      _state = LocationState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return null;
    }
  }

  Future<bool> requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      
      _hasPermission = permission == LocationPermission.whileInUse ||
                       permission == LocationPermission.always;
      
      if (_hasPermission) {
        _state = LocationState.initial;
        _errorMessage = '';
      } else {
        _state = LocationState.permissionDenied;
        _errorMessage = 'Location permission denied';
      }
      
      notifyListeners();
      return _hasPermission;
    } catch (e) {
      _state = LocationState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> openLocationSettings() async {
    await _locationService.openLocationSettings();
  }

  void clearLocation() {
    _currentLocation = null;
    _state = LocationState.initial;
    _errorMessage = '';
    notifyListeners();
  }

  void resetState() {
    _state = LocationState.initial;
    _errorMessage = '';
    notifyListeners();
  }

  double getDistance(LocationModel location1, LocationModel location2) {
    return Geolocator.distanceBetween(
      location1.latitude,
      location1.longitude,
      location2.latitude,
      location2.longitude,
    ) / 1000;
  }

  String formatDistance(double distanceKm) {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).round()} m';
    } else if (distanceKm < 10) {
      return '${distanceKm.toStringAsFixed(1)} km';
    } else {
      return '${distanceKm.round()} km';
    }
  }
}
