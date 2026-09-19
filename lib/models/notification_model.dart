import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';
import 'package:notify/models/notification_action/notification_action.dart';

part 'notification_model.g.dart';
part 'notification_model.freezed.dart';

@HiveType(typeId: 0)
@freezed
class NotificationModel with _$NotificationModel{
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final DateTime? scheduledDate;
  @HiveField(4)
  final String? payload;
  @HiveField(5, defaultValue: false)
  final bool markedDone;
  @HiveField(6)
  final List<NotificationAction> actions;

  const NotificationModel({
    required this.id,
    required this.title,
    this.description = "",
    this.scheduledDate,
    this.payload,
    this.actions = const [],
    this.markedDone = false,
  });
}
