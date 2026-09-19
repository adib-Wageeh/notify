import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notify/core/app_colors.dart';
import 'package:notify/core/notifications_helper/local_notification_util.dart';

class AppNavigatorContainer extends StatefulWidget {
  const AppNavigatorContainer({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  State<AppNavigatorContainer> createState() => _AppNavigatorContainerState();
}

class _AppNavigatorContainerState extends State<AppNavigatorContainer> {

  @override
  void initState() {
    super.initState();
    initNotifications();
  }

  void initNotifications()async{
    await LocalNotificationHelper.init();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LocalNotificationHelper.getInitNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.shell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.shell.currentIndex,
        items: tabNames
            .map(
              (name) =>
                  BottomNavigationBarItem(label: name, icon: SizedBox.shrink()),
            )
            .toList(),
        onTap: (index) => widget.shell.goBranch(index),
        showUnselectedLabels: true,
        showSelectedLabels: true,
        backgroundColor: AppColors.grey900,
        selectedItemColor: AppColors.primary500,
        unselectedItemColor: AppColors.grey400,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w300,
        ),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

List<String> tabNames = ["Today", "Create", "Inbox", "Station"];
