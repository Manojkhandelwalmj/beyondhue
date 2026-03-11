class ColourEntry {
  final String name;
  final double hueStart;
  final double hueEnd;

  const ColourEntry({
    required this.name,
    required this.hueStart,
    required this.hueEnd,
  });
}

class ColourDatabase {
  static const List<ColourEntry> colours = [

    ColourEntry(name: "Red", hueStart: 0, hueEnd: 15),
    ColourEntry(name: "Crimson", hueStart: 15, hueEnd: 30),
    ColourEntry(name: "Orange", hueStart: 30, hueEnd: 45),
    ColourEntry(name: "Amber", hueStart: 45, hueEnd: 60),
    ColourEntry(name: "Yellow", hueStart: 60, hueEnd: 75),

    ColourEntry(name: "Lime", hueStart: 75, hueEnd: 95),
    ColourEntry(name: "Green", hueStart: 95, hueEnd: 140),
    ColourEntry(name: "Emerald", hueStart: 140, hueEnd: 165),

    ColourEntry(name: "Teal", hueStart: 165, hueEnd: 185),
    ColourEntry(name: "Cyan", hueStart: 185, hueEnd: 200),

    ColourEntry(name: "Sky Blue", hueStart: 200, hueEnd: 215),
    ColourEntry(name: "Blue", hueStart: 215, hueEnd: 235),

    ColourEntry(name: "Indigo", hueStart: 235, hueEnd: 255),
    ColourEntry(name: "Violet", hueStart: 255, hueEnd: 275),
    ColourEntry(name: "Purple", hueStart: 275, hueEnd: 295),

    ColourEntry(name: "Magenta", hueStart: 295, hueEnd: 320),
    ColourEntry(name: "Rose", hueStart: 320, hueEnd: 345),
    ColourEntry(name: "Pink", hueStart: 345, hueEnd: 360),
  ];
}