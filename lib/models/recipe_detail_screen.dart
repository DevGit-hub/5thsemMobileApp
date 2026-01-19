import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Auth
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
  // Get the current logged-in user
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // Check if this item is in the *user's* favorites
    checkFavoriteStatus();
  }

  // 1. Check Firestore (User-Specific)
  void checkFavoriteStatus() async {
    if (currentUser == null) return;

    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('Favorites')
        .doc(widget.documentSnapshot.id)
        .get();

    if (snapshot.exists) {
      if (mounted) {
        setState(() {
          isFavorite = true;
        });
      }
    }
  }

  // 2. Add or Remove from Firestore (User-Specific)
  void toggleFavorite() async {
    if (currentUser == null) {
      // Optional: Show a snackbar telling them to log in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in to save favorites")),
      );
      return;
    }

    final String docID = widget.documentSnapshot.id;
    final CollectionReference favoritesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('Favorites');

    setState(() {
      isFavorite = !isFavorite; // Immediate UI update
    });

    if (isFavorite) {
      // Add to User's Favorites
      await favoritesCollection.doc(docID).set({
        'image': widget.documentSnapshot['image'],
        'name': widget.documentSnapshot['name'],
        'cal': widget.documentSnapshot['cal'],
        'time': widget.documentSnapshot['time'],
      });
    } else {
      // Remove from User's Favorites
      await favoritesCollection.doc(docID).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Hero Image
                Hero(
                  tag: widget.documentSnapshot['image'],
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.1,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.documentSnapshot['image']),
                      ),
                    ),
                  ),
                ),
                // Back Button
                Positioned(
                  top: 40,
                  left: 10,
                  child: Row(
                    children: [
                      MyIconButton(
                        icon: Icons.arrow_back_ios_new,
                        pressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 40,
                  right: 10,
                  child: Row(
                    children: [
                      MyIconButton(
                        // Change icon based on state
                        icon: isFavorite ? Iconsax.heart5 : Iconsax.heart,
                        pressed: toggleFavorite,
                      ),
                    ],
                  ),
                )
              ],
            ),
            // Details Section
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
                    Text(
                      widget.documentSnapshot['name'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Iconsax.flash_1,
                            color: Colors.grey, size: 20),
                        Text(
                          " ${widget.documentSnapshot['cal']} Cal",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const Text(" . ",
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.grey)),
                        const Icon(Iconsax.clock, color: Colors.grey, size: 20),
                        Text(
                          " ${widget.documentSnapshot['time']} Min",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Example Rating Row
                    Row(
                      children: [
                        const Icon(Iconsax.star1,
                            color: Colors.amber, size: 20),
                        const Text(
                          " 4.5",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const Text(
                          " (25 Reviews)",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Description",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Enjoy cooking this delicious meal! Follow the steps carefully to get the best taste. (Add a 'description' field to your Firebase collection to display real instructions here).",
                      style: TextStyle(
                          color: Colors.grey, fontSize: 14, height: 1.5),
                    ),
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