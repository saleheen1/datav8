import 'package:datav8/core/db/db_client.dart';
import 'package:datav8/core/db/response_model.dart';
import 'package:datav8/core/utils/parse_json_map.dart';
import 'package:datav8/features/home/data/model/hardware_sensor_option_model.dart';
import 'package:get/get.dart';

class HardwareSensorRepo {
  static const String _baseUrl = 'https://www.datav8.com';
  final dbClient = Get.find<DbClient>();

  Future<ResponseModel<List<HardwareSensorOptionModel>?>> fetchSensorList() async {
    return await dbClient.requestWrapper<List<HardwareSensorOptionModel>>(() async {
      final response = await dbClient.instance.get(
        '$_baseUrl/get_available_sensors.php?method=list',
      );
      final map = parseJsonMap(response.data);
      if (map == null || '${map['status']}' != 'success') {
        return ResponseModel<List<HardwareSensorOptionModel>?>(
          false,
          'Invalid sensor list response',
          null,
        );
      }
      final raw = map['value'];
      if (raw is! List) {
        return ResponseModel<List<HardwareSensorOptionModel>?>(
          false,
          'Invalid sensor list',
          null,
        );
      }
      final items = <HardwareSensorOptionModel>[];
      for (final e in raw) {
        if (e is! Map) continue;
        final item = HardwareSensorOptionModel.fromListJson(
          Map<String, dynamic>.from(e),
        );
        if (item.index.isEmpty) continue;
        items.add(item);
      }
      return ResponseModel<List<HardwareSensorOptionModel>?>(
        true,
        'Sensors loaded',
        items,
      );
    }, functionName: 'fetchSensorList');
  }

  Future<ResponseModel<HardwareSensorOptionModel?>> fetchSensorDetail(
    HardwareSensorOptionModel sensor,
  ) async {
    return await dbClient.requestWrapper<HardwareSensorOptionModel>(() async {
      final response = await dbClient.instance.get(
        '$_baseUrl/get_available_sensors.php?method=sensor&index=${sensor.index}',
      );
      final map = parseJsonMap(response.data);
      if (map == null || '${map['status']}' != 'success') {
        return ResponseModel<HardwareSensorOptionModel?>(
          false,
          'Invalid sensor detail response',
          null,
        );
      }
      final value = map['value'];
      if (value is! Map) {
        return ResponseModel<HardwareSensorOptionModel?>(
          false,
          'Invalid sensor detail payload',
          null,
        );
      }
      final detail = Map<String, dynamic>.from(value);
      return ResponseModel<HardwareSensorOptionModel?>(
        true,
        'Sensor detail loaded',
        sensor.copyWith(
          sensorImageUrl: _toAbsoluteUrl('${detail['sensorimage'] ?? ''}'),
          moduleImageUrl: _toAbsoluteUrl('${detail['moduleimage'] ?? ''}'),
          scaleFactor: '${detail['scalefactor'] ?? ''}'.trim(),
          zeroOffset: '${detail['zerooffset'] ?? ''}'.trim(),
        ),
      );
    }, functionName: 'fetchSensorDetail');
  }

  String _toAbsoluteUrl(String raw) {
    final value = raw.trim();
    if (value.isEmpty) return '';
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }
    if (value.startsWith('/')) return '$_baseUrl$value';
    return '$_baseUrl/$value';
  }
}
