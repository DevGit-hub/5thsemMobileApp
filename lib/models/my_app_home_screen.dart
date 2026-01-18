import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/Utils/constants.dart';
import 'package:recipe_app/Widget/banner.dart';
import 'package:recipe_app/Widget/food_items_display.dart';
import 'package:recipe_app/Widget/my_icon_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAppHomeScreen extends StatefulWidget {
  const MyAppHomeScreen({super.key});

  @override
  State<MyAppHomeScreen> createState() => _MyAppHomeScreenState();
}

class _MyAppHomeScreenState extends State<MyAppHomeScreen> {
  String category = "All";
    //for category

  final CollectionReference categoriesItems = FirebaseFirestore.instance.collection('App-Category');
  //for all items desplay
  Query get fileteredRecipes => FirebaseFirestore.instance.collection("Complete-Flutter-App").where('category', isEqualTo: category,);
  Query get allRecipes => FirebaseFirestore.instance.collection("Complete-Flutter-App");
  Query get selectedRecipes=> category == "All" ? allRecipes : fileteredRecipes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
               child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                headerParts(),
                mySearchBar(),
                //for banner
                const BannerToExplore(),
                Padding(padding: EdgeInsets.symmetric(vertical: 20),child: Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    ),
                    ),
                    ),
              //for category
              selectedCategory(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [ const Text(
                  "Quick & Easy",
                  style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 0.1,
                   fontWeight: FontWeight.bold,
                   ),
                   ),
                   TextButton(
                    onPressed: (){
                      // we have make it function later
                    },
                    child: const Text(
                      "View all",
                      style: TextStyle(
                        color: kBannerColor,
                        fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ],
                    ),
               
                  ],
                )
              ),
              StreamBuilder(
              stream: selectedRecipes.snapshots(),
             builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                final List <DocumentSnapshot> recipes = snapshot.data?.docs ?? [];
                return Padding(
                  padding: EdgeInsets.only(top: 5,left: 15),
                child :SingleChildScrollView(
                  child:Row(
                    children: recipes
                    .map((e) => FoodItemsDisplay(documentSnapshot: e))
                    .toList(),
                  ),
                  ),
                );
               }
                //it means if snapshothas the data then show the date otherwise show the prograss bar
              return Center(child: CircularProgressIndicator(),);
             },
             )
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> selectedCategory() {
    return StreamBuilder(
              stream: categoriesItems.snapshots(),
             builder: (context, AsyncSnapshot<QuerySnapshot> steamSnapshot) {
              if (steamSnapshot.hasData) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:List.generate (
                      steamSnapshot.data!.docs.length,
                      (index)=> GestureDetector(
                    onTap: () {
                      setState(() {
                         
                        category ==
                       steamSnapshot.data!.docs[index]
                        ["name"];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: category ==
                       steamSnapshot.data!.docs[index]
                        ['name']
                        ? kprimaryColor : Colors.white,
                    ),//BoxDecoration
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                       vertical: 10
                       ),
                    margin: EdgeInsets.only(right: 20),
                    child: Text(
                      steamSnapshot.data!.docs[index]['name'],
                      style: TextStyle (
                        color: category ==
                       steamSnapshot.data!.docs[index]
                               ['name']
                        ? Colors.white
                        :Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                      ),
                      ),
                    ),

                  ),
                   ),
                  ),
                  );

                
                }
                //it means if snapshothas the data then show the date otherwise show the prograss bar
              return Center(child: CircularProgressIndicator(),);
             },
             );
  }

  Padding mySearchBar() {
    return Padding(padding: EdgeInsets.symmetric(vertical: 22),
               child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  prefixIcon:const Icon( Iconsax.search_normal,),
                  fillColor: Colors.white,
                  border: InputBorder.none,
                  hintText: "Search any recipes",
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
               ),
              );
  }

  Row headerParts() {
    return Row(
                children: [
              const  Text(
                "What are you\n cooking today?",
                 style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1,
                  ),
                ),
                const Spacer(),
                MyIconButton(
                 icon: Iconsax.notification ,
                 pressed: (){},
                )
              ],
              );
  }
}