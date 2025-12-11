// lib/widgets/sunrise_sunset_card.dart
// 🔧 ĐÃ THÊM: Translation cho Sunrise/Sunset

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';

class SunriseSunsetCard extends StatelessWidget {
  final DateTime sunrise;
  final DateTime sunset;
  final String timeFormat;

  const SunriseSunsetCard({
    super.key,
    required this.sunrise,
    required this.sunset,
    required this.timeFormat,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context); // 🔑 THÊM
    
    // Chọn format dựa vào settings
    final timeFormatter = timeFormat == '24h' 
        ? DateFormat('HH:mm') 
        : DateFormat('h:mm a');
    
    final now = DateTime.now();
    
    // Tính toán thời gian còn lại đến sunrise/sunset
    Duration? timeUntilSunrise;
    Duration? timeUntilSunset;
    bool isSunriseNext = false;
    
    if (now.isBefore(sunrise)) {
      timeUntilSunrise = sunrise.difference(now);
      isSunriseNext = true;
    } else if (now.isBefore(sunset)) {
      timeUntilSunset = sunset.difference(now);
      isSunriseNext = false;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade400,
            Colors.deepOrange.shade300,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Sunrise
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.wb_sunny,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      loc.sunrise, // 🔑 SỬA: Dùng translation
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      timeFormatter.format(sunrise),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isSunriseNext && timeUntilSunrise != null)
                      Text(
                        'in ${_formatDuration(timeUntilSunrise)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          
          // Divider
          Container(
            width: 1,
            height: 50,
            color: Colors.white.withOpacity(0.3),
          ),
          
          // Sunset
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.wb_twilight,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      loc.sunset, // 🔑 SỬA: Dùng translation
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      timeFormatter.format(sunset),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!isSunriseNext && timeUntilSunset != null)
                      Text(
                        'in ${_formatDuration(timeUntilSunset)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }
}