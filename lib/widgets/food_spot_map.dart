import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Interactive OpenStreetMap with a marker on the food spot location.
class FoodSpotMap extends StatelessWidget {
  final double latitude;
  final double longitude;

  const FoodSpotMap({super.key, required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    final LatLng spotPosition = LatLng(latitude, longitude);

    return FlutterMap(
      options: MapOptions(
        initialCenter: spotPosition,
        initialZoom: 16,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.food_spot_journal',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: spotPosition,
              width: 40,
              height: 40,
              child: const Icon(Icons.location_on, color: Colors.red, size: 40),
            ),
          ],
        ),
        const SimpleAttributionWidget(
          source: Text('OpenStreetMap contributors'),
        ),
      ],
    );
  }
}
