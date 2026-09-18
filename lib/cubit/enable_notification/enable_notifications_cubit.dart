import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:notify/core/notifications_helper/notifications_util.dart';

part 'enable_notifications_cubit.freezed.dart';
part 'enable_notifications_state.dart';

class EnableNotificationsCubit extends Cubit<EnableNotificationsState> {
  EnableNotificationsCubit() : super(const EnableNotificationsState.initial());


  void notificationsStatusChanged(NotificationStatus status){
    emit(EnableNotificationsState.initial());
    switch(status){
      case NotificationStatus.approved:
        emit(EnableNotificationsState.approved());
      case NotificationStatus.denied:
        emit(EnableNotificationsState.denied());
      case NotificationStatus.permanentlyDenied:
        emit(EnableNotificationsState.permanentlyDenied());
    }
  }

}
