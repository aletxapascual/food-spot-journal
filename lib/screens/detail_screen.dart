import 'package:flutter/material.dart';
import '../models/food_spot.dart';
import '../widgets/spot_image.dart';

/// Shows every detail of one food spot received through route arguments.
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FoodSpot spot = ModalRoute.of(context)!.settings.arguments as FoodSpot;

    return Scaffold(
      appBar: AppBar(title: Text(spot.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'spot-image-${spot.id}',
              child: SpotImage(imagePath: spot.imagePath, height: 250),
            ),
            Padding(
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
                  const SizedBox(height: 16),
                  Text(spot.review, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
