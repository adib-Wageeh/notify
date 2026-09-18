import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:notify/ui/widgets/app_navigator_container.dart';
import 'package:notify/ui/create_body.dart';
import 'package:notify/ui/enable_notifications_screen.dart';
import 'package:notify/ui/inbox_body.dart';
import 'package:notify/ui/station_body.dart';
import 'package:notify/ui/today_body.dart';
import 'package:permission_handler/permission_handler.dart';

final navigationKey = GlobalKey<NavigatorState>();

GoRouter router = GoRouter(
  initialLocation: "/",
  navigatorKey: navigationKey,
  observers: [BotToastNavigatorObserver()],
  routes: [
    GoRoute(
      path: "/",
      name: "enable_notifications",
      builder: (context, state) => EnableNotificationsScreen(),
      redirect: (context, state) async {
        final status = await Permission.notification.status;

        if (status.isGranted || status.isProvisional) {
          return "/today";
        }
        return null;
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppNavigatorContainer(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/today",
              name: "today",
              builder: (context, state) => TodayBody(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/create",
              name: "create",
              builder: (context, state) => CreateBody(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/inbox",
              name: "inbox",
              builder: (context, state) => InboxBody(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/station",
              name: "station",
              builder: (context, state) => StationBody(),
            ),
          ],
        ),
      ],
    ),
  ],
);

List<String> paths = ["/today", "/create", "/inbox", "/station"];
