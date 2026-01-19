import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/Utils/constants.dart';
import 'package:recipe_app/auth/signup_screen.dart';
import 'package:recipe_app/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    String? res = await _authService.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    setState(() => _isLoading = false);

    if (res != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          // ========== BACKGROUND IMAGE - PUT YOUR IMAGE PATH HERE ==========
          // For Asset Image (RECOMMENDED):
          // Step 1: Add image to assets/images/background.jpg
          // Step 2: Update pubspec.yaml to include assets/images/
          // Step 3: Uncomment below line and comment the gradient

          image: DecorationImage(
            image: AssetImage('assets/images/background.jpeg'), // 👈 PUT YOUR IMAGE HERE
            fit: BoxFit.cover,
          ),

          // For now, using gradient (will always show):
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              kprimaryColor,
              kprimaryColor.withOpacity(0.8),
              Color(0xFF2A5298),
            ],
          ),
        ),
        child: Container(
          // Dark overlay for better text visibility
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),

                      // App Logo
                      // App Logo
Container(
  height: 110,
  width: 110,
  decoration: BoxDecoration(
    color: Colors.white,
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: Colors.white.withOpacity(0.4),
        blurRadius: 25,
        spreadRadius: 8,
      ),
    ],
  ),
  child: Center(
    child: ClipOval(
      child: Image.asset(
        'assets/images/logo.png', // 👈 PUT YOUR LOGO IMAGE PATH HERE
        height: 70,
        width: 70,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Fallback icon if image fails to load
          return Icon(
            Iconsax.cake5,
            size: 55,
            color: kprimaryColor,
          );
        },
      ),
    ),
  ),
),
                      const SizedBox(height: 20),

                      // App Name
                      const Text(
                        "Chef's Recipe",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.8,
                          shadows: [
                            Shadow(
                              color: Colors.black54,
                              offset: Offset(2, 2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Cook with passion",
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          letterSpacing: 1.3,
                          fontWeight: FontWeight.w300,
                          shadows: [
                            Shadow(
                              color: Colors.black38,
                              offset: Offset(1, 1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 50),

                      // Login Form Container
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Welcome Back!",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Login to continue cooking",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Email Field
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                    width: 1.5,
                                  ),
                                ),
                                child: TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(fontSize: 15),
                                  decoration: const InputDecoration(
                                    hintText: "Email Address",
                                    hintStyle: TextStyle(fontSize: 15),
                                    prefixIcon: Icon(Iconsax.sms,
                                        color: kprimaryColor, size: 22),
                                    border: InputBorder.none,
                                    contentPadding:
                                    EdgeInsets.symmetric(vertical: 18),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),

                              // Password Field
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                    width: 1.5,
                                  ),
                                ),
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  style: const TextStyle(fontSize: 15),
                                  decoration: const InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(fontSize: 15),
                                    prefixIcon: Icon(Iconsax.lock,
                                        color: kprimaryColor, size: 22),
                                    border: InputBorder.none,
                                    contentPadding:
                                    EdgeInsets.symmetric(vertical: 18),
                                  ),
                                ),
                              ),

                              // Forgot Password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      color: kprimaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Login Button
                              SizedBox(
                                width: double.infinity,
                                height: 58,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kprimaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 5,
                                    shadowColor:
                                    kprimaryColor.withOpacity(0.5),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                      : const Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),

                              // Signup Link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                          const SignUpScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        color: kprimaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(flex: 2),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}