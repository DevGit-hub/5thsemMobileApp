import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/Utils/constants.dart';
import 'package:recipe_app/Widget/favorite_item_card.dart'; // We can reuse the responsive card from Favorites

class ViewAllScreen extends StatefulWidget {
  final String selectedCategory;
  const ViewAllScreen({super.key, required this.selectedCategory});

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  // Logic to get the correct stream based on category
  Query get recipeQuery {
    CollectionReference collection =
    FirebaseFirestore.instance.collection("Complete-Flutter-App");

    if (widget.selectedCategory == "All") {
      return collection;
    } else {
      return collection.where('category', isEqualTo: widget.selectedCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "${widget.selectedCategory} Recipes",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: recipeQuery.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final List<DocumentSnapshot> recipes = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: GridView.builder(
                itemCount: recipes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.8, // Adjust for card height
                ),
                itemBuilder: (context, index) {
                  // Using the responsive card we created earlier
                  return FavoriteItemCard(documentSnapshot: recipes[index]);
                },
              ),
            );
          }

          return const Center(
            child: Text("No recipes found in this category."),
          );
        },
      ),
    );
  }
}