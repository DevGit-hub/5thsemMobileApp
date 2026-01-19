import 'package:flutter/material.dart';
import 'package:recipe_app/Utils/constants.dart';

class BannerToExplore extends StatelessWidget {
  const BannerToExplore({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180, // Set a fixed height for the banner
      // 1. ADD DECORATION FOR IMAGE
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // This loads your image as the background
        image: DecorationImage(
          image: const AssetImage('assets/images/homeimage.jpg'),
          fit: BoxFit.cover,
          // Optional: Adds a dark layer so white text pops out
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      // 2. KEEP YOUR TEXT INSIDE
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- YOUR TEXT STAYS HERE ---
            // I changed color to white for better contrast against image
            const Text(
              "Cook the best\nrecipes at home",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 15),
            // Example Button (You can keep your existing one if different)
            InkWell(
              onTap: () {
                // Add explore action here
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: kprimaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "Explore Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // ---------------------------
          ],
        ),
      ),
    );
  }
}