class ColourData {
  final String name;
  final String hex;
  final double hue;
  final double saturation;
  final double brightness;

  final String temperature; // warm / cool / neutral
  final String tone; // soft / muted / vibrant

  const ColourData({
    required this.name,
    required this.hex,
    required this.hue,
    required this.saturation,
    required this.brightness,
    required this.temperature,
    required this.tone,
  });
}