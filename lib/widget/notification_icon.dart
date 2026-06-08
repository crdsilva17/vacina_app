import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vacina_app/data/models/notification_model.dart';
import 'package:vacina_app/util/notification_service.dart';

import 'notification_badge.dart';

class NotificationIcon extends StatelessWidget {
  final int count;
  final FlutterSecureStorage storage;
  const NotificationIcon({
    super.key,
    required this.count,
    required this.storage,
  });

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
            onPressed: () async {
              final token = await storage.read(key: 'token');

              if (token == null) return;

              final notifications = await NotificationService()
                  .getNotifications(token);

              _showNotifications(context, notifications, token);
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

  void _showNotifications(
    BuildContext context,
    List<NotificationModel> notifications,
    String accessToken,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,

          child: ListView.builder(
            itemCount: notifications.length,

            itemBuilder: (context, index) {
              final notification = notifications[index];

              return ListTile(
                leading: Icon(
                  notification.read
                      ? Icons.mark_email_read
                      : Icons.mark_email_unread,
                ),

                title: Text(notification.title),

                subtitle: Text(
                  notification.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                onTap: () async {
                  Navigator.pop(context);

                  await _showDetail(context, notification, accessToken);
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _showDetail(
    BuildContext context,
    NotificationModel notification,
    String accessToken,
  ) async {
    await NotificationService().markAsRead(notification.id, accessToken);
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(notification.title),

          content: SingleChildScrollView(child: Text(notification.message)),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Fechar"),
            ),
          ],
        );
      },
    );
  }
}
