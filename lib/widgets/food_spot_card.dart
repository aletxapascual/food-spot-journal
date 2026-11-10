import 'package:flutter/material.dart';
import '../models/food_spot.dart';
import 'spot_image.dart';

/// List item for one food spot. The photo is wrapped in a Hero
/// so it flies to the detail screen.
class FoodSpotCard extends StatelessWidget {
  final FoodSpot spot;
  final VoidCallback onTap;

  const FoodSpotCard({super.key, required this.spot, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'spot-image-${spot.id}',
              child: SpotImage(imagePath: spot.imagePath, height: 140),
            ),
            ListTile(
              title: Text(
                spot.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                spot.review,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
