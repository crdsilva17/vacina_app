import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData iconData;
  final IconButton? icon;
  final TextEditingController controller;
  final TextInputType keyBoardType;
  final List<TextInputFormatter>? inputFormatter;
  final Color? colorText;
  final Color? colorLabel;
  final Color? colorIcon;
  final Color? colorBorder;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.label,
    required this.iconData,
    required this.controller,
    this.colorText,
    this.colorLabel,
    this.colorIcon,
    this.colorBorder,
    this.keyBoardType = TextInputType.text,
    this.icon,
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
        labelStyle: TextStyle(color: colorLabel),
        prefixIcon: Icon(iconData, color: colorIcon),
        suffixIcon: icon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      keyboardType: keyBoardType,
      inputFormatters: inputFormatter,
    );
  }
}
