import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/food_spot.dart';
import '../widgets/app_drawer.dart';
import '../widgets/food_spot_card.dart';

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

  void _refresh() {
    setState(() {
      _spotsFuture = DatabaseHelper.instance.getSpots();
    });
  }

  /// Opens the form and reloads the list if a spot was saved.
  Future<void> _openAddForm() async {
    final saved = await Navigator.pushNamed(context, '/add');
    if (saved == true) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Spot Journal')),
      drawer: AppDrawer(onAddSpot: _openAddForm),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddForm,
        tooltip: 'New food spot',
        child: const Icon(Icons.add),
      ),
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
                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: spots.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final spot = spots[index];
                    return FoodSpotCard(
                      spot: spot,
                      onTap: () => Navigator.pushNamed(context, '/detail', arguments: spot),
                    );
                  },
                );
              } else {
                return const Center(child: Text('No food spots yet. Tap + to add one.'));
              }
          }
        },
      ),
    );
  }
}
