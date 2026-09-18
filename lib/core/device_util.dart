import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

Future<String> deviceName() async {
  final deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    return "${androidInfo.manufacturer} ${androidInfo.model}";
  } else if (Platform.isIOS) {
    final iosInfo = await deviceInfo.iosInfo;
    return iosInfo.utsname.machine;
  }

  return "Unknown device";
}