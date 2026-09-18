import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:notify/core/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';

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

Future<bool> isNotificationEnabled() async {
  PermissionStatus status = await Permission.notification.status;

  if (status.isGranted || status.isProvisional) {
    return true;
  }
  return false;
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
