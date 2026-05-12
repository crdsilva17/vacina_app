import 'package:flutter/material.dart';
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
                    onTap: () => print('Gerenciar Locais'),
                    child: CustomButtom(
                      text: 'Gerenciar Locais',
                      icon: Icons.location_on_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => print('Gerenciar Vacinas'),
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
              const Text(
                'Aqui você pode gerenciar usuários, locais de vacinação e visualizar relatórios.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
      ),
    );
  }
}
