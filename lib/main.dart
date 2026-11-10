import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FoodSpotJournalApp());
}

/// Root widget of the app.
class FoodSpotJournalApp extends StatelessWidget {
  const FoodSpotJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Spot Journal',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange)),
      home: const HomeScreen(),
    );
  }
}
