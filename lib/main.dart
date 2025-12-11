// lib/main.dart
// 🔧 ĐÃ SỬA: Thêm localization đầy đủ

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';
import 'providers/weather_provider.dart';
import 'providers/settings_provider.dart';
import 'services/weather_service.dart';
import 'services/location_service.dart';
import 'services/storage_service.dart';
import 'l10n/app_localizations.dart';
import 'config/api_config.dart'; // 🔑 THÊM

// 🔑 Load .env file trước khi chạy app
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load .env file
  await dotenv.load(fileName: ".env");
  
  // 🔍 DEBUG: Check API key từ .env
  final apiKeyFromEnv = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
  print('🔑 ========== APP STARTING ==========');
  print('🔑 .env loaded: ${dotenv.isEveryDefined(['OPENWEATHER_API_KEY']) ? "✅ YES" : "❌ NO"}');
  print('🔑 API Key from .env: ${apiKeyFromEnv.isEmpty ? "❌ EMPTY!" : "✅ ${apiKeyFromEnv.substring(0, 8)}..."}');
  print('🔑 Key length: ${apiKeyFromEnv.length} characters');
  
  // 🔍 DEBUG: Check API config
  ApiConfig.printApiKeyInfo();
  
  if (apiKeyFromEnv.isEmpty) {
    print('❌ CRITICAL: API Key is empty! Check your .env file');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 🔑 Settings Provider phải đầu tiên để các provider khác dùng được
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(
            WeatherService(apiKey: dotenv.env['OPENWEATHER_API_KEY'] ?? ''),
            LocationService(),
            StorageService(),
          ),
        ),
      ],
      // 🔑 QUAN TRỌNG: Consumer để rebuild khi locale thay đổi
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp(
            title: 'Weather App',
            debugShowCheckedModeBanner: false,
            
            // 🔑 THÊM: Localization delegates
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            
            // 🔑 THÊM: Supported locales
            supportedLocales: const [
              Locale('en', ''), // English
              Locale('vi', ''), // Vietnamese
            ],
            
            // 🔑 QUAN TRỌNG: Locale từ settings
            locale: settings.locale,
            
            // 🔑 THÊM: Locale resolution callback
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale == null) {
                return supportedLocales.first;
              }
              
              // Kiểm tra xem locale có được hỗ trợ không
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode) {
                  return supportedLocale;
                }
              }
              
              // Fallback to English
              return supportedLocales.first;
            },
            
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              fontFamily: 'Roboto',
            ),
            
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}