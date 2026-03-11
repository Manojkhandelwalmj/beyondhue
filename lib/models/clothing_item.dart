import 'package:hive/hive.dart';

part 'clothing_item.g.dart';

@HiveType(typeId: 0)
class ClothingItem extends HiveObject {

  @HiveField(0)
  String id;

  @HiveField(1)
  String imagePath;

  @HiveField(2)
  String clothingType; // shirt, pant, tshirt

  @HiveField(3)
  String occasion; // casual, formal, party

  @HiveField(4)
  String colourName;

  @HiveField(5)
  String hexCode;

  @HiveField(6)
  double hue;

  @HiveField(7)
  double saturation;

  @HiveField(8)
  double brightness;

  @HiveField(9)
  String temperature; // warm / cool / neutral

  @HiveField(10)
  String tone; // light / medium / dark

  ClothingItem({
    required this.id,
    required this.imagePath,
    required this.clothingType,
    required this.occasion,
    required this.colourName,
    required this.hexCode,
    required this.hue,
    required this.saturation,
    required this.brightness,
    required this.temperature,
    required this.tone,
  });
}