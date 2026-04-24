class HardwareSensorOptionModel {
  const HardwareSensorOptionModel({
    required this.index,
    required this.name,
    required this.boardName,
    this.sensorImageUrl = '',
    this.moduleImageUrl = '',
    this.scaleFactor = '',
    this.zeroOffset = '',
  });

  final String index;
  final String name;
  final String boardName;
  final String sensorImageUrl;
  final String moduleImageUrl;
  final String scaleFactor;
  final String zeroOffset;

  String get label => '$name ($boardName)';

  HardwareSensorOptionModel copyWith({
    String? sensorImageUrl,
    String? moduleImageUrl,
    String? scaleFactor,
    String? zeroOffset,
  }) {
    return HardwareSensorOptionModel(
      index: index,
      name: name,
      boardName: boardName,
      sensorImageUrl: sensorImageUrl ?? this.sensorImageUrl,
      moduleImageUrl: moduleImageUrl ?? this.moduleImageUrl,
      scaleFactor: scaleFactor ?? this.scaleFactor,
      zeroOffset: zeroOffset ?? this.zeroOffset,
    );
  }

  factory HardwareSensorOptionModel.fromListJson(Map<String, dynamic> json) {
    return HardwareSensorOptionModel(
      index: '${json['index'] ?? ''}'.trim(),
      name: '${json['name'] ?? ''}'.trim(),
      boardName: '${json['boardname'] ?? ''}'.trim(),
    );
  }
}
