import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vacina_app/data/models/local_model.dart';
import 'package:vacina_app/data/models/user_model.dart';

import 'header_content.dart';
import 'notification_icon.dart';

class AppBarSection extends StatelessWidget {
  final VoidCallback onAvatarTap;
  final UserModel user;
  final LocalModel local;
  final String place;
  final int count;
  final FlutterSecureStorage storage;
  final Function() setState;

  const AppBarSection({
    super.key,
    required this.onAvatarTap,
    required this.user,
    required this.local,
    required this.place,
    required this.count,
    required this.storage,
    required this.setState,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      title: HeaderContent(user: user, local: local, place: place),
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
      actions: [
        NotificationIcon(count: count, storage: storage, setState: setState),
      ],
    );
  }
}
