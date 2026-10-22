import 'package:flutter/material.dart';
import 'package:campus_challenge/screens/database_helper.dart';
import 'workout_plan.dart';
import 'workout_plan_form_screen.dart';

class WorkoutPlanListScreen extends StatefulWidget {
  const WorkoutPlanListScreen({super.key});

  @override
  State<WorkoutPlanListScreen> createState() =>
      _WorkoutPlanListScreenState();
}

class _WorkoutPlanListScreenState
    extends State<WorkoutPlanListScreen> {
  List<WorkoutPlan> plans = [];

  @override
  void initState() {
    super.initState();
    loadPlans();
  }

  Future<void> loadPlans() async {
    final loaded =
    await DatabaseHelper.instance.getWorkoutPlans();

    if (!mounted) return;

    setState(() {
      plans = loaded;
    });
  }

  Future<void> openForm({
    WorkoutPlan? plan,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            WorkoutPlanFormScreen(
              plan: plan,
            ),
      ),
    );

    await loadPlans();
  }

  Future<void> deletePlan(
      WorkoutPlan plan,
      ) async {
    if (plan.id == null) return;

    await DatabaseHelper.instance
        .deleteWorkoutPlan(
      plan.id!,
    );

    await loadPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Workout Plans',
        ),
      ),
      body: plans.isEmpty
          ? const Center(
        child: Text(
          'No workout plans yet. Tap + to add one.',
        ),
      )
          : ListView.builder(
        itemCount: plans.length,
        itemBuilder: (
            context,
            index,
            ) {
          final plan = plans[index];

          return ListTile(
            title: Text(
              plan.name,
            ),
            subtitle: Text(
              plan.goal,
            ),
            onTap: () =>
                openForm(
                  plan: plan,
                ),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
              ),
              onPressed: () =>
                  deletePlan(
                    plan,
                  ),
            ),
          );
        },
      ),
      floatingActionButton:
      FloatingActionButton(
        onPressed: () =>
            openForm(),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}