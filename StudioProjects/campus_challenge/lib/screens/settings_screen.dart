import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {

  double target = 5;
  bool celebrations = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [

          Text(
            'Default Target: ${target.toInt()}',
          ),

          Slider(
            value: target,
            min: 1,
            max: 20,
            divisions: 19,
            onChanged: (value) {
              setState(() {
                target = value;
              });
            },
          ),

          SwitchListTile(
            title: const Text(
              'Celebrations Enabled',
            ),
            value: celebrations,
            onChanged: (value) {
              setState(() {
                celebrations = value;
              });
            },
          ),
        ],
      ),
    );
  }
}