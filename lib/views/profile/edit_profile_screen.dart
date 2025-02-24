import 'package:assignment/utils/custom_text_feild.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:assignment/app/constants/constants.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Form fields
  String? _race;
  String? _gender;
  DateTime? _birthdate;
  List<String> _dietaryChoices = [];
  String? _allergies;

  // Controllers
  final TextEditingController _raceController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();

  // Dietary options
  final List<String> _dietaryOptions = [
    'Vegan',
    'Vegetarian',
    'Keto',
    'Halal',
    'Gluten-Free',
  ];

  // Fetch existing user data
  Future<void> _fetchUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _race = userData['race'];
          _gender = userData['gender'];
          _birthdate = (userData['birthdate'] as Timestamp).toDate();
          _dietaryChoices = List<String>.from(userData['dietaryChoices'] ?? []);
          _allergies = userData['allergies'];

          // Set controller values
          _raceController.text = _race ?? '';
          _allergiesController.text = _allergies ?? '';
        });
      }
    }
  }

  // Save updated profile data to Firestore
  Future<void> _saveProfileData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'race': _race,
          'gender': _gender,
          'birthdate': _birthdate,
          'dietaryChoices': _dietaryChoices,
          'allergies': _allergies,
        }, SetOptions(merge: true));

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );

        // Navigate back to the profile page
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    _raceController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: kPrimaryLightColor,
        backgroundColor: kPrimaryColor,
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Race
              CustomTextField(
                hintText: 'Race',
                icon: Icons.people,
                controller: _raceController,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your race' : null,
                onSaved: (value) => _race = value,
              ),
              const SizedBox(height: defaultPadding),

              // Gender
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  prefixIcon: Icon(Icons.person),
                ),
                value: _gender,
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _gender = value),
                validator: (value) =>
                    value == null ? 'Please select your gender' : null,
              ),
              const SizedBox(height: defaultPadding),

              // Birthdate
              InkWell(
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _birthdate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate != null) {
                    setState(() => _birthdate = selectedDate);
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Birthdate',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _birthdate != null
                        ? '${_birthdate!.toLocal()}'.split(' ')[0]
                        : 'Select your birthdate',
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),

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
              const SizedBox(height: defaultPadding),

              // Allergies
              CustomTextField(
                hintText: 'Allergies',
                icon: Icons.health_and_safety,
                controller: _allergiesController,
                onSaved: (value) => _allergies = value,
              ),
              const SizedBox(height: defaultPadding * 2),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: _saveProfileData,
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
