import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notify/core/notifications_helper/local_notification_util.dart';
import 'package:notify/cubit/enable_notification/enable_notifications_cubit.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'core/go_router.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await LocalNotificationHelper.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(HomeScreen());
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => EnableNotificationsCubit())],
      child: MaterialApp.router(
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
      ),
    );
  }
}
