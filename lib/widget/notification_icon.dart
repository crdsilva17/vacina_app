import 'package:flutter/material.dart';

import 'notification_badge.dart';

class NotificationIcon extends StatelessWidget {
  final int count;
  const NotificationIcon({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final int notificationCount = count;

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              print('Notification');
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
