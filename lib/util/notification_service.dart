import 'dart:convert';

import 'package:vacina_app/data/http/api_endpoints.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/models/notification_model.dart';

class NotificationService {
  final HttpClient client = HttpClient();
  Map<String, String> uri = {
    'base': ApiEndpoints.baseUrl,
    'endpoint': ApiEndpoints.notifications,
  };

  Future<List<NotificationModel>> getNotifications(String accessToken) async {
    uri['endpoint'] = ApiEndpoints.notifications;
    final response = await client.getAuth(uri: uri, token: accessToken);

    final List data = jsonDecode(response.body);

    return data.map((e) => NotificationModel.fromJson(e)).toList();
  }

  Future<int> getCount(String accessToken) async {
    uri['endpoint'] = ApiEndpoints.count;
    final response = await client.getAuth(uri: uri, token: accessToken);

    try {
      return int.parse(response.body);
    } catch (ex) {
      Exception(ex);
    }

    return 0;
  }

  Future<void> markAsRead(String id, String accessToken) async {
    uri['endpoint'] = ApiEndpoints.setNotificationRead(id);
    await client.patch(uri: uri, token: accessToken);
  }
}
