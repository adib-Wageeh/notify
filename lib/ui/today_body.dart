import 'package:flutter/material.dart';
import 'package:notify/core/app_colors.dart';
import 'package:notify/core/date_util.dart';
import 'package:notify/core/notifications_helper/local_notification_util.dart';
import 'package:notify/ui/widgets/device_details_item.dart';
import 'package:notify/ui/widgets/send_local_notification_test_item.dart';

class TodayBody extends StatefulWidget {
  const TodayBody({super.key});

  @override
  State<TodayBody> createState() => _TodayBodyState();
}

class _TodayBodyState extends State<TodayBody> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      LocalNotificationHelper.getInitNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey800,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: AppColors.primary900,
            height: MediaQuery.paddingOf(context).top,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Good morning, Maya",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      getDayOfWeekAndMonth(),
                      style: TextStyle(
                        color: AppColors.grey400,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DeviceDetailsItem(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          SendLocalNotificationTestItem(),
        ],
      ),
    );
  }
}


