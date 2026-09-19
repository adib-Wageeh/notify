import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:notify/core/app_constants.dart';
import 'package:notify/models/notification_action/notification_action.dart';
import 'package:notify/models/notification_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'core/go_router.dart';
import 'core/isolate_util.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  Hive.registerAdapter(NotificationModelAdapter());
  Hive.registerAdapter(NotificationActionAdapter());
  await Hive.openBox<NotificationModel>(AppConstants.hiveBoxName);
  setupNotificationActionPort();
  runApp(HomeScreen());
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: (context, child) {
        final botToastBuilder = BotToastInit();
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          child: botToastBuilder(context, child!),
        );
      },
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
