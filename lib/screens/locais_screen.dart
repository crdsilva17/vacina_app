import 'package:flutter/material.dart';

class LocaisScreen extends StatelessWidget {
  const LocaisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Postos de Saúde'),
         backgroundColor: Colors.blue[900],
         foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: const Center(
          child: Text(
            'Aqui serão listados os postos de saúde disponíveis.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
