import 'package:flutter/material.dart';
import 'package:vacina_app/data/models/local_model.dart';
import 'package:vacina_app/data/models/user_model.dart';

import 'header_content.dart';
import 'notification_icon.dart';

class AppBarSection extends StatelessWidget {
  final VoidCallback onAvatarTap;
  final UserModel user;
  final LocalModel local;

  const AppBarSection({
    super.key,
    required this.onAvatarTap,
    required this.user,
    required this.local,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      title: HeaderContent(user: user, local: local),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: onAvatarTap,
          child: CircleAvatar(
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '',
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        ),
      ),
      actions: const [NotificationIcon()],
    );
  }
}
