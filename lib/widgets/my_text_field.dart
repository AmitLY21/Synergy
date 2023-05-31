import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool isSecured; // Flag for making the text field secured or not

  const MyTextField({
    Key? key,
    required this.hint,
    required this.controller,
    this.isSecured = false, // Default value is false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: TextField(
        controller: controller,
        obscureText: isSecured, // Set the obscureText property based on the flag
        decoration: InputDecoration(
          hintText: hint,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
      ),
    );
  }
}
