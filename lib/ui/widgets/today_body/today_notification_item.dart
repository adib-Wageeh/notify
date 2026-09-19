import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:notify/core/app_colors.dart';
import 'package:notify/core/app_constants.dart';
import 'package:notify/core/date_util.dart';
import 'package:notify/core/notifications_helper/local_notification_util.dart';
import 'package:notify/core/notifications_helper/notifications_util.dart';
import 'package:notify/cubit/enable_notification/enable_notifications_cubit.dart';
import 'package:notify/models/notification_action/notification_action.dart';
import 'package:notify/models/notification_model.dart';

class TodayNotificationItem extends StatelessWidget {
  const TodayNotificationItem({super.key, required this.notificationModel});

  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notificationModel.id.toString()),
      direction:
          DateTime.now().isBefore(
                notificationModel.scheduledDate ?? DateTime.now(),
              ) &&
              notificationModel.markedDone == false
          ? DismissDirection.horizontal
          : notificationModel.markedDone == false
          ? DismissDirection.endToStart
          : DateTime.now().isBefore(
                  notificationModel.scheduledDate ?? DateTime.now(),
                ) &&
                notificationModel.markedDone == false
          ? DismissDirection.startToEnd
          : DismissDirection.none,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.primary700,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.snooze, color: Colors.white),
            SizedBox(width: 4),
            Text(
              "Snooze for 10 minutes",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(Icons.check, color: Colors.white),
            SizedBox(width: 4),
            Text(
              "Mark as done",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        final response = await requestNotificationsPermission(context);

        // snooze for 10 minutes
        if (direction == DismissDirection.startToEnd) {
          if (context.mounted) {
            BlocProvider.of<EnableNotificationsCubit>(
              context,
            ).notificationsStatusChanged(response, () async {
              final updatedNotification = notificationModel.copyWith(
                scheduledDate:
                    notificationModel.scheduledDate?.add(
                      Duration(minutes: 10),
                    ) ??
                    DateTime.now().add(Duration(minutes: 10)),
                actions: [
                  NotificationAction(
                    id: AppConstants.markAsDoneActionId,
                    title: "Mark as done",
                  ),
                  NotificationAction(
                    id: AppConstants.snoozeActionId,
                    title: "Snooze 10 minutes",
                  ),
                ],
              );
              final result = await LocalNotificationHelper.sendNotification(
                notification: updatedNotification,
                reschedule: true,
              );
              if (result) {
                await Hive.box<NotificationModel>(
                  AppConstants.hiveBoxName,
                ).put(notificationModel.id, updatedNotification);
                BotToast.showText(
                  text: "your reminder has been postponed 10 minutes",
                );
              }
            });
          }
        }
        // mark as done
        else {
          if (context.mounted) {
            BlocProvider.of<EnableNotificationsCubit>(
              context,
            ).notificationsStatusChanged(response, () async {
              final updatedNotification = notificationModel.copyWith(
                markedDone: true,
              );
              await LocalNotificationHelper.cancelNotification(
                updatedNotification.id,
              );
              await Hive.box<NotificationModel>(
                AppConstants.hiveBoxName,
              ).put(notificationModel.id, updatedNotification);
              BotToast.showText(text: "your reminder has been marked as done");
            });
          }
        }
        return false;
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: notificationModel.markedDone
              ? AppColors.primary800
              : AppColors.grey900,
          border: BoxBorder.all(color: AppColors.grey600),
        ),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          children: [
            if (notificationModel.markedDone) ...[
              Icon(Icons.check_circle_rounded, color: AppColors.primary500),
              SizedBox(width: 4),
            ],
            Expanded(
              child: Text(
                notificationModel.title,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  decorationColor: AppColors.white,
                  decoration: notificationModel.markedDone
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
            if (notificationModel.scheduledDate != null)
              Text(
                dateTimeToString3(notificationModel.scheduledDate!),
                style: TextStyle(
                  color: AppColors.primary400,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
