// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clothing_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClothingItemAdapter extends TypeAdapter<ClothingItem> {
  @override
  final int typeId = 0;

  @override
  ClothingItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClothingItem(
      id: fields[0] as String,
      imagePath: fields[1] as String,
      clothingType: fields[2] as String,
      occasion: fields[3] as String,
      colourName: fields[4] as String,
      hexCode: fields[5] as String,
      hue: fields[6] as double,
      saturation: fields[7] as double,
      brightness: fields[8] as double,
      temperature: fields[9] as String,
      tone: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClothingItem obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.clothingType)
      ..writeByte(3)
      ..write(obj.occasion)
      ..writeByte(4)
      ..write(obj.colourName)
      ..writeByte(5)
      ..write(obj.hexCode)
      ..writeByte(6)
      ..write(obj.hue)
      ..writeByte(7)
      ..write(obj.saturation)
      ..writeByte(8)
      ..write(obj.brightness)
      ..writeByte(9)
      ..write(obj.temperature)
      ..writeByte(10)
      ..write(obj.tone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClothingItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
