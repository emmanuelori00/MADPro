import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inclass_act7/main.dart';

// Seed boundary values through the existing State fields; elapsed time is the
// widget test's fake clock, so production timer durations remain unchanged.
dynamic petState(WidgetTester tester) => tester.state(find.byType(MyHomePage));
Future<void> tap(WidgetTester tester, String label) async {
  await tester.tap(find.widgetWithText(ElevatedButton, label));
  await tester.pump();
}

ElevatedButton button(WidgetTester tester, String label) =>
    tester.widget(find.widgetWithText(ElevatedButton, label));

void main() {
  testWidgets(
    'feed/play preserve balance and clamp meters; reset restores them',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      final dynamic state = petState(tester);
      await tap(tester, 'Feed');
      expect(state.hunger, 40);
      expect(state.happiness, 60);
      await tap(tester, 'Play');
      expect(state.hunger, 50);
      expect(state.happiness, 70);
      state.hunger = 5;
      await tap(tester, 'Feed');
      expect(state.hunger, 0);
      expect(state.happiness, 50);
      state.happiness = 95;
      state.hunger = 95;
      await tap(tester, 'Play');
      expect(state.happiness, 100);
      expect(state.hunger, 100);
      await tap(tester, 'Reset');
      expect(state.happiness, 50);
      expect(state.hunger, 50);
      expect(state.outcome, 'playing');
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets('95 to 100 has no penalty; overflow loses and freezes care', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    final dynamic state = petState(tester);
    state.hunger = 95;
    state.happiness = 30;
    await tester.pump(const Duration(seconds: 30));
    expect(state.hunger, 100);
    expect(state.happiness, 30);
    expect(state.outcome, 'playing');
    await tester.pump(const Duration(seconds: 30));
    expect(state.happiness, 10);
    expect(state.outcome, 'lost');
    expect(find.text('Game over'), findsOneWidget);
    expect(button(tester, 'Feed').onPressed, isNull);
    expect(button(tester, 'Play').onPressed, isNull);
    expect(button(tester, 'Reset').onPressed, isNotNull);
    state.feed();
    state.play();
    await tester.pump(const Duration(minutes: 5));
    expect(state.happiness, 10);
    expect(state.hunger, 100);
    await tap(tester, 'Reset');
    await tester.pump(const Duration(seconds: 30));
    expect(state.hunger, 55);
    expect(state.outcome, 'playing');
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('win occurs at three continuous minutes and stops hunger', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    final dynamic state = petState(tester);
    state.happiness = 80;
    state.hunger = 0;
    await tap(tester, 'Play');
    await tester.pump(const Duration(minutes: 2, seconds: 59));
    expect(state.outcome, 'playing');
    // A further care action above 80 must not restart the countdown.
    await tap(tester, 'Play');
    await tester.pump(const Duration(seconds: 1));
    expect(state.outcome, 'won');
    expect(find.text('You won!'), findsOneWidget);
    expect(button(tester, 'Feed').onPressed, isNull);
    expect(button(tester, 'Play').onPressed, isNull);
    final int hungerAtWin = state.hunger;
    await tester.pump(const Duration(minutes: 5));
    expect(state.hunger, hungerAtWin);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('exactly 80 cancels countdown; next crossing starts fresh', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    final dynamic state = petState(tester);
    state.happiness = 80;
    state.hunger = 0;
    await tap(tester, 'Play');
    await tester.pump(const Duration(minutes: 2, seconds: 59));
    state.happiness = 70;
    await tap(tester, 'Play'); // exactly 80 cancels the old timer
    await tester.pump(const Duration(seconds: 1));
    expect(state.outcome, 'playing');
    state.hunger = 0;
    await tap(tester, 'Play'); // 90 starts a fresh three minutes
    await tester.pump(const Duration(minutes: 2, seconds: 59));
    expect(state.outcome, 'playing');
    await tester.pump(const Duration(seconds: 1));
    expect(state.outcome, 'won');
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
    'reset cancels pending win and replaces hunger timer; dispose cleans up',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      final dynamic state = petState(tester);
      state.happiness = 80;
      state.hunger = 0;
      await tap(tester, 'Play');
      await tester.pump(const Duration(minutes: 2, seconds: 59));
      await tap(tester, 'Reset');
      await tap(tester, 'Reset');
      await tester.pump(const Duration(seconds: 1));
      expect(state.outcome, 'playing');
      expect(state.hunger, 50);
      await tester.pump(const Duration(seconds: 29));
      expect(state.hunger, 55); // one tick, not duplicate timers
      state.happiness = 80;
      state.hunger = 0;
      await tap(tester, 'Play');
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(minutes: 5));
      expect(tester.takeException(), isNull);
    },
  );
}
