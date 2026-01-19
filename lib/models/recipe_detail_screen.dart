import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/Widget/my_icon_button.dart';

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
      // Handle error
    }
  }

  void toggleFavorite() async {
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in to save favorites")),
      );
      return;
    }

    setState(() => isFavorite = !isFavorite);

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('Favorites')
        .doc(widget.documentSnapshot.id);

    if (isFavorite) {
      // 🚨 FIX: Save 'ingredientsname', 'ingredientsamount', and 'Steps'
      Map<String, dynamic> data =
      widget.documentSnapshot.data() as Map<String, dynamic>;

      await ref.set({
        'image': data['image'] ?? '',
        'name': data['name'] ?? 'Unknown',
        'cal': data['cal'] ?? 0,
        'time': data['time'] ?? 0,
        'rating': data['rating'] ?? 0.0,
        'reviews': data['reviews'] ?? 0,
        // Save your specific fields
        'ingredientsname': data['ingredientsname'] ?? [],
        'ingredientsamount': data['ingredientsamount'] ?? [],
        'Steps': data['Steps'] ?? '',
      });
    } else {
      await ref.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ----------------------------------------------------------------
    // 1. EXTRACT DATA (Matching your Firestore Field Names)
    // ----------------------------------------------------------------
    final Map<String, dynamic> data =
        widget.documentSnapshot.data() as Map<String, dynamic>? ?? {};

    String image = data['image'] ?? '';
    String name = data['name'] ?? 'Unknown Recipe';
    String cal = (data['cal'] ?? 0).toString();
    String time = (data['time'] ?? 0).toString();
    String rating = (data['rating'] ?? "4.5").toString();
    String reviews = (data['reviews'] ?? "10").toString();

    // 2. Handle Ingredients Arrays
    List<dynamic> ingNames = data['ingredientsname'] ?? [];
    List<dynamic> ingAmounts = data['ingredientsamount'] ?? [];

    // 3. Handle Steps (Could be a String or a List in DB, handling both)
    List<String> stepsList = [];
    if (data['Steps'] is String) {
      // If it's one long string, split by new lines
      stepsList = (data['Steps'] as String).split('\n');
    } else if (data['Steps'] is List) {
      stepsList = List<String>.from(data['Steps']);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- Header Image ---
            Stack(
              children: [
                Hero(
                  tag: image,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.1,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: image.isNotEmpty
                            ? NetworkImage(image)
                            : const NetworkImage(
                            "https://via.placeholder.com/300"), // Fallback
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: MyIconButton(
                    icon: Icons.arrow_back_ios_new,
                    pressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 10,
                  child: MyIconButton(
                    icon: isFavorite ? Iconsax.heart5 : Iconsax.heart,
                    pressed: toggleFavorite,
                  ),
                )
              ],
            ),

            // --- Details Content ---
            Center(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Stats Row
                    Row(
                      children: [
                        const Icon(Iconsax.flash_1,
                            color: Colors.grey, size: 20),
                        Text(" $cal Cal",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        const Text(" . ",
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.grey)),
                        const Icon(Iconsax.clock, color: Colors.grey, size: 20),
                        Text(" $time Min",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Rating Row
                    Row(
                      children: [
                        const Icon(Iconsax.star1,
                            color: Colors.amber, size: 20),
                        Text(" $rating",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        Text(" ($reviews Reviews)",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // --- INGREDIENTS SECTION ---
                    const Text(
                      "Ingredients",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ingNames.isNotEmpty
                        ? ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ingNames.length,
                      itemBuilder: (context, index) {
                        // Safely get amount if it exists
                        String amount = index < ingAmounts.length
                            ? ingAmounts[index].toString()
                            : "";
                        String name = ingNames[index].toString();

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              const Icon(Icons.circle,
                                  size: 8, color: Colors.grey),
                              const SizedBox(width: 10),
                              Text(
                                "$amount $name", // Combines "1kg" + "Chicken"
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black87),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                        : const Text("No ingredients listed.",
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 20),

                    // --- STEPS SECTION ---
                    const Text(
                      "Steps",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    stepsList.isNotEmpty
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      List.generate(stepsList.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${index + 1}. ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.red)), // Step Number
                              Expanded(
                                child: Text(
                                  stepsList[index].trim(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      height: 1.5,
                                      color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    )
                        : const Text("No steps listed.",
                        style: TextStyle(color: Colors.grey)),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}