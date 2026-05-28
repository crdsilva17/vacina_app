import 'package:flutter/material.dart';
import 'package:vacina_app/data/models/vaccine_model.dart';
import 'package:vacina_app/widget/_primary_button.dart';
import 'package:vacina_app/widget/secundary_button.dart';

class VaccineStatusCard extends StatelessWidget {
  final VaccineModel vaccineModel;
  const VaccineStatusCard({super.key, required this.vaccineModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.vaccines_outlined,
                      size: 50.0,
                      color: Colors.green,
                    ),
                    SizedBox(width: 22),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.greenAccent,
                              width: 0.4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.greenAccent.withValues(
                                  alpha: 0.8,
                                ),
                                blurRadius: 12,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Text(
                            'Boa Notícia!',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 7, 112, 11),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        const Text(
                          'Vacina disponível para você!',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(vaccineModel.name),
                        RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                ),
                              ),
                              TextSpan(
                                text: vaccineModel.posto,
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: 'Agendar agora',
                    icon: Icons.calendar_month,
                    onPressed: () {
                      Navigator.pushNamed(context, '/schedule');
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: SecondaryButton(
                    label: 'Saiba mais',
                    icon: Icons.info_outline,
                    onPressed: () {
                      Navigator.pushNamed(context, '/details');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
