// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dev_cube.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DevCubeAdapter extends TypeAdapter<DevCube> {
  @override
  final int typeId = 3;

  @override
  DevCube read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DevCube(
      fields[11] as int,
      fields[10] as int,
    )
      ..example = fields[12] as dynamic
      ..suggestion = fields[13] as dynamic
      ..answer = fields[14] as dynamic;
  }

  @override
  void write(BinaryWriter writer, DevCube obj) {
    writer
      ..writeByte(5)
      ..writeByte(10)
      ..write(obj.type)
      ..writeByte(11)
      ..write(obj.level)
      ..writeByte(12)
      ..write(obj.example)
      ..writeByte(13)
      ..write(obj.suggestion)
      ..writeByte(14)
      ..write(obj.answer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DevCubeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
