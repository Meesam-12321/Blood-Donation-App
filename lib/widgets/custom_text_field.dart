import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType; // Ensure this is required
  final bool obscureText;
  final String? Function(String?) validator;
  final TextStyle? style; // Add this line

  CustomTextField({
    required this.label,
    required this.controller,
    required this.keyboardType, // Ensure this is required
    this.obscureText = false,
    required this.validator,
    this.style, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: style, // Add this line
      decoration: InputDecoration(
        labelText: label,
        labelStyle: style, // Add this line
        border: OutlineInputBorder(),
      ),
    );
  }
}
