// lib/l10n/app_localizations.dart
// 🔧 ĐÃ CẬP NHẬT: Thêm đầy đủ các translation còn thiếu

import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Home Screen
      'home': 'Home',
      'search': 'Search',
      'settings': 'Settings',
      'use_current_location': 'Use current location',
      'search_city': 'Search city',
      'auto_detect_location': 'Automatically detect your location',
      
      // Weather Details
      'weather_details': 'Weather Details',
      'humidity': 'Humidity',
      'wind_speed': 'Wind Speed',
      'pressure': 'Pressure',
      'visibility': 'Visibility',
      'wind_direction': 'Wind Direction',
      'cloudiness': 'Cloudiness',
      'feels_like': 'Feels like',
      
      // Forecast
      'hourly_forecast': 'Hourly Forecast',
      'daily_forecast': '5-Day Forecast',
      
      // Sunrise/Sunset
      'sunrise': 'Sunrise',
      'sunset': 'Sunset',
      
      // Wind Directions
      'north': 'North',
      'north_east': 'Northeast',
      'east': 'East',
      'south_east': 'Southeast',
      'south': 'South',
      'south_west': 'Southwest',
      'west': 'West',
      'north_west': 'Northwest',
      
      // Days of week
      'monday': 'Monday',
      'tuesday': 'Tuesday',
      'wednesday': 'Wednesday',
      'thursday': 'Thursday',
      'friday': 'Friday',
      'saturday': 'Saturday',
      'sunday': 'Sunday',
      
      // Months
      'january': 'Jan',
      'february': 'Feb',
      'march': 'Mar',
      'april': 'Apr',
      'may': 'May',
      'june': 'Jun',
      'july': 'Jul',
      'august': 'Aug',
      'september': 'Sep',
      'october': 'Oct',
      'november': 'Nov',
      'december': 'Dec',
      
      // Weather Conditions
      'clear': 'Clear',
      'clouds': 'Cloudy',
      'few_clouds': 'Few clouds',
      'scattered_clouds': 'Scattered clouds',
      'broken_clouds': 'Broken clouds',
      'overcast_clouds': 'Overcast clouds',
      'rain': 'Rain',
      'light_rain': 'Light rain',
      'moderate_rain': 'Moderate rain',
      'heavy_rain': 'Heavy rain',
      'drizzle': 'Drizzle',
      'thunderstorm': 'Thunderstorm',
      'snow': 'Snow',
      'mist': 'Mist',
      
      // Settings Sections
      'units': 'Units',
      'location': 'Location',
      'notifications': 'Notifications',
      'data': 'Data',
      'about': 'About',
      'language': 'Language',
      
      // Units
      'temperature_unit': 'Temperature Unit',
      'wind_speed_unit': 'Wind Speed Unit',
      'time_format': 'Time Format',
      'celsius': 'Celsius (°C)',
      'fahrenheit': 'Fahrenheit (°F)',
      'meters_per_second': 'Meters/second (m/s)',
      'kilometers_per_hour': 'Kilometers/hour (km/h)',
      'miles_per_hour': 'Miles/hour (mph)',
      '12_hour': '12-hour',
      '24_hour': '24-hour',
      
      // Languages
      'english': 'English',
      'vietnamese': 'Vietnamese',
      
      // Settings Actions
      'weather_notifications': 'Weather Notifications',
      'receive_alerts': 'Receive weather alerts and updates',
      'clear_cache': 'Clear Cache',
      'remove_cached_data': 'Remove cached weather data',
      'clear_search_history': 'Clear Search History',
      'remove_recent_searches': 'Remove recent searches',
      
      // Dialog Messages
      'clear_cache_confirm': 'Are you sure you want to clear all cached weather data?',
      'clear_history_confirm': 'Are you sure you want to clear your search history?',
      'cancel': 'Cancel',
      'clear': 'Clear',
      'cache_cleared': 'Cache cleared successfully',
      'history_cleared': 'Search history cleared',
      
      // App Info
      'version': 'Version',
      'app_info': 'Weather app information',
      'app_description': 'A comprehensive weather application built with Flutter.\n\n'
          'Features:\n'
          '• Real-time weather data\n'
          '• 5-day forecast\n'
          '• Location-based weather\n'
          '• Offline support\n'
          '• Multi-language support',
      
      // Messages
      'offline_cached_data': 'Offline - Cached Data',
      'no_data': 'No Data',
      'loading': 'Loading weather data...',
      'error': 'Error',
      'retry': 'Retry',
    },
    'vi': {
      // Màn hình chính
      'home': 'Trang chủ',
      'search': 'Tìm kiếm',
      'settings': 'Cài đặt',
      'use_current_location': 'Dùng vị trí hiện tại',
      'search_city': 'Tìm kiếm thành phố',
      'auto_detect_location': 'Tự động xác định vị trí của bạn',
      
      // Chi tiết thời tiết
      'weather_details': 'Chi tiết thời tiết',
      'humidity': 'Độ ẩm',
      'wind_speed': 'Tốc độ gió',
      'pressure': 'Áp suất',
      'visibility': 'Tầm nhìn',
      'wind_direction': 'Hướng gió',
      'cloudiness': 'Mây che phủ',
      'feels_like': 'Cảm giác như',
      
      // Dự báo
      'hourly_forecast': 'Dự báo theo giờ',
      'daily_forecast': 'Dự báo 5 ngày',
      
      // Mặt trời mọc/lặn
      'sunrise': 'Bình minh',
      'sunset': 'Hoàng hôn',
      
      // Hướng gió
      'north': 'Bắc',
      'north_east': 'Đông Bắc',
      'east': 'Đông',
      'south_east': 'Đông Nam',
      'south': 'Nam',
      'south_west': 'Tây Nam',
      'west': 'Tây',
      'north_west': 'Tây Bắc',
      
      // Thứ trong tuần
      'monday': 'Thứ Hai',
      'tuesday': 'Thứ Ba',
      'wednesday': 'Thứ Tư',
      'thursday': 'Thứ Năm',
      'friday': 'Thứ Sáu',
      'saturday': 'Thứ Bảy',
      'sunday': 'Chủ Nhật',
      
      // Tháng
      'january': 'Th1',
      'february': 'Th2',
      'march': 'Th3',
      'april': 'Th4',
      'may': 'Th5',
      'june': 'Th6',
      'july': 'Th7',
      'august': 'Th8',
      'september': 'Th9',
      'october': 'Th10',
      'november': 'Th11',
      'december': 'Th12',
      
      // Điều kiện thời tiết
      'clear': 'Trời quang',
      'clouds': 'Nhiều mây',
      'few_clouds': 'Ít mây',
      'scattered_clouds': 'Mây rải rác',
      'broken_clouds': 'Mây vỡ',
      'overcast_clouds': 'Âm u',
      'rain': 'Mưa',
      'light_rain': 'Mưa nhẹ',
      'moderate_rain': 'Mưa vừa',
      'heavy_rain': 'Mưa to',
      'drizzle': 'Mưa phùn',
      'thunderstorm': 'Dông',
      'snow': 'Tuyết',
      'mist': 'Sương mù',
      
      // Phần cài đặt
      'units': 'Đơn vị',
      'location': 'Vị trí',
      'notifications': 'Thông báo',
      'data': 'Dữ liệu',
      'about': 'Giới thiệu',
      'language': 'Ngôn ngữ',
      
      // Đơn vị
      'temperature_unit': 'Đơn vị nhiệt độ',
      'wind_speed_unit': 'Đơn vị tốc độ gió',
      'time_format': 'Định dạng giờ',
      'celsius': 'Độ C (°C)',
      'fahrenheit': 'Độ F (°F)',
      'meters_per_second': 'Mét/giây (m/s)',
      'kilometers_per_hour': 'Kilômét/giờ (km/h)',
      'miles_per_hour': 'Dặm/giờ (mph)',
      '12_hour': '12 giờ',
      '24_hour': '24 giờ',
      
      // Ngôn ngữ
      'english': 'Tiếng Anh',
      'vietnamese': 'Tiếng Việt',
      
      // Hành động cài đặt
      'weather_notifications': 'Thông báo thời tiết',
      'receive_alerts': 'Nhận cảnh báo và cập nhật thời tiết',
      'clear_cache': 'Xóa bộ nhớ cache',
      'remove_cached_data': 'Xóa dữ liệu thời tiết đã lưu',
      'clear_search_history': 'Xóa lịch sử tìm kiếm',
      'remove_recent_searches': 'Xóa các tìm kiếm gần đây',
      
      // Thông báo hộp thoại
      'clear_cache_confirm': 'Bạn có chắc chắn muốn xóa tất cả dữ liệu thời tiết đã lưu?',
      'clear_history_confirm': 'Bạn có chắc chắn muốn xóa lịch sử tìm kiếm?',
      'cancel': 'Hủy',
      'clear': 'Xóa',
      'cache_cleared': 'Đã xóa bộ nhớ cache thành công',
      'history_cleared': 'Đã xóa lịch sử tìm kiếm',
      
      // Thông tin ứng dụng
      'version': 'Phiên bản',
      'app_info': 'Thông tin ứng dụng thời tiết',
      'app_description': 'Ứng dụng thời tiết toàn diện được xây dựng với Flutter.\n\n'
          'Tính năng:\n'
          '• Dữ liệu thời tiết thời gian thực\n'
          '• Dự báo 5 ngày\n'
          '• Thời tiết theo vị trí\n'
          '• Hỗ trợ ngoại tuyến\n'
          '• Hỗ trợ đa ngôn ngữ',
      
      // Thông báo
      'offline_cached_data': 'Ngoại tuyến - Dữ liệu đã lưu',
      'no_data': 'Không có dữ liệu',
      'loading': 'Đang tải dữ liệu thời tiết...',
      'error': 'Lỗi',
      'retry': 'Thử lại',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  // Helper getters - Thêm nhiều getters hơn
  String get home => translate('home');
  String get search => translate('search');
  String get settings => translate('settings');
  String get weatherDetails => translate('weather_details');
  String get humidity => translate('humidity');
  String get windSpeed => translate('wind_speed');
  String get windSpeedUnit => translate('wind_speed_unit');
  String get pressure => translate('pressure');
  String get visibility => translate('visibility');
  String get windDirection => translate('wind_direction');
  String get cloudiness => translate('cloudiness');
  String get feelsLike => translate('feels_like');
  String get hourlyForecast => translate('hourly_forecast');
  String get dailyForecast => translate('daily_forecast');
  String get sunrise => translate('sunrise');
  String get sunset => translate('sunset');
  String get language => translate('language');
  String get temperatureUnit => translate('temperature_unit');
  String get timeFormat => translate('time_format');
  String get celsius => translate('celsius');
  String get fahrenheit => translate('fahrenheit');
  String get metersPerSecond => translate('meters_per_second');
  String get kilometersPerHour => translate('kilometers_per_hour');
  String get milesPerHour => translate('miles_per_hour');
  String get english => translate('english');
  String get vietnamese => translate('vietnamese');
  String get offlineCachedData => translate('offline_cached_data');
  String get noData => translate('no_data');
  String get loading => translate('loading');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'vi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}