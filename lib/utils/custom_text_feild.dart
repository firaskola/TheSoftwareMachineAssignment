import 'package:assignment/app/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
      child: TextFormField(
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        cursorColor: kPrimaryColor,
        obscureText: obscureText,
        controller: controller,
        validator: validator,
        onSaved: onSaved,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Icon(icon),
          ),
        ),
      ),
    );
  }
}
