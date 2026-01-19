import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/models/recipe_detail_screen.dart';

class FoodItemsDisplay extends StatefulWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const FoodItemsDisplay({super.key, required this.documentSnapshot});

  @override
  State<FoodItemsDisplay> createState() => _FoodItemsDisplayState();
}

class _FoodItemsDisplayState extends State<FoodItemsDisplay> {
  bool isFavorite = false;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // Check if this specific recipe is already in the user's Favorites
    checkFavoriteStatus();
  }

  void checkFavoriteStatus() async {
    if (currentUser == null) return;

    try {
      // Look in the 'Favorites' collection for this recipe ID
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('Favorites')
          .doc(widget.documentSnapshot.id)
          .get();

      // If the document exists, it means the user liked it
      if (mounted) {
        setState(() {
          isFavorite = doc.exists;
        });
      }
    } catch (e) {
      // Handle errors silently
    }
  }

  void toggleFavorite() async {
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in to manage favorites")),
      );
      return;
    }

    // 1. Update UI immediately (Optimistic UI)
    setState(() {
      isFavorite = !isFavorite;
    });

    final favRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('Favorites')
        .doc(widget.documentSnapshot.id);

    // 2. Update Firebase in the background
    if (isFavorite) {
      // Save the recipe details so it appears in the Favorite Screen
      final Map<String, dynamic> data =
          widget.documentSnapshot.data() as Map<String, dynamic>? ?? {};

      await favRef.set({
        'name': data['name'] ?? 'Unknown',
        'image': data['image'] ?? '',
        'cal': data['cal'] ?? 0,
        'time': data['time'] ?? 0,
        'rating': data['rating'] ?? 0.0,
      });
    } else {
      // Remove from favorites
      await favRef.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract data safely to prevent crashes
    final Map<String, dynamic> data =
        widget.documentSnapshot.data() as Map<String, dynamic>? ?? {};
    String name = data['name'] ?? 'Unknown';
    String image = data['image'] ?? '';
    String cal = (data['cal'] ?? 0).toString();
    String time = (data['time'] ?? 0).toString();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(
              documentSnapshot: widget.documentSnapshot,
            ),
          ),
        ).then((_) {
          // IMPORTANT: When you come back from the detail screen,
          // check again if the status changed!
          checkFavoriteStatus();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        width: 230,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Image Card
                Hero(
                  tag: image, // Unique tag for animation
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: image.isNotEmpty
                          ? DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(image),
                      )
                          : null,
                      color: Colors.grey.shade200, // Placeholder color
                    ),
                    child: image.isEmpty
                        ? const Icon(Icons.broken_image, color: Colors.grey)
                        : null,
                  ),
                ),
                const SizedBox(height: 10),

                // 2. Recipe Name
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),

                // 3. Info Row (Calories & Time)
                Row(
                  children: [
                    const Icon(Iconsax.flash_1, size: 16, color: Colors.grey),
                    Text(
                      " $cal Cal",
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text("  ·  ", style: TextStyle(color: Colors.grey)),
                    const Icon(Iconsax.clock, size: 16, color: Colors.grey),
                    Text(
                      " $time Min",
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),

            // 4. Favorite Button (The Heart Icon)
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: toggleFavorite,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(
                    isFavorite ? Iconsax.heart5 : Iconsax.heart, // Filled or Outline
                    color: isFavorite ? Colors.red : Colors.black, // Red or Black
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}