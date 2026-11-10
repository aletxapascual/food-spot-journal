import 'package:flutter/material.dart';
import 'screens/add_spot_screen.dart';
import 'screens/detail_screen.dart';
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
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/detail': (context) => const DetailScreen(),
        '/add': (context) => const AddSpotScreen(),
      },
    );
  }
}
