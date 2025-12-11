class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int? windDirection;
  final int pressure;
  final String description;
  final String icon;
  final String mainCondition;
  final DateTime dateTime;
  final double? tempMin;
  final double? tempMax;
  final int? visibility;
  final int? cloudiness;
  
  final DateTime sunrise;
  final DateTime sunset;
  
  final double lat;
  final double lon;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    this.windDirection,
    required this.pressure,
    required this.description,
    required this.icon,
    required this.mainCondition,
    required this.dateTime,
    this.tempMin,
    this.tempMax,
    this.visibility,
    this.cloudiness,
    required this.sunrise,
    required this.sunset,
    required this.lat,
    required this.lon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final int sunriseTimestamp = json['sys']?['sunrise'] ?? 0;
    final int sunsetTimestamp = json['sys']?['sunset'] ?? 0;
    
    final double lat = json['coord']?['lat']?.toDouble() ?? 0.0;
    final double lon = json['coord']?['lon']?.toDouble() ?? 0.0;

    final int? windDeg = json['wind']?['deg'];

    return WeatherModel(
      cityName: json['name'] ?? 'Unknown',
      country: json['sys']['country'] ?? '',
      temperature: (json['main']['temp'] ?? 0).toDouble(),
      feelsLike: (json['main']['feels_like'] ?? 0).toDouble(),
      humidity: json['main']['humidity'] ?? 0,
      windSpeed: (json['wind']['speed'] ?? 0).toDouble(),
      windDirection: windDeg,
      pressure: json['main']['pressure'] ?? 0,
      description: json['weather'][0]['description'] ?? 'Unknown',
      icon: json['weather'][0]['icon'] ?? '01d',
      mainCondition: json['weather'][0]['main'] ?? 'Clear',
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        (json['dt'] ?? 0) * 1000,
      ),
      tempMin: json['main']['temp_min']?.toDouble(),
      tempMax: json['main']['temp_max']?.toDouble(),
      visibility: json['visibility'],
      cloudiness: json['clouds']?['all'],
      
      sunrise: DateTime.fromMillisecondsSinceEpoch(sunriseTimestamp * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(sunsetTimestamp * 1000),
      
      lat: lat,
      lon: lon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'sys': {
        'country': country,
        'sunrise': sunrise.millisecondsSinceEpoch ~/ 1000, 
        'sunset': sunset.millisecondsSinceEpoch ~/ 1000,
      },
      'coord': {
        'lat': lat,
        'lon': lon,
      }, 
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'humidity': humidity,
        'pressure': pressure,
        'temp_min': tempMin,
        'temp_max': tempMax,
      },
      'wind': {
        'speed': windSpeed,
        'deg': windDirection,
      },
      'weather': [
        {
          'description': description,
          'icon': icon,
          'main': mainCondition,
        }
      ],
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'visibility': visibility,
      'clouds': {'all': cloudiness},
    };
  }

  String get temperatureString => '${temperature.round()}°';
  
  bool get isDay => icon.endsWith('d');
  
  String get windDirectionString {
    if (windDirection == null) return 'N/A';
    
    final directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
    final index = ((windDirection! + 22.5) / 45).floor() % 8;
    return directions[index];
  }
  
  String get windDirectionVietnamese {
    if (windDirection == null) return 'N/A';
    
    final directions = ['Bắc', 'Đông Bắc', 'Đông', 'Đông Nam', 'Nam', 'Tây Nam', 'Tây', 'Tây Bắc'];
    final index = ((windDirection! + 22.5) / 45).floor() % 8;
    return directions[index];
  }
}