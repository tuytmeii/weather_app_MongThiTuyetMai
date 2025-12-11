// lib/widgets/daily_forecast_card.dart
// 🔧 ĐÃ THÊM: Translation đầy đủ cho ngày và mô tả thời tiết

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/forecast_model.dart';
import '../config/api_config.dart';
import '../l10n/app_localizations.dart';

class DailyForecastCard extends StatelessWidget {
  final List<ForecastModel> forecasts;
  final String temperatureUnit;

  const DailyForecastCard({
    super.key,
    required this.forecasts,
    required this.temperatureUnit,
  });

  @override
  Widget build(BuildContext context) {
    if (forecasts.isEmpty) return const SizedBox.shrink();

    final loc = AppLocalizations.of(context); // 🔑 THÊM
    final mainForecast = forecasts.length > 4 ? forecasts[4] : forecasts[0];

    // Tìm nhiệt độ min/max cho cả ngày
    double minTemp = forecasts.map((f) => f.temperature).reduce((a, b) => a < b ? a : b);
    double maxTemp = forecasts.map((f) => f.temperature).reduce((a, b) => a > b ? a : b);

    // Tính xác suất mưa cao nhất trong ngày
    double? maxPrecipitation;
    final precipValues = forecasts
        .where((f) => f.precipitationProbability != null && f.precipitationProbability! > 0)
        .map((f) => f.precipitationProbability!)
        .toList();
    
    if (precipValues.isNotEmpty) {
      maxPrecipitation = precipValues.reduce((a, b) => a > b ? a : b);
    }

    // Chuyển đổi nhiệt độ nếu cần
    if (temperatureUnit == 'fahrenheit') {
      minTemp = minTemp * 9 / 5 + 32;
      maxTemp = maxTemp * 9 / 5 + 32;
    }

    String unitSymbol = temperatureUnit == 'celsius' ? 'C' : 'F';
    
    // 🔑 QUAN TRỌNG: Dịch tên ngày trong tuần
    final dayName = _translateWeekday(context, mainForecast.dateTime.weekday);
    
    // 🔑 SỬA: Format ngày theo locale
    final date = _formatDate(context, mainForecast.dateTime);
    
    // 🔑 QUAN TRỌNG: Dịch mô tả thời tiết
    final description = _translateWeatherDescription(context, mainForecast.description);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayName, // 🔑 ĐÃ DỊCH
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CachedNetworkImage(
                  imageUrl: ApiConfig.getIconUrl(mainForecast.icon),
                  height: 50,
                  width: 50,
                  placeholder: (context, url) => const SizedBox(
                    height: 50,
                    width: 50,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.cloud,
                    size: 50,
                  ),
                ),
                if (maxPrecipitation != null && maxPrecipitation > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.water_drop,
                          size: 12,
                          color: Colors.blue[600],
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${maxPrecipitation.round()}%',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Text(
                description, // 🔑 ĐÃ DỊCH
                style: const TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${maxTemp.round()}°$unitSymbol',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${minTemp.round()}°$unitSymbol',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔑 THÊM HÀM: Dịch tên ngày trong tuần
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

  // 🔑 THÊM HÀM: Format ngày theo locale
  String _formatDate(BuildContext context, DateTime date) {
    final loc = AppLocalizations.of(context);
    
    // Lấy tháng dịch sang tiếng Việt nếu cần
    final monthNames = {
      1: loc.translate('january') ?? 'Jan',
      2: loc.translate('february') ?? 'Feb',
      3: loc.translate('march') ?? 'Mar',
      4: loc.translate('april') ?? 'Apr',
      5: loc.translate('may') ?? 'May',
      6: loc.translate('june') ?? 'Jun',
      7: loc.translate('july') ?? 'Jul',
      8: loc.translate('august') ?? 'Aug',
      9: loc.translate('september') ?? 'Sep',
      10: loc.translate('october') ?? 'Oct',
      11: loc.translate('november') ?? 'Nov',
      12: loc.translate('december') ?? 'Dec',
    };
    
    final month = monthNames[date.month] ?? 'Th${date.month}';
    return '$month ${date.day}';
  }

  // 🔑 THÊM HÀM: Dịch mô tả thời tiết
  String _translateWeatherDescription(BuildContext context, String description) {
    final loc = AppLocalizations.of(context);
    final lower = description.toLowerCase();
    
    // 🔍 DEBUG: In ra description để kiểm tra
    print('📝 Translating: "$description" (lowercase: "$lower")');
    
    // Kiểm tra các từ khóa cụ thể trước
    if (lower.contains('light rain') || lower.contains('light shower rain')) {
      print('✅ Matched: light rain');
      return loc.translate('light_rain');
    }
    if (lower.contains('moderate rain')) {
      print('✅ Matched: moderate rain');
      return loc.translate('moderate_rain') ?? loc.translate('rain');
    }
    if (lower.contains('heavy rain') || lower.contains('heavy intensity rain')) {
      print('✅ Matched: heavy rain');
      return loc.translate('heavy_rain');
    }
    if (lower.contains('overcast clouds') || lower.contains('overcast')) {
      print('✅ Matched: overcast clouds');
      return loc.translate('overcast_clouds');
    }
    if (lower.contains('broken clouds')) {
      print('✅ Matched: broken clouds');
      return loc.translate('broken_clouds');
    }
    if (lower.contains('scattered clouds')) {
      print('✅ Matched: scattered clouds');
      return loc.translate('scattered_clouds');
    }
    if (lower.contains('few clouds')) {
      print('✅ Matched: few clouds');
      return loc.translate('few_clouds');
    }
    
    // Kiểm tra các điều kiện chung
    if (lower.contains('clear')) {
      print('✅ Matched: clear');
      return loc.translate('clear');
    }
    if (lower.contains('cloud') && !lower.contains('rain')) {
      print('✅ Matched: clouds');
      return loc.translate('clouds');
    }
    if (lower.contains('rain') && !lower.contains('light') && !lower.contains('heavy')) {
      print('✅ Matched: rain');
      return loc.translate('rain');
    }
    if (lower.contains('drizzle')) {
      print('✅ Matched: drizzle');
      return loc.translate('drizzle');
    }
    if (lower.contains('thunder')) {
      print('✅ Matched: thunderstorm');
      return loc.translate('thunderstorm');
    }
    if (lower.contains('snow')) {
      print('✅ Matched: snow');
      return loc.translate('snow');
    }
    if (lower.contains('mist') || lower.contains('fog')) {
      print('✅ Matched: mist');
      return loc.translate('mist');
    }
    
    // Nếu không match, trả về original
    print('❌ No match found, returning original');
    return description;
  }
}