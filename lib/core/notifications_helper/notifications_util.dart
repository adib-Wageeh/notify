import 'dart:async';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:notify/core/app_colors.dart';
import 'package:notify/core/app_constants.dart';
import 'package:notify/core/notifications_helper/local_notification_util.dart';
import 'package:notify/models/notification_action/notification_action.dart';
import 'package:notify/models/notification_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz_data;

enum NotificationStatus { approved, denied, permanentlyDenied }

Future<NotificationStatus> requestNotificationsPermission(
  BuildContext context,
) async {
  PermissionStatus status = await Permission.notification.status;

  if (status.isPermanentlyDenied) {
    if (context.mounted) {
      await enableNotificationsPermissionDialog(context);
    } else {
      await FlutterLocalNotificationsPlugin().openAppNotificationSettings();
    }
    return NotificationStatus.permanentlyDenied;
  } else {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
    );
  }
  status = await Permission.notification.status;

  if (status.isGranted || status.isProvisional) {
    return NotificationStatus.approved;
  }
  return NotificationStatus.denied;
}

Future<void> enableNotificationsPermissionDialog(BuildContext context) async {
  final result = await showAdaptiveDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: AppColors.grey800,
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Please allow notifications permission from app settings screen",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(true),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    AppColors.primary700,
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  padding: WidgetStateProperty.all(
                    EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  ),
                ),
                child: Text(
                  "Enable permission",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
  if (result == true) {
    await FlutterLocalNotificationsPlugin().openAppNotificationSettings();
  }
}

Stream<PermissionStatus> notificationPermissionStream() {
  late StreamController<PermissionStatus> controller;
  late _PermissionLifecycleObserver observer;

  Future<void> checkAndEmit() async {
    final status = await Permission.notification.status;
    if (!controller.isClosed) {
      controller.add(status);
    }
  }

  controller = StreamController<PermissionStatus>.broadcast(
    onListen: () {
      observer = _PermissionLifecycleObserver(onResume: checkAndEmit);
      WidgetsBinding.instance.addObserver(observer);
      checkAndEmit(); // emit current status immediately on first listen
    },
    onCancel: () {
      WidgetsBinding.instance.removeObserver(observer);
    },
  );

  return controller.stream;
}

class _PermissionLifecycleObserver with WidgetsBindingObserver {
  final VoidCallback onResume;

  _PermissionLifecycleObserver({required this.onResume});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume();
    }
  }
}

Future<bool> requestExactAlarmPermission() async {
  final status = await Permission.scheduleExactAlarm.status;
  if (status.isGranted) return true;

  final result = await Permission.scheduleExactAlarm.request();
  return result.isGranted;
}

Future<void> markNotificationAsDone(NotificationResponse response) async {
  NotificationModel? notification = Hive.box<NotificationModel>(
    AppConstants.hiveBoxName,
  ).get(response.id);
  if (notification != null) {
    notification = notification.copyWith(markedDone: true);
    await LocalNotificationHelper.cancelNotification(notification.id);
    await Hive.box<NotificationModel>(
      AppConstants.hiveBoxName,
    ).put(notification.id, notification);
  }
}

Future<void> snoozeNotification(NotificationResponse response) async {
  NotificationModel? notification = Hive.box<NotificationModel>(
    AppConstants.hiveBoxName,
  ).get(response.id);

  if (notification != null) {
    final updatedNotification = notification.copyWith(
      scheduledDate:
          notification.scheduledDate?.add(Duration(minutes: 10)) ??
          DateTime.now().add(Duration(minutes: 10)),
    );
    final result = await LocalNotificationHelper.sendNotification(
      notification: updatedNotification,
      reschedule: true,
    );
    if (result) {
      await Hive.box<NotificationModel>(
        AppConstants.hiveBoxName,
      ).put(notification.id, updatedNotification);
    }
  }
}

// must initialize every thing cause the app won't open
Future<void> handleBackgroundAction(
  int? notificationId,
  String? actionId,
) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  tz_data.initializeTimeZones();

  await Hive.initFlutter();

  final adapter = NotificationModelAdapter();
  final actionAdapter = NotificationActionAdapter();

  if (!Hive.isAdapterRegistered(adapter.typeId)) {
    Hive.registerAdapter(adapter);
  }
  if (!Hive.isAdapterRegistered(actionAdapter.typeId)) {
    Hive.registerAdapter(actionAdapter);
  }

  Box box;
  if (Hive.isBoxOpen(AppConstants.hiveBoxName)) {
    box = Hive.box<NotificationModel>(AppConstants.hiveBoxName);
  } else {
    box = await Hive.openBox<NotificationModel>(AppConstants.hiveBoxName);
  }

  if (notificationId == null) return;

  final notification = box.get(notificationId);
  if (notification == null) return;

  switch (actionId) {
    case AppConstants.markAsDoneActionId:
      final updatedNotification = notification.copyWith(markedDone: true);
      await box.put(notificationId, updatedNotification);
      await LocalNotificationHelper.cancelNotification(notificationId);
      break;

    case AppConstants.snoozeActionId:
      final updatedNotification = notification.copyWith(
        scheduledDate: notification.scheduledDate.add(
          const Duration(minutes: 10),
        ),
      );
      await box.put(notificationId, updatedNotification);

      // Schedule it again at the new time.
      // This must use the same details and action buttons as the original.
      await LocalNotificationHelper.sendNotification(
        notification: updatedNotification,
        reschedule: true,
        backgroundMode: true,
      );
      break;
  }
}
