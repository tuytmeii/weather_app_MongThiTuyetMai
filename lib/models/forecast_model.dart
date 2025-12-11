// lib/models/forecast_model.dart

class ForecastModel {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String icon;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final String mainCondition;
  final int pressure;
  final double? precipitationProbability;

  ForecastModel({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.mainCondition,
    required this.pressure,
    this.precipitationProbability,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final pop = json['pop'] != null ? (json['pop'] as num).toDouble() * 100 : null;
    
    print('🌧️ Precipitation probability: $pop% for ${DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000)}');
    
    return ForecastModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        (json['dt'] ?? 0) * 1000,
      ),
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      description: json['weather'][0]['description'] ?? 'Unknown',
      icon: json['weather'][0]['icon'] ?? '01d',
      tempMin: (json['main']['temp_min'] ?? 0).toDouble(),
      tempMax: (json['main']['temp_max'] ?? 0).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
      mainCondition: json['weather'][0]['main'] ?? 'Clear',
      pressure: json['main']['pressure'] ?? 0,
      precipitationProbability: pop, 
    );
  }

  String? get precipitationString {
    if (precipitationProbability == null) return null;
    return '${precipitationProbability!.round()}%';
  }

  String get temperatureString => '${temperature.round()}°';

  String get temperatureRange => '${tempMin.round()}° / ${tempMax.round()}°';
}