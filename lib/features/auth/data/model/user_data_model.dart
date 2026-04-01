class UserDataModel {
  const UserDataModel({
    this.result,
    this.token,
    this.imeiList,
    this.loggerList,
  });

  final String? result;
  final String? token;
  final List<String>? imeiList;
  final List<String>? loggerList;

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      result: _nullableString(json['result']),
      token: _nullableString(json['token']),
      imeiList: _nullableStringList(json['imeilist']),
      loggerList: _nullableStringList(json['loggerlist']),
    );
  }

  Map<String, dynamic> toJson() => {
        'result': result,
        'token': token,
        'imeilist': imeiList,
        'loggerlist': loggerList,
      };

  /// Pairs [loggerList] with [imeiList] by index; skips rows where both are empty.
  List<({String title, String imei})> get pairedDevices {
    final imeis = imeiList ?? const <String>[];
    final names = loggerList ?? const <String>[];
    final n = imeis.length > names.length ? imeis.length : names.length;
    final out = <({String title, String imei})>[];
    for (var i = 0; i < n; i++) {
      final imei = i < imeis.length ? imeis[i].trim() : '';
      final name = i < names.length ? names[i].trim() : '';
      if (imei.isEmpty && name.isEmpty) continue;
      final title = name.isNotEmpty
          ? name
          : (imei.isNotEmpty ? imei : 'Device ${i + 1}');
      final imeiDisplay = imei.isNotEmpty ? imei : '—';
      out.add((title: title, imei: imeiDisplay));
    }
    return out;
  }

  static String? _nullableString(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  static List<String>? _nullableStringList(dynamic value) {
    if (value == null) return null;
    if (value is! List) return null;
    return value.map((e) => e?.toString() ?? '').toList();
  }
}
