import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotificationService {
  static Future<String?> getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission();

    return await messaging.getToken();
  }
}
