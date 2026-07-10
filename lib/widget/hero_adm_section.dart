import 'package:flutter/material.dart';
import 'package:vacina_app/screens/campanha_list_screen.dart';
import 'package:vacina_app/screens/locais_screen.dart';
import 'package:vacina_app/screens/vaccine_manage_screen.dart';
import 'package:vacina_app/util/app_logger.dart';
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
                  text: 'Gerenciar UBS',
                  icon: Icons.location_on_outlined,
                  isEnabled: true,
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
                  isEnabled: true,
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
                onTap: () => push(context, CampanhaListScreen()),
                child: CustomButtom(
                  text: 'Gerenciar Campanhas de Vacinação',
                  icon: Icons.campaign_outlined,
                  isEnabled: true,
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: screenWidth * 0.45,
              child: InkWell(
                onTap:
                    () => // TODO Tela de Conteudo informativo.
                    AppLogger.log(
                      'Tela de Informação',
                      name: 'http_client',
                      error: '',
                    ),
                child: CustomButtom(
                  text: 'Gerenciar Conteúdo Informativo',
                  icon: Icons.newspaper_outlined,
                  isEnabled: false,
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
