import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:notify/core/go_router.dart';
import 'package:notify/core/notifications_helper/notifications_util.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationHelper {
  const LocalNotificationHelper._();

  static final instance = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    await instance.initialize(
      settings: InitializationSettings(
        android: AndroidInitializationSettings("qaff"),
        iOS: DarwinInitializationSettings(),
      ),
      // when notification is pressed and app is terminated
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundNotificationReceived,
      // when notification is pressed and app is in foreground or background
      onDidReceiveNotificationResponse: onForegroundNotificationReceived,
    );
  }

  static Future<void> sendNotification({
    required String title,
    required String body,
    int id = 1,
    String channelId = "default_channel",
    String channelName = "Default Notifications",
    String? payload,
    DateTime? scheduledDate,
  }) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: 'General app notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    if (scheduledDate != null) {
      final result = await requestExactAlarmPermission();
      if (result == true) {
        await instance.zonedSchedule(
          id: id,
          scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          title: title,
          body: body,
          payload: payload,
        );
      } else {
        BotToast.showText(text: "you need to enable alarm and reminders");
      }
    } else {
      await instance.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: details,
        payload: payload,
      );
    }
  }

  static Future<NotificationResponse?> getLaunchNotification() async {
    final details = await instance.getNotificationAppLaunchDetails();

    if (details != null && details.didNotificationLaunchApp) {
      return details.notificationResponse;
    }
    return null;
  }

  static Future<void> getInitNotification() async {
    final response = await getLaunchNotification();
    if (response != null) {
      final payload = response.payload;
      if (paths.contains(payload)) {
        navigationKey.currentContext?.go(payload!);
      }
    }
  }
}

void onForegroundNotificationReceived(NotificationResponse response) {
  final payload = response.payload;
  if (paths.contains(payload) && navigationKey.currentContext != null) {
    navigationKey.currentContext?.go(payload!);
  }
}

@pragma('vm:entry-point')
void onBackgroundNotificationReceived(NotificationResponse response) {}
