import 'dart:ffi';

import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isEnabled;

  const CustomButtom({
    super.key,
    required this.text,
    required this.icon,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 170,
        height: 170,
        decoration: BoxDecoration(
          color: isEnabled ? Colors.blue[800] : Colors.blueGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 50),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
