// lib/screens/home_screen.dart
// 🔧 ĐÃ SỬA: Tất cả text đều dùng AppLocalizations

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/weather_detail_item.dart';
import '../widgets/sunrise_sunset_card.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_widget.dart';
import 'search_screen.dart';
import 'settings_screen.dart';
import '../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final loc = AppLocalizations.of(context); // 🔑 THÊM

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => context.read<WeatherProvider>().refreshWeather(),
        child: Consumer<WeatherProvider>(
          builder: (context, provider, child) {
            if (provider.state == WeatherState.loading &&
                provider.currentWeather == null) {
              return const LoadingShimmer();
            }

            if (provider.state == WeatherState.error &&
                provider.currentWeather == null) {
              return ErrorWidgetCustom(
                message: provider.errorMessage,
                onRetry: () => provider.fetchWeatherByLocation(),
              );
            }

            if (provider.currentWeather == null) {
              return Center(child: Text(loc.noData)); // 🔑 SỬA
            }

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 500,
                  pinned: true,
                  stretch: true,
                  backgroundColor: Colors.black.withOpacity(0.2),
                  foregroundColor: Colors.white,
                  elevation: 0,

                  flexibleSpace: FlexibleSpaceBar(
                    background: CurrentWeatherCard(
                      weather: provider.currentWeather!,
                      isOffline: provider.isOffline,
                      temperatureUnit: settings.temperatureUnit,
                    ),
                  ),

                  actions: [
                    IconButton(
                      icon: const Icon(Icons.home),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      },
                      tooltip: loc.home, // 🔑 SỬA
                    ),
                    IconButton(
                      icon: const Icon(Icons.location_on),
                      onPressed: () => provider.fetchWeatherByLocation(),
                      tooltip: loc.translate('use_current_location'), // 🔑 SỬA
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SearchScreen()),
                        );
                      },
                      tooltip: loc.search, // 🔑 SỬA
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SettingsScreen()),
                        );
                      },
                      tooltip: loc.settings, // 🔑 SỬA
                    ),
                  ],
                ),

                // Sunrise/Sunset Card
                SliverToBoxAdapter(
                  child: SunriseSunsetCard(
                    sunrise: provider.currentWeather!.sunrise,
                    sunset: provider.currentWeather!.sunset,
                    timeFormat: settings.timeFormat,
                  ),
                ),

                if (provider.hourlyForecast.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            loc.hourlyForecast, // 🔑 SỬA
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (provider.hourlyForecast.isNotEmpty)
                  SliverToBoxAdapter(
                    child: HourlyForecastList(
                      forecasts: provider.hourlyForecast,
                      temperatureUnit: settings.temperatureUnit,
                      timeFormat: settings.timeFormat,
                    ),
                  ),

                if (provider.dailyForecast.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.dailyForecast, // 🔑 SỬA
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          ...provider.dailyForecast.take(5).map(
                            (dayForecasts) => DailyForecastCard(
                              forecasts: dayForecasts,
                              temperatureUnit: settings.temperatureUnit,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: WeatherDetailsSection(
                      weather: provider.currentWeather!,
                      windSpeedUnit: settings.windSpeedUnit,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class WeatherDetailsSection extends StatelessWidget {
  final dynamic weather;
  final String windSpeedUnit;

  const WeatherDetailsSection({
    super.key,
    required this.weather,
    required this.windSpeedUnit,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    // Chuyển đổi wind speed
    double windSpeed = weather.windSpeed.toDouble();
    String windLabel = 'm/s';

    switch (windSpeedUnit) {
      case 'km/h':
        windSpeed = windSpeed * 3.6;
        windLabel = 'km/h';
        break;
      case 'mph':
        windSpeed = windSpeed * 2.23694;
        windLabel = 'mph';
        break;
      default:
        windLabel = 'm/s';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.weatherDetails,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: WeatherDetailItem(
                        icon: Icons.water_drop,
                        label: loc.humidity,
                        value: '${weather.humidity}%',
                      ),
                    ),
                    Expanded(
                      child: WeatherDetailItem(
                        icon: Icons.air,
                        label: loc.windSpeed,
                        value: '${windSpeed.toStringAsFixed(1)} $windLabel',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: WeatherDetailItem(
                        icon: Icons.compress,
                        label: loc.pressure,
                        value: '${weather.pressure} hPa',
                      ),
                    ),
                    Expanded(
                      child: WeatherDetailItem(
                        icon: Icons.visibility,
                        label: loc.visibility,
                        value: weather.visibility != null
                            ? '${(weather.visibility! / 1000).toStringAsFixed(1)} km'
                            : 'N/A',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: WeatherDetailItem(
                        icon: Icons.explore,
                        label: loc.windDirection,
                        value: weather.windDirection != null
                            ? '${_getWindDirectionTranslated(context, weather.windDirection)} (${weather.windDirection}°)'
                            : 'N/A',
                      ),
                    ),
                    Expanded(
                      child: WeatherDetailItem(
                        icon: Icons.cloud,
                        label: loc.cloudiness,
                        value: weather.cloudiness != null
                            ? '${weather.cloudiness}%'
                            : 'N/A',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  String _getWindDirectionTranslated(BuildContext context, int degree) {
    final loc = AppLocalizations.of(context);
    final directions = [
      loc.translate('north'),
      loc.translate('north_east'),
      loc.translate('east'),
      loc.translate('south_east'),
      loc.translate('south'),
      loc.translate('south_west'),
      loc.translate('west'),
      loc.translate('north_west'),
    ];
    final index = ((degree + 22.5) / 45).floor() % 8;
    return directions[index];
  }
}