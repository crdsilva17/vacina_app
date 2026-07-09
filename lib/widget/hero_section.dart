import 'package:flutter/material.dart';
import 'package:vacina_app/data/models/campanha_model.dart';
import 'package:vacina_app/data/models/local_model.dart';
import 'package:vacina_app/data/models/user_model.dart';
import 'package:vacina_app/data/models/vaccine_model.dart';
import 'package:vacina_app/widget/vaccine_status_card.dart';

class HeroSection extends StatelessWidget {
  final UserModel user;
  final LocalModel local;
  final List<CampanhaModel> campanhas;
  final List<VaccineModel> vaccines;
  const HeroSection({
    super.key,
    required this.user,
    required this.local,
    required this.vaccines,
    required this.campanhas,
  });

  @override
  Widget build(BuildContext context) {
    List<VaccineStatusCard> cards = _getList(vaccines);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: RepaintBoundary(
        child: Column(
          children: [
            ...cards.isEmpty
                ? [Center(child: Text('Sem Vacinas disponíveis'))]
                : cards,
          ],
        ),
      ),
    );
  }

  List<VaccineStatusCard> _getList(List<VaccineModel> vaccines) {
    List<VaccineStatusCard> cards = [];

    for (VaccineModel vaccine in vaccines) {
      CampanhaModel campanhaModel = campanhas.firstWhere(
        (c) => c.vacinaId == vaccine.id,
      );
      cards.add(
        VaccineStatusCard(
          vaccineModel: vaccine,
          ubs: local.name,
          campanhaModel: campanhaModel,
        ),
      );
    }
    return cards;
  }
}
