// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_action.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationActionAdapter extends TypeAdapter<NotificationAction> {
  @override
  final typeId = 1;

  @override
  NotificationAction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationAction(
      id: fields[0] as String,
      title: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationAction obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationActionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
