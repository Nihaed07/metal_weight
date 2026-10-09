import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _selectedLanguage = 'English (US)';

  final List<String> _languageOptions = ['English (US)', 'Arabic'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 2,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Card
            const SizedBox(height: 24),

            // Section 1: Preferences
            _buildSectionHeader('PREFERENCES'),
            const SizedBox(height: 8),
            _buildGroupedCard([
              // Dark Mode Switch Row
              // _buildSettingRow(
              //   icon: Icons.dark_mode_outlined,
              //   title: 'Dark Mode',
              //   subtitle: 'Toggle light or dark interface',
              //   trailing: Switch(
              //     value: _isDarkMode,
              //     activeThumbColor: const Color(0xFF004AC6),
              //     onChanged: (val) {
              //       setState(() {
              //         _isDarkMode = val;
              //       });
              //       _showSnackBar('Dark mode ${val ? 'enabled' : 'disabled'}');
              //     },
              //   ),
              //   showDivider: true,
              //   onTap: () {
              //     setState(() {
              //       _isDarkMode = !_isDarkMode;
              //     });
              //     _showSnackBar(
              //       'Dark mode ${_isDarkMode ? 'enabled' : 'disabled'}',
              //     );
              //   },
              // ),
              // Default Units

              // Language
              _buildSettingRow(
                icon: Icons.language,
                title: 'Language',
                subtitle: _selectedLanguage,
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF434655),
                ),
                showDivider: false,
                onTap: () {
                  _showLanguageSelectionDialog();
                },
              ),
            ]),
            const SizedBox(height: 24),

            // Section 2: Support & Info
            _buildSectionHeader('SUPPORT & INFO'),
            const SizedBox(height: 8),
            _buildGroupedCard([
              _buildSettingRow(
                icon: Icons.info_outline,
                title: 'About Milen traders',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF434655),
                ),
                showDivider: true,
                onTap: () {
                  _showAboutDialog();
                },
              ),
              _buildSettingRow(
                icon: Icons.shield_outlined,
                title: 'Privacy Policy',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF434655),
                ),
                showDivider: true,
                onTap: () {
                  // _launchURL('https://your-privacy-policy-url.com');
                },
              ),
              _buildSettingRow(
                icon: Icons.star_outline,
                title: 'Rate App',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF434655),
                ),
                showDivider: true,
                onTap: () {
                  _rateApp();
                },
              ),
              _buildSettingRow(
                icon: Icons.share_outlined,
                title: 'Share App',
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF434655),
                ),
                showDivider: false,
                onTap: () {
                  _shareApp();
                },
              ),
            ]),
            const SizedBox(height: 28),

            // Version Footer
            const Center(
              child: Column(
                children: [
                  Text(
                    'Milen traders (Build 892)',
                    style: TextStyle(
                      color: Color(0xFF737686),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '© 2026 Industrial Dynamics Ltd.',
                    style: TextStyle(
                      color: Color(0xFF737686),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // --- Build Section Header ---
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF004AC6),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // --- Build Grouped Card ---
  Widget _buildGroupedCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: const Color(0xFFC3C6D7).withValues(alpha: 0.5)),
      ),
      child: Column(children: children),
    );
  }

  // --- Build Setting Row ---
  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    String? subtitle,
    required Widget trailing,
    bool showDivider = true,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Icon Circle Container
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: const Color(0xFF004AC6), size: 20),
                  ),
                  const SizedBox(width: 14),

                  // Title and Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF191B23),
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF434655),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Trailing Action/Icon
                  trailing,
                ],
              ),
            ),
            if (showDivider)
              const Divider(
                height: 1,
                thickness: 0.5,
                color: Color(0xFFE1E2ED),
              ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _languageOptions.map((language) {
            final isSelected = language == _selectedLanguage;
            return ListTile(
              title: Text(language),
              trailing: isSelected
                  ? const Icon(Icons.check_circle, color: Color(0xFF2C3E50))
                  : const Icon(Icons.circle_outlined, color: Colors.grey),
              onTap: () {
                setState(() {
                  _selectedLanguage = language;
                });
                Navigator.pop(context);
                _showSnackBar('Language updated to $_selectedLanguage');
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // --- Show About Dialog ---
  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Milen traders',
      applicationVersion: 'v2.4.0',
      applicationLegalese: '© 2024 Industrial Dynamics Ltd.',
      children: const [
        SizedBox(height: 8),
        Text(
          'Milen traders is a professional metal weight calculator designed for engineers, architects, and manufacturing professionals.',
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 8),
        Text(
          'Features:\n• Multiple material types\n• Various shapes and profiles\n• Quick unit conversion\n• History tracking',
          style: TextStyle(fontSize: 13),
        ),
      ],
    );
  }

  // --- Launch URL ---
  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showSnackBar('Could not open URL');
      }
    } catch (e) {
      _showSnackBar('Error opening URL');
    }
  }

  // --- Rate App ---
  void _rateApp() {
    // For iOS, use: https://apps.apple.com/app/idYOUR_APP_ID
    // For Android, use: https://play.google.com/store/apps/details?id=YOUR_PACKAGE_NAME
    _launchURL(
      'https://play.google.com/store/apps/details?id=com.example.metalcalc',
    );
  }

  // --- Share App ---
  void _shareApp() {
    Share.share(
      'Check out Milen traders - The ultimate metal weight calculator app!\n\n'
      'Download now: https://play.google.com/store/apps/details?id=com.example.metalcalc',
      subject: 'MetalCalc Pro - Metal Weight Calculator',
    );
  }

  // --- Show Snackbar ---
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF004AC6),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}
