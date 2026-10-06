import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Pet State',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Digital Pet'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String petName = 'Buddy';
  int happiness = 50;
  int hunger = 50;
  String outcome = 'playing';
  Timer? _hungerTimer;
  Timer? _winTimer;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            Text('$petName\nHappiness: $happiness\nHunger: $hunger'),
            Text(
              outcome == 'won'
                  ? 'You won!'
                  : outcome == 'lost'
                  ? 'Game over'
                  : 'Keep caring for your pet',
            ),
            ElevatedButton(
              onPressed: outcome == 'playing' ? feed : null,
              child: const Text('Feed'),
            ),
            ElevatedButton(
              onPressed: outcome == 'playing' ? play : null,
              child: const Text('Play'),
            ),
            ElevatedButton(onPressed: reset, child: const Text('Reset')),
          ],
        ),
      ),
    );
  }

  void feed() {
    if (outcome != 'playing') return;
    setState(() {
      hunger = (hunger - 10).clamp(0, 100).toInt();
      happiness = (happiness + (hunger < 30 ? -20 : 10)).clamp(0, 100).toInt();
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

  // Called inside each action/tick's state update so related changes rebuild together.
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
    // Do not restart an existing countdown while happiness stays above 80.
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
    super.dispose();
  }
}
