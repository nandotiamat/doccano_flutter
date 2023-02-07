// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../models/span.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpanAdapter extends TypeAdapter<Span> {
  @override
  final int typeId = 3;

  @override
  Span read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Span(
      id: fields[0] as int,
      prob: fields[1] as double,
      user: fields[2] as int,
      example: fields[3] as int,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
      label: fields[6] as int,
      startOffset: fields[7] as int,
      endOffset: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Span obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.prob)
      ..writeByte(2)
      ..write(obj.user)
      ..writeByte(3)
      ..write(obj.example)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.label)
      ..writeByte(7)
      ..write(obj.startOffset)
      ..writeByte(8)
      ..write(obj.endOffset);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
