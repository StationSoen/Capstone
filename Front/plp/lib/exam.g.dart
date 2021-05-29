// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExamAdapter extends TypeAdapter<Exam> {
  @override
  final int typeId = 0;

  @override
  Exam read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Exam(
      problemList: (fields[0] as List).cast<Problem>(),
      directory: fields[2] as String,
      dateCode: fields[5] as String,
      settingTime: fields[3] as int,
      examType: fields[11] as int,
    )
      ..elapsedTime = fields[1] as int
      ..complete = fields[4] as bool
      ..userAnswer = (fields[6] as List).cast<int>();
  }

  @override
  void write(BinaryWriter writer, Exam obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.problemList)
      ..writeByte(1)
      ..write(obj.elapsedTime)
      ..writeByte(2)
      ..write(obj.directory)
      ..writeByte(3)
      ..write(obj.settingTime)
      ..writeByte(4)
      ..write(obj.complete)
      ..writeByte(5)
      ..write(obj.dateCode)
      ..writeByte(6)
      ..write(obj.userAnswer)
      ..writeByte(11)
      ..write(obj.examType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExamAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProblemAdapter extends TypeAdapter<Problem> {
  @override
  final int typeId = 1;

  @override
  Problem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Problem(
      textType: fields[8] as int,
      problemType: fields[7] as int,
      difficulty: fields[9] as int,
      answer: fields[10] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Problem obj) {
    writer
      ..writeByte(4)
      ..writeByte(7)
      ..write(obj.problemType)
      ..writeByte(8)
      ..write(obj.textType)
      ..writeByte(9)
      ..write(obj.difficulty)
      ..writeByte(10)
      ..write(obj.answer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProblemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
