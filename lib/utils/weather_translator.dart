// lib/utils/weather_translator.dart

class WeatherTranslator {
  // Chuyển đổi tên ngày sang tiếng Việt
  static String translateDayName(String dayName, String locale) {
    if (locale != 'vi') return dayName;
    
    final Map<String, String> dayTranslations = {
      'Monday': 'Thứ Hai',
      'Tuesday': 'Thứ Ba',
      'Wednesday': 'Thứ Tư',
      'Thursday': 'Thứ Năm',
      'Friday': 'Thứ Sáu',
      'Saturday': 'Thứ Bảy',
      'Sunday': 'Chủ Nhật',
    };
    
    return dayTranslations[dayName] ?? dayName;
  }

  // Chuyển đổi mô tả thời tiết sang tiếng Việt
  static String translateWeatherDescription(String description, String locale) {
    if (locale != 'vi') return description;
    
    final Map<String, String> weatherTranslations = {
      // Clear
      'clear sky': 'trời quang',
      'clear': 'trời quang',
      
      // Clouds
      'few clouds': 'ít mây',
      'scattered clouds': 'mây rải rác',
      'broken clouds': 'nhiều mây',
      'overcast clouds': 'u ám',
      'clouds': 'nhiều mây',
      'cloudy': 'nhiều mây',
      
      // Rain
      'light rain': 'mưa nhẹ',
      'moderate rain': 'mưa vừa',
      'heavy intensity rain': 'mưa to',
      'very heavy rain': 'mưa rất to',
      'extreme rain': 'mưa cực to',
      'freezing rain': 'mưa đá',
      'light intensity shower rain': 'mưa rào nhẹ',
      'shower rain': 'mưa rào',
      'heavy intensity shower rain': 'mưa rào to',
      'ragged shower rain': 'mưa rào không đều',
      'rain': 'mưa',
      
      // Drizzle
      'light intensity drizzle': 'mưa phùn nhẹ',
      'drizzle': 'mưa phùn',
      'heavy intensity drizzle': 'mưa phùn dày',
      'light intensity drizzle rain': 'mưa phùn rải rác',
      'drizzle rain': 'mưa phùn',
      'heavy intensity drizzle rain': 'mưa phùn to',
      'shower rain and drizzle': 'mưa rào và mưa phùn',
      'heavy shower rain and drizzle': 'mưa rào to và mưa phùn',
      'shower drizzle': 'mưa phùn rào',
      
      // Thunderstorm
      'thunderstorm with light rain': 'dông có mưa nhẹ',
      'thunderstorm with rain': 'dông có mưa',
      'thunderstorm with heavy rain': 'dông có mưa to',
      'light thunderstorm': 'dông nhẹ',
      'thunderstorm': 'dông',
      'heavy thunderstorm': 'dông mạnh',
      'ragged thunderstorm': 'dông không đều',
      'thunderstorm with light drizzle': 'dông có mưa phùn nhẹ',
      'thunderstorm with drizzle': 'dông có mưa phùn',
      'thunderstorm with heavy drizzle': 'dông có mưa phùn to',
      
      // Snow
      'light snow': 'tuyết nhẹ',
      'snow': 'tuyết',
      'heavy snow': 'tuyết dày',
      'sleet': 'mưa tuyết',
      'light shower sleet': 'mưa tuyết nhẹ',
      'shower sleet': 'mưa tuyết',
      'light rain and snow': 'mưa và tuyết nhẹ',
      'rain and snow': 'mưa và tuyết',
      'light shower snow': 'tuyết rào nhẹ',
      'shower snow': 'tuyết rào',
      'heavy shower snow': 'tuyết rào dày',
      
      // Atmosphere
      'mist': 'sương mù',
      'smoke': 'khói',
      'haze': 'sương mù mỏng',
      'sand/dust whirls': 'lốc cát/bụi',
      'fog': 'sương mù dày',
      'sand': 'cát',
      'dust': 'bụi',
      'volcanic ash': 'tro núi lửa',
      'squalls': 'gió giật',
      'tornado': 'lốc xoáy',
    };
    
    // Tìm exact match trước
    if (weatherTranslations.containsKey(description.toLowerCase())) {
      return weatherTranslations[description.toLowerCase()]!;
    }
    
    // Tìm partial match
    for (var entry in weatherTranslations.entries) {
      if (description.toLowerCase().contains(entry.key)) {
        return entry.value;
      }
    }
    
    return description;
  }

  // Chuyển đổi tên tháng sang tiếng Việt (nếu cần)
  static String translateMonth(String month, String locale) {
    if (locale != 'vi') return month;
    
    final Map<String, String> monthTranslations = {
      'Jan': 'Th1',
      'Feb': 'Th2',
      'Mar': 'Th3',
      'Apr': 'Th4',
      'May': 'Th5',
      'Jun': 'Th6',
      'Jul': 'Th7',
      'Aug': 'Th8',
      'Sep': 'Th9',
      'Oct': 'Th10',
      'Nov': 'Th11',
      'Dec': 'Th12',
    };
    
    return monthTranslations[month] ?? month;
  }
}