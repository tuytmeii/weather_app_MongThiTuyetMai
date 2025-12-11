// lib/screens/settings_screen.dart
// 🔧 THÊM: Force rebuild toàn bộ app khi đổi ngôn ngữ

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final StorageService _storageService = StorageService();
  
  String _temperatureUnit = AppConstants.celsiusUnit;
  String _windSpeedUnit = AppConstants.meterPerSecond;
  String _timeFormat = AppConstants.format24h;
  String _language = AppConstants.languageEnglish;
  bool _notificationsEnabled = false;
  bool _useLocation = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    
    try {
      final settingsProvider = context.read<SettingsProvider>();
      _temperatureUnit = settingsProvider.temperatureUnit;
      _windSpeedUnit = settingsProvider.windSpeedUnit;
      _timeFormat = settingsProvider.timeFormat;
      _language = settingsProvider.language;
      _notificationsEnabled = settingsProvider.notificationsEnabled;
      _useLocation = settingsProvider.useLocation;
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _saveTemperatureUnit(String unit) async {
    final settingsProvider = context.read<SettingsProvider>();
    await settingsProvider.setTemperatureUnit(unit);
    setState(() => _temperatureUnit = unit);
  }

  Future<void> _saveWindSpeedUnit(String unit) async {
    final settingsProvider = context.read<SettingsProvider>();
    await settingsProvider.setWindSpeedUnit(unit);
    setState(() => _windSpeedUnit = unit);
  }

  Future<void> _saveTimeFormat(String format) async {
    final settingsProvider = context.read<SettingsProvider>();
    await settingsProvider.setTimeFormat(format);
    setState(() => _timeFormat = format);
  }

  // 🔧 SỬA: Force rebuild toàn bộ app khi đổi ngôn ngữ
  Future<void> _saveLanguage(String languageCode) async {
    final settingsProvider = context.read<SettingsProvider>();
    await settingsProvider.setLanguage(languageCode);
    
    setState(() => _language = languageCode);
    
    if (mounted) {
      // 🔑 QUAN TRỌNG: Hiện dialog thông báo và đóng tất cả màn hình
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(_language == 'en' ? 'Language Changed' : 'Đã đổi ngôn ngữ'),
          content: Text(
            _language == 'en' 
                ? 'Language has been changed to ${languageCode == 'en' ? 'English' : 'Vietnamese'}. The app will reload.'
                : 'Ngôn ngữ đã được đổi sang ${languageCode == 'en' ? 'Tiếng Anh' : 'Tiếng Việt'}. Ứng dụng sẽ tải lại.'
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                
                // 🔑 Pop tất cả màn hình về home và rebuild
                Navigator.of(context).popUntil((route) => route.isFirst);
                
                // Force rebuild bằng cách setState trên root
                if (context.mounted) {
                  // Trigger rebuild của MaterialApp
                  settingsProvider.notifyListeners();
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _clearCache() async {
    final loc = AppLocalizations.of(context);
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.translate('clear_cache') ?? 'Clear Cache'),
        content: Text(loc.translate('clear_cache_confirm') ?? 'Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.translate('cancel') ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(loc.translate('clear') ?? 'Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _storageService.clearAllCache();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.translate('cache_cleared') ?? 'Cache cleared'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _clearSearchHistory() async {
    final loc = AppLocalizations.of(context);
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.translate('clear_history') ?? 'Clear History'),
        content: Text(loc.translate('clear_history_confirm') ?? 'Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.translate('cancel') ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(loc.translate('clear') ?? 'Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _storageService.clearRecentSearches();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.translate('history_cleared') ?? 'History cleared'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settings),
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSectionHeader(loc.translate('units')),
          _buildTemperatureUnitTile(loc),
          _buildWindSpeedUnitTile(loc),
          _buildTimeFormatTile(loc),
          const Divider(),
          
          _buildSectionHeader(loc.language),
          _buildLanguageTile(loc),
          const Divider(),
          
          _buildSectionHeader(loc.translate('location')),
          _buildLocationTile(loc),
          const Divider(),
          
          _buildSectionHeader(loc.translate('notifications')),
          _buildNotificationsTile(loc),
          const Divider(),
          
          _buildSectionHeader(loc.translate('data')),
          _buildClearCacheTile(loc),
          _buildClearSearchHistoryTile(loc),
          const Divider(),
          
          _buildSectionHeader(loc.translate('about')),
          _buildAboutTile(loc),
          _buildVersionTile(loc),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildTemperatureUnitTile(AppLocalizations loc) {
    return ListTile(
      leading: const Icon(Icons.thermostat),
      title: Text(loc.temperatureUnit),
      subtitle: Text(
        _temperatureUnit == AppConstants.celsiusUnit 
            ? loc.celsius
            : loc.fahrenheit
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(loc.temperatureUnit),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: Text(loc.celsius),
                  value: AppConstants.celsiusUnit,
                  groupValue: _temperatureUnit,
                  onChanged: (value) {
                    if (value != null) {
                      _saveTemperatureUnit(value);
                      Navigator.pop(context);
                    }
                  },
                ),
                RadioListTile<String>(
                  title: Text(loc.fahrenheit),
                  value: AppConstants.fahrenheitUnit,
                  groupValue: _temperatureUnit,
                  onChanged: (value) {
                    if (value != null) {
                      _saveTemperatureUnit(value);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWindSpeedUnitTile(AppLocalizations loc) {
    String getCurrentLabel() {
      switch (_windSpeedUnit) {
        case AppConstants.kilometerPerHour:
          return loc.kilometersPerHour;
        case AppConstants.milesPerHour:
          return loc.milesPerHour;
        default:
          return loc.metersPerSecond;
      }
    }

    return ListTile(
      leading: const Icon(Icons.air),
      title: Text(loc.windSpeedUnit),
      subtitle: Text(getCurrentLabel()),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(loc.windSpeedUnit),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: Text(loc.metersPerSecond),
                  value: AppConstants.meterPerSecond,
                  groupValue: _windSpeedUnit,
                  onChanged: (value) {
                    if (value != null) {
                      _saveWindSpeedUnit(value);
                      Navigator.pop(context);
                    }
                  },
                ),
                RadioListTile<String>(
                  title: Text(loc.kilometersPerHour),
                  value: AppConstants.kilometerPerHour,
                  groupValue: _windSpeedUnit,
                  onChanged: (value) {
                    if (value != null) {
                      _saveWindSpeedUnit(value);
                      Navigator.pop(context);
                    }
                  },
                ),
                RadioListTile<String>(
                  title: Text(loc.milesPerHour),
                  value: AppConstants.milesPerHour,
                  groupValue: _windSpeedUnit,
                  onChanged: (value) {
                    if (value != null) {
                      _saveWindSpeedUnit(value);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeFormatTile(AppLocalizations loc) {
    return ListTile(
      leading: const Icon(Icons.access_time),
      title: Text(loc.timeFormat),
      subtitle: Text(
        _timeFormat == AppConstants.format24h 
            ? '${loc.translate('24_hour')} (14:30)'
            : '${loc.translate('12_hour')} (2:30 PM)'
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(loc.timeFormat),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: Text('${loc.translate('24_hour')} (14:30)'),
                  value: AppConstants.format24h,
                  groupValue: _timeFormat,
                  onChanged: (value) {
                    if (value != null) {
                      _saveTimeFormat(value);
                      Navigator.pop(context);
                    }
                  },
                ),
                RadioListTile<String>(
                  title: Text('${loc.translate('12_hour')} (2:30 PM)'),
                  value: AppConstants.format12h,
                  groupValue: _timeFormat,
                  onChanged: (value) {
                    if (value != null) {
                      _saveTimeFormat(value);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageTile(AppLocalizations loc) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(loc.language),
      subtitle: Text(_language == 'en' ? loc.english : loc.vietnamese),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(loc.language),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: Text(loc.english),
                  value: AppConstants.languageEnglish,
                  groupValue: _language,
                  onChanged: (value) {
                    if (value != null) {
                      Navigator.pop(context);
                      _saveLanguage(value);
                    }
                  },
                ),
                RadioListTile<String>(
                  title: Text(loc.vietnamese),
                  value: AppConstants.languageVietnamese,
                  groupValue: _language,
                  onChanged: (value) {
                    if (value != null) {
                      Navigator.pop(context);
                      _saveLanguage(value);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocationTile(AppLocalizations loc) {
    return SwitchListTile(
      secondary: const Icon(Icons.location_on),
      title: Text(loc.translate('use_current_location')),
      subtitle: Text(loc.translate('auto_detect_location') ?? 'Automatically detect your location'),
      value: _useLocation,
      onChanged: (value) {
        context.read<SettingsProvider>().setUseLocation(value);
        setState(() => _useLocation = value);
      },
    );
  }

  Widget _buildNotificationsTile(AppLocalizations loc) {
    return SwitchListTile(
      secondary: const Icon(Icons.notifications),
      title: Text(loc.translate('weather_notifications') ?? 'Weather Notifications'),
      subtitle: Text(loc.translate('receive_alerts') ?? 'Receive weather alerts'),
      value: _notificationsEnabled,
      onChanged: (value) {
        context.read<SettingsProvider>().setNotificationsEnabled(value);
        setState(() => _notificationsEnabled = value);
      },
    );
  }

  Widget _buildClearCacheTile(AppLocalizations loc) {
    return ListTile(
      leading: const Icon(Icons.delete_sweep),
      title: Text(loc.translate('clear_cache') ?? 'Clear Cache'),
      subtitle: Text(loc.translate('remove_cached_data') ?? 'Remove cached data'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _clearCache,
    );
  }

  Widget _buildClearSearchHistoryTile(AppLocalizations loc) {
    return ListTile(
      leading: const Icon(Icons.history),
      title: Text(loc.translate('clear_search_history') ?? 'Clear Search History'),
      subtitle: Text(loc.translate('remove_recent_searches') ?? 'Remove recent searches'),
      trailing: const Icon(Icons.chevron_right),
      onTap: _clearSearchHistory,
    );
  }

  Widget _buildAboutTile(AppLocalizations loc) {
    return ListTile(
      leading: const Icon(Icons.info),
      title: Text(loc.translate('about')),
      subtitle: Text(loc.translate('app_info') ?? 'Weather app information'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        showAboutDialog(
          context: context,
          applicationName: AppConstants.appName,
          applicationVersion: AppConstants.appVersion,
          applicationIcon: const Icon(Icons.cloud, size: 48),
          children: [
            Text(loc.translate('app_description') ?? 
              'A comprehensive weather application built with Flutter.'),
          ],
        );
      },
    );
  }

  Widget _buildVersionTile(AppLocalizations loc) {
    return ListTile(
      leading: const Icon(Icons.code),
      title: Text(loc.translate('version') ?? 'Version'),
      subtitle: Text(AppConstants.appVersion),
    );
  }
}