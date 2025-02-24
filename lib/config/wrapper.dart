import 'package:assignment/app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  // Check if onboarding is completed
  Future<bool> _isOnboardingCompleted(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return userDoc.exists && userDoc.data() != null;
    } catch (e) {
      print('Error checking onboarding status: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData) {
          final User user = snapshot.data!;

          Future.microtask(() async {
            bool isOnboardingCompleted = await _isOnboardingCompleted(user.uid);

            if (isOnboardingCompleted) {
              print('Navigating to: ${AppRoutes.profile}');
              Navigator.pushReplacementNamed(context, AppRoutes.profile);
            } else {
              print('Navigating to: ${AppRoutes.onboarding}');
              Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
            }
          });

          return const SizedBox();
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            print('Navigating to: ${AppRoutes.welcome}');
            Navigator.pushReplacementNamed(context, AppRoutes.welcome);
          });
          return const SizedBox();
        }
      },
    );
  }
}
