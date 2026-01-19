import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/models/recipe_detail_screen.dart'; // Ensure this import is correct

class FavoriteItemCard extends StatelessWidget {
  final DocumentSnapshot<Object?> documentSnapshot;

  const FavoriteItemCard({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    // 1. DATA SAFETY: Get data with fallback values to prevent crashes
    final data = documentSnapshot.data() as Map<String, dynamic>?;
    final String image = data?['image'] ?? '';
    final String name = data?['name'] ?? 'Unknown';
    final String cal = data?['cal']?.toString() ?? '0';
    final String time = data?['time']?.toString() ?? '0';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(documentSnapshot: documentSnapshot),
          ),
        );
      },
      child: Container(
        // REMOVED: width: 230 and margin
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Image Section
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  image: image.isNotEmpty
                      ? DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(image),
                  )
                      : null,
                ),
                child: image.isEmpty
                    ? const Icon(Icons.image_not_supported, color: Colors.grey)
                    : null,
              ),
            ),

            // Text Details Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15, // Slightly smaller font for grid
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Iconsax.flash_1, size: 14, color: Colors.grey),
                      Text(
                        " $cal Cal",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                      const Text(" · ", style: TextStyle(color: Colors.grey)),
                      const Icon(Iconsax.clock, size: 14, color: Colors.grey),
                      Text(
                        " $time Min",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}