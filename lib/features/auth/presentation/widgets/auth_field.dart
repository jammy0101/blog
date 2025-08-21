import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final bool obSecureText;
  final TextEditingController controller;
  const AuthField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obSecureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      validator: (value) {
        if (value!.isEmpty) {
          return "$hintText is missing";
        }
        return null;
      },
      obscureText: obSecureText,
    );
  }
}
