import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/challenge.dart';
import '../models/progress_log.dart';

class DetailScreen extends StatefulWidget {
  final Challenge challenge;

  const DetailScreen({
    super.key,
    required this.challenge,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int progress = 0;

  bool missionStarted = false;
  bool missionCompleted = false;

  List<ProgressLog> progressLogs = [];

  @override
  void initState() {
    super.initState();
    loadProgressLogs();
  }

  Future<void> loadProgressLogs() async {
    if (widget.challenge.id == null) return;

    final logs =
        await DatabaseHelper.instance.getProgressLogs(
      widget.challenge.id!,
    );

    int total = 0;

    for (var log in logs) {
      total += log.units;
    }

    setState(() {
      progressLogs = logs;
      progress = total;

      missionCompleted =
          progress >= widget.challenge.targetUnits;
    });
  }

  Future<void> addProgress(int units) async {
    await DatabaseHelper.instance.insertProgressLog(
      ProgressLog(
        challengeId: widget.challenge.id!,
        units: units,
        note: 'Manual Entry',
        loggedAt: DateTime.now().toString(),
      ).toMap(),
    );

    await loadProgressLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.challenge.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              missionCompleted
                  ? '✅ Mission Complete'
                  : '⌛ In Progress',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Category: ${widget.challenge.category}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            Text(
              'Target: ${widget.challenge.targetUnits}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Total Progress: $progress',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  missionStarted = true;
                });
              },
              child: const Text(
                'Start Mission',
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                final controller =
                    TextEditingController();

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        'Add Progress',
                      ),
                      content: TextField(
                        controller: controller,
                        keyboardType:
                            TextInputType.number,
                        decoration:
                            const InputDecoration(
                          labelText:
                              'Units Completed',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child:
                              const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            final units =
                                int.tryParse(
                                      controller.text,
                                    ) ??
                                    0;

                            await addProgress(
                              units,
                            );

                            if (mounted) {
                              Navigator.pop(
                                context,
                              );
                            }
                          },
                          child:
                              const Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text(
                'Add Progress',
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        'Finish Mission?',
                      ),
                      content: const Text(
                        'Are you sure you want to finish this mission?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                            );
                          },
                          child:
                              const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              missionCompleted =
                                  true;
                            });

                            Navigator.pop(
                              context,
                            );
                          },
                          child:
                              const Text('Finish'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text(
                'Finish Mission',
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  progress = 0;
                  missionStarted = false;
                  missionCompleted = false;
                  progressLogs.clear();
                });
              },
              child: const Text(
                'Reset Mission',
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Progress History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: progressLogs.isEmpty
                  ? const Center(
                      child: Text(
                        'No progress logs yet',
                      ),
                    )
                  : ListView.builder(
                      itemCount:
                          progressLogs.length,
                      itemBuilder:
                          (context, index) {
                        final log =
                            progressLogs[index];

                        return Card(
                          child: ListTile(
                            title: Text(
                              '${log.units} units completed',
                            ),
                            subtitle: Text(
                              log.note,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}