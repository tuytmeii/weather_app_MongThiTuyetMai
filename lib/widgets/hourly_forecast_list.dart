// lib/widgets/hourly_forecast_list.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/forecast_model.dart';
import '../config/api_config.dart';

class HourlyForecastList extends StatelessWidget {
  final List<ForecastModel> forecasts;
  final String temperatureUnit;

  // ⭐ THÊM TƯƠNG TỰ sunrise_sunset_card.dart
  final String timeFormat;

  const HourlyForecastList({
    super.key,
    required this.forecasts,
    required this.temperatureUnit,
    required this.timeFormat, // ⭐ THÊM
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: forecasts.length,
        itemBuilder: (context, index) {
          final forecast = forecasts[index];
          return _HourlyForecastItem(
            forecast: forecast,
            temperatureUnit: temperatureUnit,
            timeFormat: timeFormat, // ⭐ THÊM
          );
        },
      ),
    );
  }
}

class _HourlyForecastItem extends StatelessWidget {
  final ForecastModel forecast;
  final String temperatureUnit;

  // ⭐ THÊM
  final String timeFormat;

  const _HourlyForecastItem({
    required this.forecast,
    required this.temperatureUnit,
    required this.timeFormat, // ⭐ THÊM
  });

  @override
  Widget build(BuildContext context) {
    double temp = forecast.temperature;

    if (temperatureUnit == 'fahrenheit') {
      temp = temp * 9 / 5 + 32;
    }

    String unitSymbol = temperatureUnit == 'celsius' ? 'C' : 'F';

    // ⭐ FORMAT GIỜ ĐỒNG BỘ VỚI sunrise_sunset_card.dart
    final formatter = timeFormat == '24h'
        ? DateFormat('HH:mm')
        : DateFormat('h:mm a');

    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatter.format(forecast.dateTime), // ⭐ ĐÃ SỬA THEO timeFormat
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            CachedNetworkImage(
              imageUrl: ApiConfig.getIconUrl(forecast.icon),
              height: 32,
              width: 32,
              placeholder: (context, url) =>
                  const SizedBox(height: 32, width: 32),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.cloud, size: 32, color: Colors.grey),
            ),
            Text(
              '${temp.round()}°$unitSymbol',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
