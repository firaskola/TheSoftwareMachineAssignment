import 'package:assignment/app/constants/constants.dart';
import 'package:assignment/app/constants/firebase_constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String? _race;
  String? _gender;
  DateTime? _birthdate;
  final List<String> _dietaryChoices = [];
  String? _allergies;

  // Dietary options
  final List<String> _dietaryOptions = [
    'Vegan',
    'Vegetarian',
    'Keto',
    'Halal',
    'Gluten-Free',
  ];

  // Save onboarding data to Firestore
  Future<void> _saveOnboardingData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Save onboarding data to Firestore
        await FirebaseFirestore.instance
            .collection(AppFirebaseConstants.userCollectionName)
            .doc(user.uid)
            .set({
          'race': _race,
          'gender': _gender,
          'birthdate': _birthdate,
          'dietaryChoices': _dietaryChoices,
          'allergies': _allergies,
        }, SetOptions(merge: true));

        // Navigate to Profile Page
        Navigator.pushReplacementNamed(context, '/profile');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        foregroundColor: kPrimaryLightColor,
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Race
              TextFormField(
                decoration: const InputDecoration(labelText: 'Race'),
                onSaved: (value) => _race = value,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your race' : null,
              ),
              const SizedBox(height: 16.0),

              // Gender
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Gender'),
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) => _gender = value,
                validator: (value) =>
                    value == null ? 'Please select your gender' : null,
              ),
              const SizedBox(height: 16.0),

              // Birthdate
              InkWell(
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate != null) {
                    setState(() => _birthdate = selectedDate);
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Birthdate'),
                  child: Text(
                    _birthdate != null
                        ? '${_birthdate!.toLocal()}'.split(' ')[0]
                        : 'Select your birthdate',
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Dietary Choices
              const Text('Dietary Choices'),
              ..._dietaryOptions.map((option) => CheckboxListTile(
                    title: Text(option),
                    value: _dietaryChoices.contains(option),
                    onChanged: (value) {
                      setState(() {
                        if (value!) {
                          _dietaryChoices.add(option);
                        } else {
                          _dietaryChoices.remove(option);
                        }
                      });
                    },
                  )),
              const SizedBox(height: 16.0),

              // Allergies
              TextFormField(
                decoration: const InputDecoration(labelText: 'Allergies'),
                onSaved: (value) => _allergies = value,
              ),
              const SizedBox(height: 24.0),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _saveOnboardingData,
                  child: const Text('Save and Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
