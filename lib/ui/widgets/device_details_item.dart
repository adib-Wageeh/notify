import 'package:flutter/material.dart';
import 'package:notify/core/app_colors.dart';
import 'package:notify/core/device_util.dart';
import 'package:notify/core/notifications_helper/notifications_util.dart';
import 'package:notify/ui/widgets/content_container.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceDetailsItem extends StatelessWidget {
  const DeviceDetailsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ContentContainer(
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.primary400,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FutureBuilder(
                  future: deviceName(),
                  builder: (context, snapShot) => snapShot.data == null
                      ? SizedBox.shrink()
                      : Text(
                          snapShot.data!,
                          style: TextStyle(
                            color: AppColors.grey300,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                StreamBuilder<PermissionStatus>(
                  stream: notificationPermissionStream(),
                  builder: (context, snapshot) {
                    final status = snapshot.data;
                    if (status == null) return const SizedBox.shrink();

                    final enabled = status.isGranted || status.isProvisional;
                    return Text(
                      enabled
                          ? "Notifications enabled"
                          : "Notifications disabled",
                      style: TextStyle(
                        color: AppColors.grey300,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
