import 'package:flutter/material.dart';
import 'package:vacina_app/widget/vaccine_status_card.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: RepaintBoundary(
        child: VaccineStatusCard(),
      ),
    );
  }
}