import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  const CustomTextInput({
    Key? key,
    required this.textEditingController,
    required this.hint,
    this.obscureText = false,
    required this.inputType,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final String hint;
  final bool obscureText;
  final TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hint,
        border: _getBorder(context),
        focusedBorder: _getBorder(context),
        enabledBorder: _getBorder(context),
        filled: true,
        contentPadding: const EdgeInsets.all(8),
      ),
      keyboardType: inputType,
      obscureText: obscureText,
    );
  }

  OutlineInputBorder _getBorder(BuildContext context) {
    return OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
  }
}
