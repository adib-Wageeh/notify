import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notify/core/app_colors.dart';
import 'package:notify/core/notifications_helper/local_notification_util.dart';
import 'package:notify/core/notifications_helper/notifications_util.dart';
import 'package:notify/cubit/enable_notification/enable_notifications_cubit.dart';
import 'package:notify/ui/widgets/content_container.dart';

class SendLocalNotificationTestItem extends StatelessWidget {
  const SendLocalNotificationTestItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EnableNotificationsCubit, EnableNotificationsState>(
      listener: (context, state) => state.whenOrNull(
        approved: () => LocalNotificationHelper.sendNotification(
          title: "test title",
          body: "test body",
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ContentContainer(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Run a notification test",
                style: TextStyle(
                  color: AppColors.grey100,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Send a local alert now, then compare the result on each device.",
                style: TextStyle(
                  color: AppColors.grey200,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final response = await requestNotificationsPermission(
                      context,
                    );
                    if (context.mounted) {
                      BlocProvider.of<EnableNotificationsCubit>(
                        context,
                      ).notificationsStatusChanged(response);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      AppColors.primary400,
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                  child: Text(
                    "Send local test",
                    style: TextStyle(
                      color: AppColors.ink900,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
