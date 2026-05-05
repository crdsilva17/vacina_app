import 'package:flutter/material.dart';

class VaccineStatusCard extends StatelessWidget {
  const VaccineStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Aqui você consome estado (Provider, Riverpod, etc.)
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined, size: 50.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Boa Notícia!',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.green,
                          backgroundColor: Colors.greenAccent,
                        ),
                      ),
                    ),
                    const Text(
                      'Vacina disponível',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Text('Influenza'),
                    const Text('Posto de Saúde'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: const [
                Expanded(child: Text('Primary')),
                SizedBox(width: 8),
                Expanded(child: Text("Secondary")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
