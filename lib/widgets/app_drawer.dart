import 'package:flutter/material.dart';

/// Side menu of the app, kept in its own widget (SRP).
class AppDrawer extends StatelessWidget {
  final VoidCallback onAddSpot;

  const AppDrawer({super.key, required this.onAddSpot});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            child: Center(
              child: Text(
                'Food Spot Journal',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text('My food spots'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.add_a_photo),
                  title: const Text('New food spot'),
                  onTap: () {
                    Navigator.pop(context);
                    onAddSpot();
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Version 1.0.0'),
          ),
        ],
      ),
    );
  }
}
