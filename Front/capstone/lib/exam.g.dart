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
      problemList: (fields[0] as List).cast<dynamic>(),
      remainTime: fields[1] as int,
      directory: fields[2] as String,
      dateCode: fields[3] as String,
    )..userAnswer = (fields[4] as List).cast<int>();
  }

  @override
  void write(BinaryWriter writer, Exam obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.problemList)
      ..writeByte(1)
      ..write(obj.remainTime)
      ..writeByte(2)
      ..write(obj.directory)
      ..writeByte(3)
      ..write(obj.dateCode)
      ..writeByte(4)
      ..write(obj.userAnswer);
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
    return Problem()
      ..problemType = fields[5] as int
      ..textType = fields[6] as int
      ..difficulty = fields[7] as int
      ..answer = fields[8] as int;
  }

  @override
  void write(BinaryWriter writer, Problem obj) {
    writer
      ..writeByte(4)
      ..writeByte(5)
      ..write(obj.problemType)
      ..writeByte(6)
      ..write(obj.textType)
      ..writeByte(7)
      ..write(obj.difficulty)
      ..writeByte(8)
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

class CubeProblemAdapter extends TypeAdapter<CubeProblem> {
  @override
  final int typeId = 2;

  @override
  CubeProblem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CubeProblem(
      primitiveData: fields[9] as DevCube,
    )
      ..problemType = fields[5] as int
      ..textType = fields[6] as int
      ..difficulty = fields[7] as int
      ..answer = fields[8] as int;
  }

  @override
  void write(BinaryWriter writer, CubeProblem obj) {
    writer
      ..writeByte(5)
      ..writeByte(9)
      ..write(obj.primitiveData)
      ..writeByte(5)
      ..write(obj.problemType)
      ..writeByte(6)
      ..write(obj.textType)
      ..writeByte(7)
      ..write(obj.difficulty)
      ..writeByte(8)
      ..write(obj.answer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CubeProblemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
