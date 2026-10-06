import 'dart:async';
import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Pet State',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Digital Pet'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  String petName = 'Buddy';
  int happiness = 50;
  int hunger = 50;
  String outcome = 'playing';
  final TextEditingController _nameController =
      TextEditingController(text: 'Buddy');
  String? _nameError;
  Timer? _hungerTimer;
  Timer? _winTimer;
  bool _restartDialogOpen = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Pet name',
                    errorText: _nameError,
                    border: const OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _confirmName(),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _confirmName,
                  child: const Text('Confirm name'),
                ),
                const SizedBox(height: 24),
                Text('$petName\nHappiness: $happiness\nHunger: $hunger'),
                Text(
                  outcome == 'won'
                      ? 'You won!'
                      : outcome == 'lost'
                          ? 'Game over'
                          : 'Keep caring for your pet',
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: outcome == 'playing' ? feed : null,
                  child: const Text('Feed'),
                ),
                ElevatedButton(
                  onPressed: outcome == 'playing' ? play : null,
                  child: const Text('Play'),
                ),
                ElevatedButton(
                  onPressed: reset,
                  child: const Text('Reset'),
                ),
                const SizedBox(height: 16),
                const Text('Session controls'),
                Text(
                  outcome == 'playing'
                      ? 'Session active'
                      : 'Session ended — restart to care for your pet again',
                ),
                OutlinedButton(
                  onPressed: _restartDialogOpen ? null : _confirmRestart,
                  child: const Text('Restart session'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _confirmName() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _nameError = 'Enter a pet name.';
      });
      return;
    }
setState(() {
  petName = name;
  _nameError = null;
  _nameController.text = name;
});
FocusScope.of(context).unfocus();
  }
  Future<void> _confirmRestart() async {
    if (_restartDialogOpen) return;
    setState(() {
      _restartDialogOpen = true;
    });
final confirmed = await showDialog<bool>(
  context: context,
  builder: (dialogContext) {
    return AlertDialog(
      title: const Text('Restart session?'),
      content: const Text(
        'Happiness and hunger will return to 50. '
        'The current outcome and win countdown will reset. '
        'Your confirmed pet name will stay the same.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Restart'),
        ),
      ],
    );
  },
);

if (!mounted) return;
setState(() {
  _restartDialogOpen = false;
});
if (confirmed == true) reset();
  }
  void feed() {
    if (outcome != 'playing') return;
    setState(() {
      hunger = (hunger - 10).clamp(0, 100).toInt();
      happiness =
          (happiness + (hunger < 30 ? -20 : 10)).clamp(0, 100).toInt();
      _checkOutcome();
    });
  }
  void play() {
    if (outcome != 'playing') return;
    setState(() {
      happiness = (happiness + 10).clamp(0, 100).toInt();
      hunger = (hunger + 10).clamp(0, 100).toInt();
      _checkOutcome();
    });
  }
  void _checkOutcome() {
    if (outcome != 'playing') return;
if (hunger == 100 && happiness <= 10) {
  outcome = 'lost';
  _cancelTimers();
  return;
}

if (happiness <= 80) {
  _winTimer?.cancel();
  _winTimer = null;
  return;
}

// Keep the existing countdown while happiness remains above 80.
_winTimer ??= Timer(const Duration(minutes: 3), () {
  _winTimer = null;
  if (!mounted || outcome != 'playing' || happiness <= 80) return;
  setState(() {
    outcome = 'won';
    _cancelTimers();
  });
});
  }
  void _cancelTimers() {
    _hungerTimer?.cancel();
    _hungerTimer = null;
    _winTimer?.cancel();
    _winTimer = null;
  }
  void reset() {
    _cancelTimers();
    setState(() {
      happiness = 50;
      hunger = 50;
      outcome = 'playing';
    });
    startHungerTimer();
  }
  void startHungerTimer() {
    _hungerTimer?.cancel();
    _hungerTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!mounted || outcome != 'playing') {
        timer.cancel();
        return;
      }
      setState(() {
        final nextHunger = hunger + 5;
        if (nextHunger > 100) {
          happiness = (happiness - 20).clamp(0, 100).toInt();
        }
        hunger = nextHunger.clamp(0, 100).toInt();
        _checkOutcome();
      });
    });
  }
  @override
  void initState() {
    super.initState();
    startHungerTimer();
  }
  @override
  void dispose() {
    _cancelTimers();
    _nameController.dispose();
    super.dispose();
  }
}