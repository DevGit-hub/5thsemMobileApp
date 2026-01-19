import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/Utils/constants.dart';
import 'package:recipe_app/Widget/food_items_display.dart';

class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  // Simple list for days of the week
  final List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  int selectedDayIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Meal Plan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Day Selector (Horizontal List)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(days.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDayIndex = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          left: index == 0 ? 15 : 10,
                          right: index == days.length - 1 ? 15 : 0,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: selectedDayIndex == index
                              ? kprimaryColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: selectedDayIndex == index
                              ? [
                            BoxShadow(
                              color: kprimaryColor.withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            )
                          ]
                              : [],
                        ),
                        child: Text(
                          days[index],
                          style: TextStyle(
                            color: selectedDayIndex == index
                                ? Colors.white
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // 2. Meal Sections
            // We pass the category name to filter recipes from Firebase
            buildMealSection("Breakfast"),
            buildMealSection("Lunch"),
            buildMealSection("Dinner"),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper Widget to build each section
  Widget buildMealSection(String mealType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mealType,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Select",
                style: TextStyle(
                  color: kprimaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        // Fetch recipes for this specific category (e.g., "Breakfast")
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Complete-Flutter-App")
              .where('category', isEqualTo: mealType) // Filtering by category
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              // Fallback UI if no items found for this meal type
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Text(
                    "No items added yet",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }

            final List<DocumentSnapshot> recipes = snapshot.data!.docs;

            return SizedBox(
              height: 240, // Height for the horizontal list
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 15),
                scrollDirection: Axis.horizontal,
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  return FoodItemsDisplay(documentSnapshot: recipes[index]);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}