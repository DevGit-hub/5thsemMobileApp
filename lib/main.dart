import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipe_app/auth/login_screen.dart'; // Import Login Screen
import 'package:recipe_app/models/app_main_screen.dart'; // Import Main Screen
import 'package:recipe_app/services/auth_service.dart'; // Import Auth Service

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the 'Debug' banner
      title: 'Recipe App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // StreamBuilder listens to the user's login state live
      home: StreamBuilder(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          // 1. Waiting for Firebase to check connection
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. User is Logged In -> Go to Home Screen
          if (snapshot.hasData) {
            return const AppMainScreen();
          }

          // 3. User is Logged Out -> Go to Login Screen
          return const LoginScreen();
        },
      ),
    );
  }
}