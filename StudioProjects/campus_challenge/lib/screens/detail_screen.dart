import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() =>
      _DetailScreenState();
}

class _DetailScreenState
    extends State<DetailScreen> {

  int progress = 0;

  bool missionStarted = false;
  bool missionCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mission Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [

            Text(
              missionCompleted
                  ? 'Mission Complete'
                  : 'Mission Active',
              style:
              const TextStyle(fontSize: 22),
            ),

            const SizedBox(height: 20),

            Text(
              'Progress: $progress',
              style:
              const TextStyle(fontSize: 24),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  missionStarted = true;
                });
              },
              child:
              const Text('Start Mission'),
            ),

          ElevatedButton(
            onPressed: () {
              final progressController =
              TextEditingController();

              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Add Progress'),

                    content: TextField(
                      controller: progressController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Units Completed',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),

                      TextButton(
                        onPressed: () {

                          int units =
                              int.tryParse(
                                progressController.text,
                              ) ??
                                  0;

                          setState(() {
                            progress += units;
                          });

                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Add Progress'),
          ),

            ElevatedButton(
              onPressed: () {

                showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        title: const Text(
                            'Finish Mission?'),
                        content: const Text(
                          'Are you sure you want to finish this mission?',
                        ),
                        actions: [

                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                  context);
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
                                  context);
                            },
                            child:
                            const Text('Finish'),
                          ),
                        ],
                      ),
                );
              },
              child:
              const Text('Finish Mission'),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  progress = 0;
                  missionStarted = false;
                  missionCompleted = false;
                });
              },
              child:
              const Text('Reset Mission'),
            ),
          ],
        ),
      ),
    );
  }
}