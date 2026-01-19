import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          _buildSectionHeader(l10n.general),
          _buildLanguageTile(context, l10n, localeProvider),
          const Divider(height: 1),
          const SizedBox(height: 20),
          _buildSectionHeader(l10n.about),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Color(0xFFFFD700)),
            title: Text(l10n.version),
            trailing: const Text(
              '1.0.0',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.check_circle_outline, color: Color(0xFFFFD700)),
            title: const Text('Doping'),
            subtitle: const Text('Todo App với Pomodoro Timer'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
  
  Widget _buildLanguageTile(
    BuildContext context,
    AppLocalizations l10n,
    LocaleProvider localeProvider,
  ) {
    return ListTile(
      leading: const Icon(Icons.language, color: Color(0xFFFFD700)),
      title: Text(l10n.language),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            localeProvider.locale.languageCode == 'vi'
                ? l10n.vietnamese
                : l10n.english,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: () => _showLanguageDialog(context, l10n, localeProvider),
    );
  }
  
  void _showLanguageDialog(
    BuildContext context,
    AppLocalizations l10n,
    LocaleProvider localeProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(
              context,
              l10n.vietnamese,
              const Locale('vi'),
              localeProvider,
            ),
            const Divider(),
            _buildLanguageOption(
              context,
              l10n.english,
              const Locale('en'),
              localeProvider,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLanguageOption(
    BuildContext context,
    String label,
    Locale locale,
    LocaleProvider localeProvider,
  ) {
    final isSelected = localeProvider.locale == locale;
    
    return ListTile(
      title: Text(label),
      trailing: isSelected
          ? const Icon(Icons.check, color: Color(0xFFFFD700))
          : null,
      onTap: () {
        localeProvider.setLocale(locale);
        Navigator.pop(context);
      },
    );
  }
}
