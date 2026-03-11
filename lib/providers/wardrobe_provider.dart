import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/clothing_item.dart';

class WardrobeProvider extends ChangeNotifier {

  late Box<ClothingItem> wardrobeBox;

  List<ClothingItem> items = [];

  Future<void> init() async {

    wardrobeBox = await Hive.openBox<ClothingItem>('wardrobe');

    items = wardrobeBox.values.toList();

    notifyListeners();
  }

  void addItem(ClothingItem item) {

    wardrobeBox.put(item.id, item);

    items = wardrobeBox.values.toList();

    notifyListeners();
  }

  void removeItem(String id) {

    wardrobeBox.delete(id);

    items = wardrobeBox.values.toList();

    notifyListeners();
  }
}