// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paper_fold.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaperFoldAdapter extends TypeAdapter<PaperFold> {
  @override
  final int typeId = 5;

  @override
  PaperFold read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaperFold(
      fields[14] as int,
      fields[13] as int,
      fields[18] as dynamic,
    )
      ..example = fields[15] as dynamic
      ..suggestion = fields[16] as dynamic
      ..answer = fields[17] as dynamic
      ..rng = fields[19] as Random;
  }

  @override
  void write(BinaryWriter writer, PaperFold obj) {
    writer
      ..writeByte(7)
      ..writeByte(13)
      ..write(obj.type)
      ..writeByte(14)
      ..write(obj.level)
      ..writeByte(15)
      ..write(obj.example)
      ..writeByte(16)
      ..write(obj.suggestion)
      ..writeByte(17)
      ..write(obj.answer)
      ..writeByte(18)
      ..write(obj.seed)
      ..writeByte(19)
      ..write(obj.rng);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaperFoldAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
