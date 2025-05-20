import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hint;
  final bool obscureText;
  final bool readOnly;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final IconData? prefixIconData; // New parameter for icon data
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int? maxLines;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    this.controller,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType,
    this.prefixIcon,
    this.prefixIconData, // Add to constructor
    this.suffixIcon,
    this.validator,
    this.maxLines = 1,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        prefixIcon: prefixIcon ?? (prefixIconData != null ? Icon(prefixIconData) : null),
        suffixIcon: suffixIcon,
      ),
      validator: validator,
    );
  }
}