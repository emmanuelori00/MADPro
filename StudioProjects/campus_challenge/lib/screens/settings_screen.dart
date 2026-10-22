import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double target = 5;
  bool celebrations = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs =
    await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      target = prefs.getDouble('target') ?? 5;
      celebrations =
          prefs.getBool('celebrations') ?? true;
    });
  }

  Future<void> saveSettings() async {
    final prefs =
    await SharedPreferences.getInstance();

    await prefs.setDouble(
      'target',
      target,
    );

    await prefs.setBool(
      'celebrations',
      celebrations,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Text(
              'Default Target: ${target.toInt()}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Slider(
              value: target,
              min: 1,
              max: 20,
              divisions: 19,
              label: target.toInt().toString(),
              onChanged: (value) {
                setState(() {
                  target = value;
                });

                saveSettings();
              },
            ),

            const SizedBox(height: 20),

            SwitchListTile(
              title: const Text(
                'Celebrations Enabled',
              ),
              subtitle: const Text(
                'Show celebration when a mission is completed',
              ),
              value: celebrations,
              onChanged: (value) {
                setState(() {
                  celebrations = value;
                });

                saveSettings();
              },
            ),
          ],
        ),
      ),
    );
  }
}