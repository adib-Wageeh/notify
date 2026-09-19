import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:notify/core/app_constants.dart';
import 'package:notify/core/go_router.dart';
import 'package:notify/core/isolate_util.dart';
import 'package:notify/core/notifications_helper/notifications_util.dart';
import 'package:notify/models/notification_model.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationHelper {
  const LocalNotificationHelper._();

  static final instance = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    await instance.initialize(
      settings: InitializationSettings(
        android: AndroidInitializationSettings("qaff"),
        iOS: DarwinInitializationSettings(
          notificationCategories: [
            DarwinNotificationCategory(
              "actions",
              actions: [
                DarwinNotificationAction.plain(
                  AppConstants.markAsDoneActionId,
                  "Mark as done",
                ),
                DarwinNotificationAction.plain(
                  AppConstants.snoozeActionId,
                  "Snooze 10 minutes",
                ),
              ],
            ),
          ],
        ),
      ),
      // It is triggered when the user interacts with a notification action
      // that is configured to run without opening the app UI
      // (showsUserInterface: false)
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundNotificationReceived,
      // when notification is pressed and app is in foreground or background
      onDidReceiveNotificationResponse: onForegroundNotificationReceived,
    );
  }

  static Future<bool> sendNotification({
    required NotificationModel notification,
    String channelId = "default_channel",
    String channelName = "Default Notifications",
    bool reschedule = false,
    bool backgroundMode = false,
  }) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: 'General app notifications',
      importance: Importance.high,
      priority: Priority.high,
      actions: notification.actions
          .map((action) => AndroidNotificationAction(action.id, action.title))
          .toList(),
    );

    final iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: notification.actions.isNotEmpty ? "actions" : null,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    if (notification.scheduledDate != null) {
      bool result = false;

      // don't request permissions when app is closed and won't open
      if (backgroundMode) {
        result = true;
      } else {
        result = await requestExactAlarmPermission();
      }

      if (result == true) {
        if (reschedule) {
          await instance.cancel(id: notification.id);
        }
        await instance.zonedSchedule(
          id: notification.id,
          scheduledDate: tz.TZDateTime.from(
            notification.scheduledDate!,
            tz.local,
          ),
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          title: notification.title,
          body: notification.description,
          payload: notification.payload,
        );
        return true;
      } else {
        BotToast.showText(text: "you need to enable alarm and reminders");
      }
    } else {
      await instance.show(
        id: notification.id,
        title: notification.title,
        body: notification.description,
        notificationDetails: details,
        payload: notification.payload,
      );
      return true;
    }
    return false;
  }

  static Future<void> cancelNotification(int id) async {
    await instance.cancel(id: id);
    return;
  }

  //App was terminated, user taps the notification body and it launches the app
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

  static Future<void> showLocalNotificationFromFcm(
    RemoteMessage message,
  ) async {
    final title =
        message.notification?.title ??
        message.data['title']?.toString() ??
        'New notification';

    final body =
        message.notification?.body ?? message.data['body']?.toString() ?? '';

    final notificationId =
        (message.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch) &
        0x7fffffff;

    const androidDetails = AndroidNotificationDetails(
      'fcm_foreground_channel',
      'Foreground FCM notifications',
      channelDescription: 'Notifications received while the app is open',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await instance.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
      // The custom Firebase Console field: payload
      payload: message.data['payload']?.toString(),
    );
  }
}

Future<void> onForegroundNotificationReceived(
  NotificationResponse response,
) async {
  if (response.actionId == AppConstants.markAsDoneActionId) {
    await markNotificationAsDone(response);
  } else if (response.actionId == AppConstants.snoozeActionId) {
    snoozeNotification(response);
  } else {
    final payload = response.payload;
    if (paths.contains(payload) && navigationKey.currentContext != null) {
      navigationKey.currentContext?.go(payload!);
    }
  }
}

@pragma('vm:entry-point')
void onBackgroundNotificationReceived(NotificationResponse response) async {
  if (response.actionId != AppConstants.markAsDoneActionId &&
      response.actionId != AppConstants.snoozeActionId) {
    return;
  }

  final mainPort = IsolateNameServer.lookupPortByName(
    notificationActionPortName,
  );

  if (mainPort != null) {
    // App is alive: ask its MAIN isolate to handle the action.
    mainPort.send({
      'notificationId': response.id,
      'actionId': response.actionId,
    });
    return;
  }

  await handleBackgroundAction(response.id, response.actionId);
}
