import 'package:flutter/material.dart';
import 'package:vacina_app/screens/locais_screen.dart';
import 'package:vacina_app/screens/vaccine_manage_screen.dart';
import 'package:vacina_app/util/custom_navigate.dart';
import 'package:vacina_app/widget/custom_buttom.dart';

class HeroAdmSection extends StatelessWidget {
  const HeroAdmSection({super.key, required this.context});

  final BuildContext context;
  double get screenWidth => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screenWidth * 0.45,
              child: InkWell(
                onTap: () => push(context, LocaisScreen()),
                child: CustomButtom(
                    text: 'Postos de Saúde',
                    icon: Icons.location_on_outlined,
                  ),
                ),
              ),
            const SizedBox(width: 10),
            SizedBox(
              width: screenWidth * 0.45,
              child: InkWell(
                onTap: () {
                  push(context, VaccineManageScreen());
                },
                child: CustomButtom(
                  text: 'Gerenciar Vacinas',
                  icon: Icons.vaccines,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screenWidth * 0.45,
              child: InkWell(
                onTap: () => print('Campanhas'),
                child: CustomButtom(
                  text: 'Campanhas',
                  icon: Icons.campaign_outlined,
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: screenWidth * 0.45,
              child: InkWell(
                onTap: () => print('Gerenciar Usuários'),
                child: CustomButtom(
                  text: 'Gerenciar Usuários',
                  icon: Icons.people_outline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
