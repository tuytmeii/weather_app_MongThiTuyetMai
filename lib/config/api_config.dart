import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  
  static String get apiKey {
    final key = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
    
    if (_isFirstCall) {
      print('🔑 ApiConfig.apiKey called for first time');
      print('🔑 API Key: ${key.isEmpty ? "❌ EMPTY!" : "✅ ${key.substring(0, 8)}..."}');
      print('🔑 Key length: ${key.length} characters');
      _isFirstCall = false;
    }
    
    return key;
  }
  
  static bool _isFirstCall = true;
  
  static const String currentWeather = '/weather';
  static const String forecast = '/forecast';
  static const String oneCall = '/onecall';
  
  static String buildUrl(String endpoint, Map<String, dynamic> params) {
    final uri = Uri.parse('$baseUrl$endpoint');
    
    params['appid'] = apiKey;
    params['units'] = 'metric';
    
    final finalUrl = uri.replace(queryParameters: params.map(
      (key, value) => MapEntry(key, value.toString())
    )).toString();
    
    print('🌐 Built URL: ${finalUrl.replaceAll(apiKey, 'API_KEY_HIDDEN')}');
    
    return finalUrl;
  }
  
  static String getIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
  
  static String getLargeIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@4x.png';
  }
  
  static bool get isApiKeyValid {
    final key = apiKey;
    return key.isNotEmpty && key.length >= 32;
  }
  
  static void printApiKeyInfo() {
    final key = apiKey;
    print('🔑 ========== API CONFIG INFO ==========');
    print('🔑 API Key loaded: ${key.isNotEmpty ? "✅ YES" : "❌ NO"}');
    print('🔑 Key length: ${key.length} characters (should be 32)');
    if (key.isNotEmpty) {
      print('🔑 Key preview: ${key.substring(0, 8)}...');
    }
    print('🔑 Is valid: ${isApiKeyValid ? "✅ YES" : "❌ NO"}');
    print('🔑 ====================================');
  }
}