import 'dart:convert';

import 'package:datav8/core/db/api.dart';
import 'package:datav8/core/db/db_client.dart';
import 'package:datav8/core/db/response_model.dart';
import 'package:get/get.dart';

class ChartRepo {
  final dbClient = Get.find<DbClient>();

  Future<ResponseModel<Map<String, dynamic>?>> retrieve(
    String imei,
    String token,
    int start,
    int end,
  ) async {
    return await dbClient.requestWrapper<Map<String, dynamic>>(() async {
      final response = await dbClient.instance.post(
        Api.apiToken,
        data: {
          'imei': imei,
          'token': token,
          'op': 'retrieve',
          'start': start,
          'end': end,
        },
      );
      final map = _parseJsonMap(response.data);
      if (map == null) {
        return ResponseModel<Map<String, dynamic>?>(
          false,
          'Unexpected response format',
          null,
        );
      }
      return ResponseModel<Map<String, dynamic>?>(
        true,
        'Retrieve succeed',
        map,
      );
    }, functionName: 'retrieve');
  }
}

Map<String, dynamic>? _parseJsonMap(dynamic data) {
  if (data == null) return null;
  if (data is Map) return Map<String, dynamic>.from(data);
  if (data is String) {
    final trimmed = data.trim();
    if (trimmed.isEmpty) return null;
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
  }
  return null;
}
