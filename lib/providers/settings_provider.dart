// lib/providers/settings_provider.dart
// 🔧 ĐÃ SỬA: Thống nhất giá trị settings và thêm hỗ trợ đa ngôn ngữ

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  // 🔑 SỬA: Dùng giá trị chuẩn thống nhất
  String _temperatureUnit = 'celsius'; // celsius or fahrenheit
  String _windSpeedUnit = 'm/s'; // m/s, km/h, mph
  String _timeFormat = '24h'; // 12h or 24h
  String _language = 'en'; // en or vi
  Locale _locale = const Locale('en');
  bool _notificationsEnabled = false;
  bool _useLocation = true;

  SettingsProvider() {
    _loadSettings();
  }

  // Getters
  String get temperatureUnit => _temperatureUnit;
  String get windSpeedUnit => _windSpeedUnit;
  String get timeFormat => _timeFormat;
  String get language => _language;
  Locale get locale => _locale;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get useLocation => _useLocation;

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 🔑 SỬA: Load với giá trị mặc định chuẩn
    _temperatureUnit = prefs.getString('temperature_unit') ?? 'celsius';
    _windSpeedUnit = prefs.getString('wind_speed_unit') ?? 'm/s';
    _timeFormat = prefs.getString('time_format') ?? '24h';
    _language = prefs.getString('language') ?? 'en';
    _notificationsEnabled = prefs.getBool('notifications_enabled') ?? false;
    _useLocation = prefs.getBool('use_location') ?? true;
    
    _locale = Locale(_language);
    notifyListeners();
  }

  // Set temperature unit
  Future<void> setTemperatureUnit(String unit) async {
    _temperatureUnit = unit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('temperature_unit', unit);
    notifyListeners();
  }

  // Set wind speed unit
  Future<void> setWindSpeedUnit(String unit) async {
    _windSpeedUnit = unit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('wind_speed_unit', unit);
    notifyListeners();
  }

  // Set time format
  Future<void> setTimeFormat(String format) async {
    _timeFormat = format;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('time_format', format);
    notifyListeners();
  }

  // 🔑 SỬA: Khi đổi ngôn ngữ, rebuild toàn bộ app
  Future<void> setLanguage(String languageCode) async {
    _language = languageCode;
    _locale = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);
    notifyListeners();
  }

  // Set notifications enabled
  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);
    notifyListeners();
  }

  // Set use location
  Future<void> setUseLocation(bool enabled) async {
    _useLocation = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('use_location', enabled);
    notifyListeners();
  }

  // 🔑 SỬA: Convert temperature với giá trị chuẩn
  double convertTemperature(double celsius) {
    if (_temperatureUnit == 'fahrenheit') {
      return (celsius * 9 / 5) + 32;
    }
    return celsius;
  }

  String get temperatureSymbol => _temperatureUnit == 'fahrenheit' ? '°F' : '°C';

  double convertWindSpeed(double mps) {
    switch (_windSpeedUnit) {
      case 'km/h':
        return mps * 3.6;
      case 'mph':
        return mps * 2.23694;
      default:
        return mps;
    }
  }
}