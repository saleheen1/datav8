import 'package:datav8/core/db/api.dart';
import 'package:datav8/core/db/db_client.dart';
import 'package:datav8/core/db/response_model.dart';
import 'package:datav8/core/utils/parse_json_map.dart';
import 'package:datav8/features/duration/data/model/chart_retrieve_model.dart';
import 'package:get/get.dart';

class ChartRepo {
  final dbClient = Get.find<DbClient>();

  Future<ResponseModel<ChartRetrieveModel?>> retrieve(
    String imei,
    String token,
    int start,
    int end,
  ) async {
    return await dbClient.requestWrapper<ChartRetrieveModel>(() async {
      final dioResponse = await dbClient.instance.post(
        Api.retrieve,
        data: {
          'imei': imei,
          'token': token,
          'op': 'retrievedecimate',
          "num_pts": 10,
          'start': start,
          'end': end,
        },
      );
      final map = parseJsonMap(dioResponse.data);
      if (map == null) {
        return ResponseModel<ChartRetrieveModel?>(
          false,
          'Invalid retrieve response',
          null,
        );
      }
      final parsed = ChartRetrieveModel.fromJson(map);
      return ResponseModel<ChartRetrieveModel?>(
        true,
        'Retrieve succeed',
        parsed,
      );
    }, functionName: 'retrieve');
  }
}
