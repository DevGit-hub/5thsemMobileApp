import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream to listen to auth changes (Logged In vs Logged Out)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign Up
  Future<String?> signUp({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message
    }
  }

  // Sign In
  Future<String?> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}