import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/Utils/constants.dart'; //
import 'package:recipe_app/Widget/favorite_item_card.dart';//

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  // Reference to the collection
  final CollectionReference favoriteItems = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid) // Uses current User ID
      .collection('Favorites');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Favorites",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: favoriteItems.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // 1. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Data available but empty
          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.heart, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "No favorites yet!",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          // 3. Data available
          if (snapshot.hasData) {
            final List<DocumentSnapshot> recipes = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.all(15.0),
              // Using GridView to display favorites nicely
              child: GridView.builder(
                itemCount: recipes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.85, // Adjusts height of the card
                ),
                itemBuilder: (context, index) {
                  return FavoriteItemCard(
                    documentSnapshot: recipes[index],
                  );
                },
              ),
            );
          }

          // 4. Error State
          return const Center(child: Text("Something went wrong"));
        },
      ),
    );
  }
}