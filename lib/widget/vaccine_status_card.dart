import 'package:flutter/material.dart';
import 'package:vacina_app/data/models/vaccine_model.dart';

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
                SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.greenAccent, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.greenAccent.withValues(alpha: 0.6),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Text(
                    'Boa Notícia!',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                Row(
                  children: [
                    const Icon(
                      Icons.vaccines_outlined,
                      size: 60.0,
                      color: Colors.green,
                    ),
                    SizedBox(width: 20),
                    const Text(
                      'Vacina disponível',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nome',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(vaccineModel.name, style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 8),
                      const Text(
                        'Descrição',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(vaccineModel.description),
                      const SizedBox(height: 8),
                      const Text(
                        'Doses',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(vaccineModel.doses),
                    ],
                  ),
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
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          icon: Icon(Icons.info_outline),
                          content: Column(
                            children: [
                              Row(
                                children: [
                                  Text('Nome: '),
                                  Text(vaccineModel.name),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Fabricante: '),
                                  Text(vaccineModel.manufacturer),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Data Fab: '),
                                  Text(vaccineModel.manufactureDate),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Validade: '),
                                  Text(vaccineModel.expiryDate),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Lote: '),
                                  Text(vaccineModel.lot),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Faixa etária: '),
                                  Text(
                                    '${vaccineModel.minRecommendedAge}/${vaccineModel.maxRecommendedAge} anos',
                                  ),
                                ],
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Fechar'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('Info'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextButton(onPressed: () {}, child: Text('Agendar')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
