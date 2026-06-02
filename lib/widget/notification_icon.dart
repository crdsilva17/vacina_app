import 'package:flutter/material.dart';

import 'notification_badge.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final int notificationCount = 3;

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          if (notificationCount > 0)
            Positioned(
              right: 6,
              top: 6,
              child: NotificationBadge(count: notificationCount),
            ),
        ],
      ),
    );
  }
}
