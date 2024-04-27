import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onSuffixIconPressed;

  const CustomTextField({
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.onSuffixIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: const Color.fromARGB(255, 130, 130, 130)),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: () {
                  onSuffixIconPressed!();
                }, // Call the callback when pressed
              )
            : null,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(10.0), // Adjust the radius as needed
          borderSide: BorderSide(
              color:
                  const Color.fromARGB(255, 0, 0, 0)), // Set white border color
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(10.0), // Adjust the radius as needed
          borderSide: BorderSide(
              color:
                  const Color.fromARGB(255, 0, 0, 0)), // Set white border color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(10.0), // Adjust the radius as needed
          borderSide: BorderSide(
              color:
                  const Color.fromARGB(255, 0, 0, 0)), // Set white border color
        ),
        // You can customize more properties as needed
      ),
    );
  }
}
