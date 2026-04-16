class ChartRetrieveModel {
  const ChartRetrieveModel({this.status, this.message, this.value});

  final String? status;
  final String? message;
  final List<ChartRetrieveEntry>? value;

  factory ChartRetrieveModel.fromJson(Map<String, dynamic> json) {
    return ChartRetrieveModel(
      status: _nullableString(json['status']),
      message: _nullableString(json['message']),
      value: _entries(json['value']),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'value': value?.map((e) => e.toJson()).toList(),
  };

  static List<ChartRetrieveEntry>? _entries(dynamic raw) {
    if (raw == null || raw is! List) return null;
    final out = <ChartRetrieveEntry>[];
    for (final e in raw) {
      if (e is Map<String, dynamic>) {
        out.add(ChartRetrieveEntry.fromJson(e));
      } else if (e is Map) {
        out.add(ChartRetrieveEntry.fromJson(Map<String, dynamic>.from(e)));
      }
    }
    return out;
  }
}

class ChartRetrieveEntry {
  const ChartRetrieveEntry({
    this.time,
    this.ch1,
    this.ch2,
    this.ch3,
    this.ch4,
    this.ch5,
    this.batt,
    this.gsm,
    this.online,
  });

  final String? time;
  final double? ch1;
  final double? ch2;
  final double? ch3;
  final double? ch4;
  final double? ch5;
  final double? batt;
  final String? gsm;
  final String? online;

  /// API uses `"yyyy-MM-dd HH:mm:ss"` for ordering samples.
  DateTime? get parsedTime {
    final s = time;
    if (s == null || s.isEmpty) return null;
    final normalized = s.contains('T') ? s : s.replaceFirst(' ', 'T');
    return DateTime.tryParse(normalized);
  }

  factory ChartRetrieveEntry.fromJson(Map<String, dynamic> json) {
    return ChartRetrieveEntry(
      time: _nullableString(json['time']),
      ch1: _toDouble(json['ch1']),
      ch2: _toDouble(json['ch2']),
      ch3: _toDouble(json['ch3']),
      ch4: _toDouble(json['ch4']),
      ch5: _toDouble(json['ch5']),
      batt: _toDouble(json['batt']),
      gsm: _nullableString(json['gsm']),
      online: _nullableString(json['online']),
    );
  }

  Map<String, dynamic> toJson() => {
    'time': time,
    'ch1': ch1,
    'ch2': ch2,
    'ch3': ch3,
    'ch4': ch4,
    'ch5': ch5,
    'batt': batt,
    'gsm': gsm,
    'online': online,
  };
}

String? _nullableString(dynamic v) {
  if (v == null) return null;
  return v.toString();
}

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}
