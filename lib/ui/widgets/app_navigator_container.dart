import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notify/core/app_colors.dart';

class AppNavigatorContainer extends StatelessWidget {
  const AppNavigatorContainer({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: shell.currentIndex,
        items: tabNames
            .map(
              (name) =>
                  BottomNavigationBarItem(label: name, icon: SizedBox.shrink()),
            )
            .toList(),
        onTap: (index) => shell.goBranch(index),
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
