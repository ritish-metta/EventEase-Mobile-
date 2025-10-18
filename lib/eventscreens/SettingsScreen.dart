import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailUpdates = true;
  bool _darkMode = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 66, 24, 102),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Manage your preferences',
                        style: TextStyle(
                          color: Color(0xFFB8A0D4),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=47',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Settings Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    children: [
                      // Account Section
                      _buildSectionHeader('Account'),
                      _buildSettingsTile(
                        icon: Icons.person,
                        title: 'Profile',
                        subtitle: 'Edit your profile information',
                        onTap: () {},
                      ),
                      _buildSettingsTile(
                        icon: Icons.email,
                        title: 'Email Address',
                        subtitle: 'john@example.com',
                        onTap: () {},
                      ),
                      _buildSettingsTile(
                        icon: Icons.lock,
                        title: 'Password',
                        subtitle: 'Change your password',
                        onTap: () {},
                      ),
                      const SizedBox(height: 24),

                      // Notifications Section
                      _buildSectionHeader('Notifications'),
                      _buildToggleTile(
                        icon: Icons.notifications,
                        title: 'Push Notifications',
                        subtitle: 'Receive event reminders',
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                      ),
                      _buildToggleTile(
                        icon: Icons.mail,
                        title: 'Email Updates',
                        subtitle: 'Receive updates via email',
                        value: _emailUpdates,
                        onChanged: (value) {
                          setState(() {
                            _emailUpdates = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // Preferences Section
                      _buildSectionHeader('Preferences'),
                      _buildToggleTile(
                        icon: Icons.dark_mode,
                        title: 'Dark Mode',
                        subtitle: 'Already enabled',
                        value: _darkMode,
                        onChanged: (value) {
                          setState(() {
                            _darkMode = value;
                          });
                        },
                      ),
                      _buildLanguageTile(),
                      const SizedBox(height: 24),

                      // Help Section
                      _buildSectionHeader('Help & Support'),
                      _buildSettingsTile(
                        icon: Icons.help_outline,
                        title: 'Help Center',
                        subtitle: 'FAQs and support articles',
                        onTap: () {},
                      ),
                      _buildSettingsTile(
                        icon: Icons.info_outline,
                        title: 'About EventEase',
                        subtitle: 'Version 1.0.0',
                        onTap: () {},
                      ),
                      _buildSettingsTile(
                        icon: Icons.description,
                        title: 'Terms & Privacy',
                        subtitle: 'Read our policies',
                        onTap: () {},
                      ),
                      const SizedBox(height: 24),

                      // Logout Button
                      GestureDetector(
                        onTap: () {
                          _showLogoutDialog();
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B3D), Color(0xFFFF8A5C)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF6B3D).withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFB8A0D4),
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2D1B4E),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF7546A8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: const Color(0xFFFF6B3D),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFFB8A0D4),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFB8A0D4),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1B4E),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF7546A8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFFF6B3D),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFFB8A0D4),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFFF6B3D),
            inactiveThumbColor: const Color(0xFF8E8E93),
            inactiveTrackColor: const Color(0xFF3D2461),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1B4E),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF7546A8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.language,
              color: Color(0xFFFF6B3D),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Language',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _selectedLanguage,
                  style: const TextStyle(
                    color: Color(0xFFB8A0D4),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFFB8A0D4),
            size: 16,
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: const Color(0xFF2D1B4E),
        title: const Text(
          'Logout',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Color(0xFFB8A0D4)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFFB8A0D4)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Color(0xFFFF6B3D)),
            ),
          ),
        ],
      ),
    );
  }
}