import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyBoardType;
  final List<TextInputFormatter>? inputFormatter;
  final Color colorText;
  final Color colorLabel;
  final Color colorIcon;
  final Color colorBorder;
  final Color colorBorderSide;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    required this.colorText,
    required this.colorLabel,
    required this.colorIcon,
    required this.colorBorder,
    required this.colorBorderSide,
    this.keyBoardType = TextInputType.text,
    this.inputFormatter,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: colorText),
      decoration: InputDecoration(
        labelText: label,
        labelStyle:  TextStyle(color: colorLabel),
        prefixIcon: Icon(icon, color: colorIcon,),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorBorderSide),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:   BorderSide(color: colorBorder),
        )
      ),
      keyboardType: keyBoardType,
      inputFormatters: inputFormatter,
    );
  }
}
