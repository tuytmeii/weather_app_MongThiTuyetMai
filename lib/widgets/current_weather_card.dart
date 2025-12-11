// lib/widgets/current_weather_card.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';
import '../config/api_config.dart';
import '../l10n/app_localizations.dart'; // ✨ THÊM

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final bool isOffline;
  final String temperatureUnit;

  const CurrentWeatherCard({
    super.key,
    required this.weather,
    this.isOffline = false,
    required this.temperatureUnit,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context); // ✨ THÊM
    
    // 🎯 Tối ưu hóa: Khai báo và chuyển đổi nhiệt độ gói gọn hơn
    // Khởi tạo các biến với giá trị ban đầu (Celsius)
    double displayTemp = weather.temperature;
    double feels = weather.feelsLike;
    double min = weather.tempMin ?? 0;
    double max = weather.tempMax ?? 0;

    // 🔑 SỬA: Kiểm tra 'fahrenheit' thay vì 'F'
    if (temperatureUnit == 'fahrenheit') {
      displayTemp = displayTemp * 9 / 5 + 32;
      feels = feels * 9 / 5 + 32;
      min = min * 9 / 5 + 32;
      max = max * 9 / 5 + 32;
    }

    // Hiển thị ký hiệu đúng
    String unitSymbol = temperatureUnit == 'celsius' ? 'C' : 'F';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: _getWeatherGradient(weather.mainCondition, weather.isDay),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              if (isOffline)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_off, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        loc.offlineCachedData, // ✨ DÙNG TRANSLATION
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              Text(
                weather.cityName,
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _formatDate(context, weather.dateTime), // ✨ DÙNG TRANSLATION
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 10),
              CachedNetworkImage(
                imageUrl: ApiConfig.getLargeIconUrl(weather.icon),
                height: 80,
                width: 80,
                placeholder: (context, url) => const SizedBox(height: 80, width: 80),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.cloud, size: 80, color: Colors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayTemp.round().toString(),
                    style: const TextStyle(
                      fontSize: 64,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    '°$unitSymbol',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
              Text(
                _translateWeatherCondition(context, weather.description), // ✨ DÙNG TRANSLATION
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 5),
              // 🔑 SỬA: Sử dụng unitSymbol đã chuyển đổi với translation
              Text(
                '${loc.feelsLike} ${feels.round()}° • H:${max.round()}° L:${min.round()}°$unitSymbol',
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ✨ THÊM: Format date với đa ngôn ngữ
  String _formatDate(BuildContext context, DateTime date) {
    final loc = AppLocalizations.of(context);
    final weekday = _translateWeekday(context, date.weekday);
    final month = DateFormat('MMM').format(date);
    final day = date.day;
    
    return '$weekday, $month $day';
  }

  // ✨ THÊM: Dịch thứ trong tuần
  String _translateWeekday(BuildContext context, int weekday) {
    final loc = AppLocalizations.of(context);
    switch (weekday) {
      case 1: return loc.translate('monday');
      case 2: return loc.translate('tuesday');
      case 3: return loc.translate('wednesday');
      case 4: return loc.translate('thursday');
      case 5: return loc.translate('friday');
      case 6: return loc.translate('saturday');
      case 7: return loc.translate('sunday');
      default: return '';
    }
  }

  // ✨ THÊM: Dịch điều kiện thời tiết
  String _translateWeatherCondition(BuildContext context, String description) {
    final loc = AppLocalizations.of(context);
    final lower = description.toLowerCase();
    
    if (lower.contains('clear')) return loc.translate('clear').toUpperCase();
    if (lower.contains('cloud')) return loc.translate('clouds').toUpperCase();
    if (lower.contains('rain')) return loc.translate('rain').toUpperCase();
    if (lower.contains('drizzle')) return loc.translate('drizzle').toUpperCase();
    if (lower.contains('thunder')) return loc.translate('thunderstorm').toUpperCase();
    if (lower.contains('snow')) return loc.translate('snow').toUpperCase();
    if (lower.contains('mist') || lower.contains('fog')) return loc.translate('mist').toUpperCase();
    
    return description.toUpperCase();
  }

  LinearGradient _getWeatherGradient(String condition, bool isDay) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return isDay
            ? const LinearGradient(colors: [Color(0xFF4A90E2), Color(0xFF87CEEB)], begin: Alignment.topCenter, end: Alignment.bottomCenter)
            : const LinearGradient(colors: [Color(0xFF2D3748), Color(0xFF1A202C)], begin: Alignment.topCenter, end: Alignment.bottomCenter);
      case 'rain':
      case 'drizzle':
        return const LinearGradient(colors: [Color(0xFF4A5568), Color(0xFF718096)], begin: Alignment.topCenter, end: Alignment.bottomCenter);
      case 'clouds':
        return const LinearGradient(colors: [Color(0xFFA0AEC0), Color(0xFFCBD5E0)], begin: Alignment.topCenter, end: Alignment.bottomCenter);
      case 'snow':
        return const LinearGradient(colors: [Color(0xFFE2E8F0), Color(0xFFFFFFFF)], begin: Alignment.topCenter, end: Alignment.bottomCenter);
      case 'thunderstorm':
        return const LinearGradient(colors: [Color(0xFF2D3748), Color(0xFF4A5568)], begin: Alignment.topCenter, end: Alignment.bottomCenter);
      default:
        return const LinearGradient(colors: [Color(0xFF667EEA), Color(0xFF764BA2)], begin: Alignment.topCenter, end: Alignment.bottomCenter);
    }
  }
}