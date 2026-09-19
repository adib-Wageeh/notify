import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_ce/hive.dart';

part 'notification_action.g.dart';
part 'notification_action.freezed.dart';

@HiveType(typeId: 1)
@freezed
class NotificationAction with _$NotificationAction{
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;

  const NotificationAction({
    required this.id,
    required this.title,
  });
}
