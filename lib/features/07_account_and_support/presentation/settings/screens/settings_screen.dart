import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core Imports
import '../../../../../core/config/app_colors.dart';
import '../../../../../core/config/app_typography.dart';
import '../../../../../core/services/storage_service.dart';
import '../../../../../core/services/di_container.dart'; // To access StorageService

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _currentLanguage = "English";

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    // Load current language from storage
    final langCode = sl<StorageService>().getAppLanguage();
    setState(() {
      _currentLanguage = langCode == 'ar' ? "Arabic" : "English";
    });
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Select Language"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("English"),
              trailing: _currentLanguage == "English" ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                _changeLanguage('en');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text("العربية"),
              trailing: _currentLanguage == "Arabic" ? const Icon(Icons.check, color: AppColors.primary) : null,
              onTap: () {
                _changeLanguage('ar');
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _changeLanguage(String code) async {
    await sl<StorageService>().saveAppLanguage(code);
    setState(() {
      _currentLanguage = code == 'ar' ? "Arabic" : "English";
    });

    // Note: اصلی ایپ میں زبان بدلنے کے لیے اکثر ایپ کو ری اسٹارٹ
    // یا main.dart میں Locale State کو اپڈیٹ کرنے کی ضرورت پڑتی ہے۔
    // فی الحال ہم صرف ٹوسٹ دکھا رہے ہیں۔
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Language changed to $_currentLanguage. Please restart app to apply changes completely.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // 1. General Settings Section
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text("General", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                ),
                ListTile(
                  leading: const Icon(Icons.language, color: AppColors.textPrimary),
                  title: const Text("Language"),
                  subtitle: Text(_currentLanguage),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
                  onTap: _showLanguageDialog,
                ),
                const Divider(height: 1, indent: 56),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
                  title: const Text("Push Notifications"),
                  value: _notificationsEnabled,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    setState(() => _notificationsEnabled = val);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 2. Account Settings Section
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text("Account", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                ),
                ListTile(
                  leading: const Icon(Icons.lock_outline, color: AppColors.textPrimary),
                  title: const Text("Change Password"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
                  onTap: () {
                    // Change Password Screen (Future Feature)
                  },
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: AppColors.error),
                  title: const Text("Delete Account", style: TextStyle(color: AppColors.error)),
                  onTap: () {
                    // Delete Account Dialog Logic
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 3. Legal Section
          Container(
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  title: const Text("Privacy Policy"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text("Terms of Service"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}