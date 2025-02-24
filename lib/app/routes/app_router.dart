import 'package:assignment/views/auth/ForgotPassword/forgot_password_screen.dart';
import 'package:assignment/views/auth/Login/login_screen.dart';
import 'package:assignment/views/auth/Signup/signup_screen.dart';
import 'package:assignment/views/auth/Welcome/welcome_screen.dart';
import 'package:assignment/views/onboarding/onboarding_screen.dart';
import 'package:assignment/views/profile/edit_profile_screen.dart';
import 'package:assignment/views/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case AppRoutes.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
          settings: settings,
          fullscreenDialog: true,
        );
      case AppRoutes.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found!')),
          ),
        );
    }
  }
}
