import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/food_spot.dart';

/// Main screen: lists every saved food spot.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<FoodSpot>> _spotsFuture;

  @override
  void initState() {
    super.initState();
    _spotsFuture = DatabaseHelper.instance.getSpots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Spot Journal')),
      body: FutureBuilder<List<FoodSpot>>(
        future: _spotsFuture,
        builder: (BuildContext context, AsyncSnapshot<List<FoodSpot>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Center(child: Text('Nothing to load.'));

            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(child: CircularProgressIndicator());

            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text('Error loading spots: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final spots = snapshot.data!;
                return ListView.builder(
                  itemCount: spots.length,
                  itemBuilder: (context, index) {
                    final spot = spots[index];
                    return ListTile(
                      title: Text(spot.name),
                      subtitle: Text(spot.review),
                    );
                  },
                );
              } else {
                return const Center(child: Text('No food spots yet.'));
              }
          }
        },
      ),
    );
  }
}
