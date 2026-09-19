import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';
import 'package:notify/core/go_router.dart';
import 'package:notify/core/notifications_helper/local_notification_util.dart';

class FCMHelper {
  FCMHelper._();

  static Future<void> initFcm() async {
    _getInitNotification();

    // Triggered only when the user tapped an FCM notification
    // and brought the app from background to foreground.
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedAppHandler);

    // An FCM message is handled while the app is backgrounded/terminated.
    // It runs outside your UI context; on Android it uses a background isolate.
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Triggered whenever an FCM message arrives while the app is foregrounded.
    FirebaseMessaging.onMessage.listen(_showLocalNotificationFromFCMNotification);
  }

  // User taps an FCM notification while the app is terminated,
  // and that tap launches the app.
  // It returns the message once, then is cleared.
  static Future<void> _getInitNotification() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      final payload = initialMessage.data['payload'];
      if (paths.contains(payload)) {
        navigationKey.currentContext?.go(payload!);
      }
    }
  }

  static Future<void> _onMessageOpenedAppHandler(RemoteMessage message) async {
    final payload = message.data['payload'];
    if (paths.contains(payload)) {
      navigationKey.currentContext?.go(payload!);
    }
  }

  static Future<void> _showLocalNotificationFromFCMNotification(
    RemoteMessage message,
  ) async {
    await LocalNotificationHelper.showLocalNotificationFromFcm(message);
  }
}

// Save data, update local storage, or create a local notification.
// Do not navigate, use BuildContext, or update UI here.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
}
