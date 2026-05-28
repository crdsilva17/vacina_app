import 'package:flutter/material.dart';
import 'package:vacina_app/data/models/local_model.dart';
import 'package:vacina_app/data/models/user_model.dart';

class HeaderContent extends StatelessWidget {
  final UserModel user;
  final LocalModel local;
  final String place;
  const HeaderContent({
    super.key,
    required this.user,
    required this.local,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, ${user.name.split(' ')[0]}!',
                style: TextStyle(fontSize: 18),
              ),
              Text(place, style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
