import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/models/recipe_detail_screen.dart';

class FoodItemsDisplay extends StatelessWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const FoodItemsDisplay({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------------------------
    // 🛡️ CRASH PROOFING SECTION
    // -------------------------------------------------------------------------
    // 1. Get the data safely as a Map. If null, use an empty map.
    final Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>? ?? {};

    // 2. Extract fields with Default Values (fixes "field does not exist")
    // 3. Use .toString() on numbers (fixes "int is not subtype of String")

    String name = data['name'] ?? 'Unknown Recipe';
    String image = data['image'] ?? '';
    String cal = (data['cal'] ?? 0).toString();
    String time = (data['time'] ?? 0).toString();
    // -------------------------------------------------------------------------

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
        margin: const EdgeInsets.only(right: 10),
        width: 230,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Hero(
                  tag: image, // Using image URL as tag to avoid duplicates
                  child: Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade200, // Placeholder color
                      image: image.isNotEmpty
                          ? DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(image),
                      )
                          : null,
                    ),
                    // Show icon if no image available
                    child: image.isEmpty
                        ? const Icon(Icons.image_not_supported, color: Colors.grey)
                        : null,
                  ),
                ),
                const SizedBox(height: 10),

                // Name
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, // Prevents text overflow error
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),

                // Stats Row
                Row(
                  children: [
                    const Icon(Iconsax.flash_1, size: 16, color: Colors.grey),
                    Text(
                      " $cal Cal",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      " · ",
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.grey,
                      ),
                    ),
                    const Icon(Iconsax.clock, size: 16, color: Colors.grey),
                    Text(
                      " $time Min",
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

            // Favorite Heart Icon Overlay
            Positioned(
              top: 5,
              right: 5,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: InkWell(
                  onTap: () {
                    // Quick favorite toggle logic can go here
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