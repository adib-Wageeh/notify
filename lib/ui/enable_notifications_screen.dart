import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notify/core/app_colors.dart';
import 'package:notify/core/assets.gen.dart';
import 'package:notify/core/notifications_helper/notifications_util.dart';
import 'package:notify/cubit/enable_notification/enable_notifications_cubit.dart';

class EnableNotificationsScreen extends StatelessWidget {
  const EnableNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EnableNotificationsCubit,EnableNotificationsState>(
      listener: (context,state) => state.whenOrNull(
        approved: () => context.go("/today"),
      ),
      child: Scaffold(
        backgroundColor: AppColors.grey800,
        body: Column(
          children: [
            Container(
              color: AppColors.primary900,
              height: MediaQuery.paddingOf(context).top,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 64),
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        color: AppColors.primary700,
                      ),
                      child: Center(
                        child: Image.asset(
                          Assets.images.bell.path,
                          height: 74,
                          width: 74,
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "Make reminders feel useful.",
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "Nudge Lab is your private place to test local and cloud notifications across every device.",
                        style: TextStyle(
                          color: AppColors.grey400,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
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
                          "Enable notifications",
                          style: TextStyle(
                            color: AppColors.ink900,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.go("/today");
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            AppColors.grey700,
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
                          "Enable later",
                          style: TextStyle(
                            color: AppColors.grey300,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.grey700,
                      ),
                      padding: EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.grey400,
                            size: 16,
                          ),
                          Expanded(
                            child: Text(
                              "Notifications are off. You can explore the app first, but reminders will not appear until permission is granted.",
                              style: TextStyle(
                                color: AppColors.grey400,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
