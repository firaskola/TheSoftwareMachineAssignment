
import 'package:assignment/app/constants/constants.dart';
import 'package:assignment/app/constants/firebase_constants.dart';
import 'package:assignment/app/services/auth_services.dart';
import 'package:assignment/config/models/response_model.dart';
import 'package:assignment/utils/custom_text_feild.dart';
import 'package:assignment/utils/custom_widgets.dart';
import 'package:assignment/views/auth/components/already_have_an_account_acheck.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _submitForm() async {
  if (!_formKey.currentState!.validate()) return;

  String email = _emailController.text.trim();
  String password = _passwordController.text.trim();

  AuthService authService = AuthService();
  ResponseModel response =
      await authService.signInUser(email: email, password: password);

  if (response.status) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.message)),
    );

    // Check if onboarding data exists
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(AppFirebaseConstants.userCollectionName)
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        if (userData.containsKey('race') &&
            userData.containsKey('gender') &&
            userData.containsKey('birthdate')) {
          // Onboarding data exists, go to profile
          Navigator.pushReplacementNamed(context, '/profile');
        } else {
          // Onboarding data does not exist, go to onboarding
          Navigator.pushReplacementNamed(context, '/onboarding');
        }
      }
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.message)),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            hintText: "Your Email",
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            validator: AppCustomWidgets.validateEmail,
          ),
          CustomTextField(
            hintText: "Your Password",
            icon: Icons.lock,
            obscureText: true,
            controller: _passwordController,
            validator: AppCustomWidgets.validatePassword,
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/forgot-password');
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                "Forgot Password?",
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text(
              "Login".toUpperCase(),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.pushNamed(context, '/signup');
            },
          ),
        ],
      ),
    );
  }
}
