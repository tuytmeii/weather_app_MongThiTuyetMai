// lib/widgets/daily_forecast_card.dart
// 🔧 ĐÃ THÊM: Translation cho ngày trong tuần và mô tả thời tiết

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

    final loc = AppLocalizations.of(context);
    final mainForecast = forecasts.length > 4 ? forecasts[4] : forecasts[0];

    // Tìm nhiệt độ min/max cho cả ngày
    double minTemp =
        forecasts.map((f) => f.temperature).reduce((a, b) => a < b ? a : b);
    double maxTemp =
        forecasts.map((f) => f.temperature).reduce((a, b) => a > b ? a : b);

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
    
    // 🔑 SỬA: Dịch tên ngày trong tuần
    final dayName = _translateWeekday(context, mainForecast.dateTime.weekday);
    final date = DateFormat('MMM d').format(mainForecast.dateTime);
    
    // 🔑 SỬA: Dịch mô tả thời tiết
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
                    dayName,
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
                description,
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

  // 🔑 THÊM: Dịch tên ngày trong tuần
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

  // 🔑 THÊM: Dịch mô tả thời tiết
  String _translateWeatherDescription(BuildContext context, String description) {
    final loc = AppLocalizations.of(context);
    final lower = description.toLowerCase();
    
    // Kiểm tra các từ khóa trong description
    if (lower.contains('clear')) return loc.translate('clear');
    if (lower.contains('cloud')) return loc.translate('clouds');
    if (lower.contains('rain') && !lower.contains('light') && !lower.contains('heavy')) {
      return loc.translate('rain');
    }
    if (lower.contains('light rain') || lower.contains('light shower')) {
      return loc.translate('light_rain') ?? 'light rain';
    }
    if (lower.contains('heavy rain')) {
      return loc.translate('heavy_rain') ?? 'heavy rain';
    }
    if (lower.contains('drizzle')) return loc.translate('drizzle');
    if (lower.contains('thunder')) return loc.translate('thunderstorm');
    if (lower.contains('snow')) return loc.translate('snow');
    if (lower.contains('mist') || lower.contains('fog')) return loc.translate('mist');
    
    // Nếu không match, trả về original
    return description;
  }
}