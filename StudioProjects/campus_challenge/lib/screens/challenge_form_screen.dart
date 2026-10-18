import 'package:flutter/material.dart';
import '../models/challenge.dart';
import '../database/database_helper.dart';

class ChallengeFormScreen extends StatefulWidget {
  const ChallengeFormScreen({super.key});

  @override
  State<ChallengeFormScreen> createState() =>
      _ChallengeFormScreenState();
}

class _ChallengeFormScreenState
    extends State<ChallengeFormScreen> {

  final titleController = TextEditingController();
  final categoryController = TextEditingController();
  final targetController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    categoryController.dispose();
    targetController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Challenge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),

            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
            ),

            TextField(
              controller: targetController,
              decoration: const InputDecoration(
                labelText: 'Target Units',
              ),
              keyboardType: TextInputType.number,
            ),

            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {

                if (titleController.text.isEmpty ||
                    categoryController.text.isEmpty ||
                    targetController.text.isEmpty) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please fill in all fields',
                      ),
                    ),
                  );

                  return;
                }

                final target =
                    int.tryParse(targetController.text) ?? 0;

                if (target <= 0) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Target Units must be greater than 0',
                      ),
                    ),
                  );

                  return;
                }

                final challenge = Challenge(
                  title: titleController.text,
                  category: categoryController.text,
                  targetUnits: target,
                  description: descriptionController.text,
                );

                await DatabaseHelper.instance
                    .insertChallenge(
                  challenge.toMap(),
                );

                if (mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Save Challenge'),
            ),
          ],
        ),
      ),
    );
  }
}