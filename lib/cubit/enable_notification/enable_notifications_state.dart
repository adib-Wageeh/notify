part of 'enable_notifications_cubit.dart';

@freezed
class EnableNotificationsState with _$EnableNotificationsState {
  const factory EnableNotificationsState.initial() = _Initial;

  const factory EnableNotificationsState.permanentlyDenied() =
      _PermanentlyDenied;

  const factory EnableNotificationsState.denied() = _Denied;

  const factory EnableNotificationsState.approved(VoidCallback? onDone) =
      _Approved;
}
