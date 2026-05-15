import 'package:flutter/material.dart';
import 'package:vacina_app/screens/locais_screen.dart';
import 'package:vacina_app/screens/vaccine_manage_screen.dart';
import 'package:vacina_app/util/custom_navigate.dart';
import 'package:vacina_app/widget/custom_buttom.dart';

class HeroAdmSection extends StatelessWidget {
  const HeroAdmSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Row(
                children: [
                  InkWell(
                    onTap: () => push(context, LocaisScreen()),
                    child: CustomButtom(
                      text: 'Postos de Saúde',
                      icon: Icons.location_on_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () {
                      push(context, VaccineManageScreen());
                    },
                    child: CustomButtom(
                      text: 'Gerenciar Vacinas',
                      icon: Icons.vaccines,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  InkWell(
                    onTap: () => print('Campanhas'),
                    child: CustomButtom(
                      text: 'Campanhas',
                      icon: Icons.campaign_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => print('Gerenciar Usuários'),
                    child: CustomButtom(
                      text: 'Gerenciar Usuários',
                      icon: Icons.people_outline,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
      ),
    );
  }
}
