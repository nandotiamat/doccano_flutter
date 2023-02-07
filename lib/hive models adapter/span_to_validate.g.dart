// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../components/span_to_validate.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpanToValidateAdapter extends TypeAdapter<SpanToValidate> {
  @override
  final int typeId = 1;

  @override
  SpanToValidate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpanToValidate(
      label: fields[0] as Label,
      span: fields[1] as Span,
      validated: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SpanToValidate obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.span)
      ..writeByte(2)
      ..write(obj.validated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpanToValidateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
