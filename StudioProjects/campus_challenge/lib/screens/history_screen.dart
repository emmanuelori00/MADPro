import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History & Insights'),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Library Visit'),
            subtitle: Text('2 units completed'),
          ),
          ListTile(
            title: Text('Presentation Practice'),
            subtitle: Text('1 unit completed'),
          ),
        ],
      ),
    );
  }
}