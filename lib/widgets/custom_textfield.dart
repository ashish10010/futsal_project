import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData leadingIcon;
  final bool isPassword;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.leadingIcon,
    this.isPassword = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(leadingIcon),
        hintText: hintText,
      ),
    );
  }
}
