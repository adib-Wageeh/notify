import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:notify/core/app_colors.dart';
import 'package:notify/core/app_constants.dart';
import 'package:notify/cubit/enable_notification/enable_notifications_cubit.dart';
import 'package:notify/models/notification_model.dart';
import 'package:notify/ui/widgets/today_body/today_notification_item.dart';

class TodayNudgesItem extends StatelessWidget {
  const TodayNudgesItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EnableNotificationsCubit, EnableNotificationsState>(
      listener: (context, state) =>
          state.whenOrNull(approved: (onDone) => onDone?.call()),
      child: StreamBuilder(
        stream: Hive.box<NotificationModel>(AppConstants.hiveBoxName).watch(),
        builder: (context, boxEvent) {
          final notifications =
              Hive.box<NotificationModel>(AppConstants.hiveBoxName).values
                  .where(
                    (notification) =>
                        notification.scheduledDate?.year ==
                            DateTime.now().year &&
                        notification.scheduledDate?.month ==
                            DateTime.now().month &&
                        notification.scheduledDate?.day == DateTime.now().day,
                  )
                  .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Today’s nudges",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    "${notifications.length} planned",
                    style: TextStyle(
                      color: AppColors.grey400,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) => TodayNotificationItem(
                    notificationModel: notifications[index],
                  ),
                  separatorBuilder: (context, _) => SizedBox(height: 8),
                  itemCount: notifications.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
