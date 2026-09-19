import 'dart:isolate';
import 'dart:ui';

import 'package:notify/core/notifications_helper/notifications_util.dart';

const notificationActionPortName = 'notification_action_port';

final ReceivePort notificationActionPort = ReceivePort();

void setupNotificationActionPort() {
  IsolateNameServer.removePortNameMapping(notificationActionPortName);

  IsolateNameServer.registerPortWithName(
    notificationActionPort.sendPort,
    notificationActionPortName,
  );

  notificationActionPort.listen((data) async {
    final notificationId = data['notificationId'] as int;
    final actionId = data['actionId'] as String;

    // This runs in the MAIN isolate.
    // Update Hive here, and your StreamBuilder updates immediately.
    await handleBackgroundAction(notificationId, actionId);
  });
}
