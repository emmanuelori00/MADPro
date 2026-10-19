import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int progress = 0;

  bool missionStarted = false;
  bool missionCompleted = false;

  List<int> progressLogs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mission Details'),
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
                            Navigator.pop(
                                context);
                          },
                          child: const Text(
                            'Cancel',
                          ),
                        ),

                        TextButton(
                          onPressed: () {

                            int units =
                                int.tryParse(
                                  controller
                                      .text,
                                ) ??
                                    0;

                            setState(() {
                              progress += units;

                              progressLogs
                                  .add(units);

                              if (progress >= 5) {
                                missionCompleted =
                                true;
                              }
                            });

                            Navigator.pop(
                                context);
                          },
                          child: const Text(
                            'Save',
                          ),
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
                                context);
                          },
                          child: const Text(
                            'Cancel',
                          ),
                        ),

                        TextButton(
                          onPressed: () {

                            setState(() {
                              missionCompleted =
                              true;
                            });

                            Navigator.pop(
                                context);
                          },
                          child: const Text(
                            'Finish',
                          ),
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
              child: ListView.builder(
                itemCount:
                progressLogs.length,
                itemBuilder:
                    (context, index) {

                  return Card(
                    child: ListTile(
                      title: Text(
                        'Progress Log #${index + 1}',
                      ),
                      subtitle: Text(
                        '${progressLogs[index]} units completed',
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