import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/progress_log.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History & Insights'),
      ),
      body: FutureBuilder<List<ProgressLog>>(
        future: DatabaseHelper.instance
            .getProgressLogs(1),
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

          final logs = snapshot.data ?? [];

          if (logs.isEmpty) {
            return const Center(
              child: Text(
                'No progress logs yet',
              ),
            );
          }

          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {

              final log = logs[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: const Icon(
                    Icons.check_circle_outline,
                  ),
                  title: Text(
                    '${log.units} units completed',
                  ),
                  subtitle: Text(
                    log.note,
                  ),
                  trailing: SizedBox(
                    width: 120,
                    child: Text(
                      log.loggedAt,
                      textAlign: TextAlign.end,
                      overflow:
                      TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}