import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/Utils/constants.dart';

class RecipeDetailScreen extends StatefulWidget {
  final DocumentSnapshot<Object?> documentSnapshot;
  const RecipeDetailScreen({super.key, required this.documentSnapshot});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool isFavorite = false;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    checkFavoriteStatus();
  }

  // --- FAVORITE LOGIC (Matches your Home Screen) ---
  void checkFavoriteStatus() async {
    if (currentUser == null) return;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('Favorites')
          .doc(widget.documentSnapshot.id)
          .get();
      if (mounted) {
        setState(() => isFavorite = doc.exists);
      }
    } catch (e) {
      debugPrint("Error checking favorite: $e");
    }
  }

  void toggleFavorite() async {
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in to save favorites")),
      );
      return;
    }

    // Update UI immediately
    setState(() => isFavorite = !isFavorite);

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('Favorites')
        .doc(widget.documentSnapshot.id);

    if (isFavorite) {
      // Save all important data so it works offline in Favorites
      Map<String, dynamic> originalData =
      widget.documentSnapshot.data() as Map<String, dynamic>;

      await ref.set({
        'image': originalData['image'] ?? '',
        'name': originalData['name'] ?? 'Unknown',
        'cal': originalData['cal'] ?? 0,
        'time': originalData['time'] ?? 0,
        // Add more fields if you want them in the favorite list
      });
    } else {
      await ref.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🛡️ CRASH PROOF DATA EXTRACTION
    final Map<String, dynamic> data =
        widget.documentSnapshot.data() as Map<String, dynamic>? ?? {};

    String image = data['image'] ?? '';
    String name = data['name'] ?? 'Unknown Recipe';
    String cal = (data['cal'] ?? 0).toString();
    String time = (data['time'] ?? 0).toString();
    String rating = (data['rating'] ?? "4.5").toString();
    String reviews = (data['reviews'] ?? "120").toString();
    String description = data['description'] ??
        "No description provided for this recipe. Enjoy cooking!";

    // Handle Ingredients: supports both List and String formats
    List<String> ingredients = [];
    if (data['ingredients'] is List) {
      ingredients = List<String>.from(data['ingredients']);
    } else if (data['ingredients'] is String) {
      // If it's a single string, split by newlines or commas
      ingredients = (data['ingredients'] as String).split(RegExp(r'[\n,]'));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. SLIVER APP BAR (Scrolling Image Header)
          SliverAppBar(
            expandedHeight: 300,
            backgroundColor: Colors.white,
            pinned: true,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Iconsax.heart5 : Iconsax.heart,
                    color: isFavorite ? Colors.red : Colors.black,
                  ),
                  onPressed: toggleFavorite,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: image,
                child: image.isNotEmpty
                    ? Image.network(image, fit: BoxFit.cover)
                    : Container(color: Colors.grey.shade200),
              ),
            ),
          ),

          // 2. RECIPE CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Stats Row (Time, Cal, Rating)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatBadge(Iconsax.clock, "$time mins"),
                      _buildStatBadge(Iconsax.flash_1, "$cal Cal"),
                      _buildStatBadge(Iconsax.star1, "$rating ($reviews reviews)"),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Ingredients Section
                  const Text(
                    "Ingredients",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  ingredients.isNotEmpty
                      ? ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ingredients.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            const Icon(Icons.circle,
                                size: 8, color: kprimaryColor),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                ingredients[index].trim(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                      : const Text(
                    "No ingredients listed.",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 25),

                  // Description / Instructions
                  const Text(
                    "Instructions",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  // Extra space at bottom
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for the Stats Row
  Widget _buildStatBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: kprimaryColor),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}