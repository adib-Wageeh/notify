import 'dart:math';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:notify/core/app_colors.dart';
import 'package:notify/core/app_constants.dart';
import 'package:notify/core/date_util.dart';
import 'package:notify/core/notifications_helper/local_notification_util.dart';
import 'package:notify/core/notifications_helper/notifications_util.dart';
import 'package:notify/cubit/enable_notification/enable_notifications_cubit.dart';
import 'package:notify/models/notification_action/notification_action.dart';
import 'package:notify/models/notification_model.dart';
import 'package:notify/ui/widgets/create_body/app_text_field_item.dart';
import 'package:notify/ui/widgets/create_body/delivery_type_item.dart';
import 'package:notify/ui/widgets/create_body/when_tapped_item.dart';

class CreateBody extends StatefulWidget {
  const CreateBody({super.key});

  @override
  State<CreateBody> createState() => _CreateBodyState();
}

class _CreateBodyState extends State<CreateBody> {
  final TextEditingController reminderNameController = TextEditingController();
  final TextEditingController selectedDateController = TextEditingController(
    text: dateTimeToString(DateTime.now()),
  );
  final TextEditingController selectedTimeController = TextEditingController(
    text: timeOfDayToString(TimeOfDay.now()),
  );
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  ValueNotifier<String> deliveryType = ValueNotifier(
    AppConstants.deliveryType.first,
  );
  ValueNotifier<String> whenTapped = ValueNotifier(
    AppConstants.whatToOpenItems.keys.first,
  );
  ValueNotifier<String> selectedUserKey = ValueNotifier(
    AppConstants.usersTokens.keys.first,
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EnableNotificationsCubit>(
      create: (_) => EnableNotificationsCubit(),
      child: Builder(
        builder: (context) {
          return BlocListener<
            EnableNotificationsCubit,
            EnableNotificationsState
          >(
            listener: (context, state) => state.whenOrNull(
              approved: (_) async {
                final mergedTime = mergeDateAndTime(selectedDate, selectedTime);
                NotificationModel model = NotificationModel(
                  id: Random().nextInt(1000000),
                  title: reminderNameController.text.trim(),
                  description: "",
                  scheduledDate: mergedTime,
                  payload:
                      AppConstants.whatToOpenItems[whenTapped.value] ??
                      AppConstants.whatToOpenItems.values.first,
                  markedDone: false,
                  actions: [
                    NotificationAction(
                      id: AppConstants.markAsDoneActionId,
                      title: "Mark as done",
                    ),
                    NotificationAction(
                      id: AppConstants.snoozeActionId,
                      title: "Snooze 10 minutes",
                    ),
                  ],
                );

                final result = await LocalNotificationHelper.sendNotification(
                  notification: model,
                );
                if (result) {
                  BotToast.showText(
                    text:
                        "notification will be sent in ${dateTimeToString2(mergedTime)}",
                  );
                  await Hive.box<NotificationModel>(
                    AppConstants.hiveBoxName,
                  ).put(model.id, model);
                }
                return null;
              },
            ),
            child: Scaffold(
              backgroundColor: AppColors.primary900,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: AppColors.primary900,
                    height: MediaQuery.paddingOf(context).top,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 18,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "New nudge",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Create a reminder, then decide how it should arrive.",
                            style: TextStyle(
                              color: AppColors.grey300,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppTextFieldItem(
                            controller: reminderNameController,
                            hint: "Reminder title name",
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: AppTextFieldItem(
                                  controller: selectedDateController,
                                  hint: "Select day",
                                  onPressed: () async {
                                    final dateTime = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      initialDate: selectedDate,
                                      lastDate: DateTime(2100),
                                    );
                                    if (dateTime != null) {
                                      selectedDate = dateTime;
                                      selectedDateController.text =
                                          dateTimeToString(selectedDate);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: AppTextFieldItem(
                                  controller: selectedTimeController,
                                  hint: "Select time",
                                  onPressed: () async {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    if (time != null) {
                                      final mergedSelectedTime =
                                          mergeDateAndTime(selectedDate, time);
                                      if (mergedSelectedTime.isBefore(
                                        DateTime.now(),
                                      )) {
                                        BotToast.showText(
                                          text: "add time after current time",
                                        );
                                      } else {
                                        selectedTime = time;
                                        selectedTimeController.text =
                                            timeOfDayToString(selectedTime);
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          DeliveryTypeItem(
                            selectedItem: deliveryType,
                            selectedUserKey: selectedUserKey,
                          ),
                          const SizedBox(height: 20),
                          WhenTappedItem(whenTapped: whenTapped),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                final date = mergeDateAndTime(
                                  selectedDate,
                                  selectedTime,
                                );

                                if (date.isBefore(DateTime.now())) {
                                  BotToast.showText(
                                    text: "Must be a date in the future",
                                  );
                                } else {
                                  final response =
                                      await requestNotificationsPermission(
                                        context,
                                      );
                                  if (context.mounted) {
                                    BlocProvider.of<EnableNotificationsCubit>(
                                      context,
                                    ).notificationsStatusChanged(response);
                                  }
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
                                "Schedule nudge",
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
