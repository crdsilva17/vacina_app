import 'package:flutter/material.dart';
import 'package:vacina_app/data/models/user_model.dart';
import 'package:vacina_app/data/models/vaccine_model.dart';
import 'package:vacina_app/widget/vaccine_status_card.dart';

class HeroSection extends StatelessWidget {
  final UserModel user;
  final List<VaccineModel> vaccines;
  const HeroSection({super.key, required this.user, required this.vaccines});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: RepaintBoundary(child: Column(children: [..._getList(vaccines)])),
    );
  }

  List<VaccineStatusCard> _getList(List<VaccineModel> vaccines) {
    List<VaccineStatusCard> cards = [];
    for (VaccineModel vaccine in vaccines) {
      if (vaccine.minRecommendedAge <= user.age() &&
          user.age() <= vaccine.maxRecommendedAge) {
        cards.add(VaccineStatusCard(vaccineModel: vaccine));
      }
    }
    return cards;
  }
}
