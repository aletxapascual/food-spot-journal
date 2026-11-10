import 'package:flutter/material.dart';
import '../models/food_spot.dart';
import '../widgets/food_spot_map.dart';
import '../widgets/spot_image.dart';

/// Shows every detail of one food spot received through route arguments.
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FoodSpot spot = ModalRoute.of(context)!.settings.arguments as FoodSpot;
    final bool hasLocation = spot.latitude != null && spot.longitude != null;

    return Scaffold(
      appBar: AppBar(title: Text(spot.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'spot-image-${spot.id}',
            child: SpotImage(imagePath: spot.imagePath, height: 220),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spot.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('Saved on ${spot.createdAt.substring(0, 10)}'),
                  if (hasLocation)
                    Text(
                      'Lat ${spot.latitude!.toStringAsFixed(5)}, '
                      'Lng ${spot.longitude!.toStringAsFixed(5)}',
                    ),
                  const SizedBox(height: 16),
                  Text(spot.review, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 260,
            child: hasLocation
                ? FoodSpotMap(latitude: spot.latitude!, longitude: spot.longitude!)
                : Container(
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Text('No location saved for this spot.'),
                  ),
          ),
        ],
      ),
    );
  }
}
