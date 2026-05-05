import 'package:flutter/material.dart';

import 'header_content.dart';
import 'notification_icon.dart';

class AppBarSection extends StatelessWidget {
  final VoidCallback onAvatarTap;

  const AppBarSection({super.key, required this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      title: const HeaderContent(),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          child: CircleAvatar(),
          onTap: onAvatarTap,
        ),
      ),
      actions: const [NotificationIcon()],
    );
  }
}
