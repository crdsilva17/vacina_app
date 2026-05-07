import 'package:flutter/material.dart';
import 'package:vacina_app/data/models/local_model.dart';
import 'package:vacina_app/data/models/user_model.dart';

class HeaderContent extends StatelessWidget {
  final UserModel user;
  final LocalModel local;
  const HeaderContent({super.key, required this.user, required this.local});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Olá, ${user.name}'),
              Text(local.name),
            ],
          ),
        ),
      ],
    );
  }
}
