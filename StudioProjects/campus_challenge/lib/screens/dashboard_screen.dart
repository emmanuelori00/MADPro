import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/challenge.dart';
import 'challenge_form_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<void> _openChallengeForm() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChallengeFormScreen(),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Challenges'),
      ),
      body: FutureBuilder<List<Challenge>>(
        future: DatabaseHelper.instance.getAllChallenges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            );
          }

          final challenges = snapshot.data ?? [];

          if (challenges.isEmpty) {
            return const Center(
              child: Text('No challenges yet'),
            );
          }

          return ListView.builder(
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              final challenge = challenges[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(challenge.title),
                  subtitle: Text(
                    '${challenge.category} • Target: ${challenge.targetUnits}',
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openChallengeForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}