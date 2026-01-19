import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/models/recipe_detail_screen.dart'; // Import the new screen

class FoodItemsDisplay extends StatelessWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const FoodItemsDisplay({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // NAVIGATE TO DETAIL SCREEN
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(documentSnapshot: documentSnapshot),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        width: 230,
        child: Stack(
          children: [
            Column(
              children: [
                Hero(
                  tag: documentSnapshot['image'], // Tag must match the one in Detail Screen
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(documentSnapshot['image']), //
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  documentSnapshot['name'], //
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Iconsax.flash_1, size: 16, color: Colors.grey),
                    Text(
                      " ${documentSnapshot['cal']} Cal", //
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      ". ",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.grey,
                      ),
                    ),
                    const Icon(Iconsax.clock, size: 16, color: Colors.grey),
                    Text(
                      " ${documentSnapshot['time']} Min", //
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Floating Favorite Button on the card
            Positioned(
              top: 5,
              right: 5,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: InkWell(
                  onTap: () {
                    // Add logic to toggle favorite
                  },
                  child: const Icon(Iconsax.heart, color: Colors.black, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}