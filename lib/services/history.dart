import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:postman_penugasan1/models/hisstory.dart';
import 'package:postman_penugasan1/models/response_data_list.dart';
import 'package:postman_penugasan1/models/user_login.dart';
import 'package:postman_penugasan1/services/url.dart' as url;

class HistoryService {
  /// GET `[baseUrl]/use/history_trans` — Bearer token required.
  Future<ResponseDataList> getHistoryTransactions() async {
    final userLogin = UserLogin();
    final user = await userLogin.getUserLogin();

    if (user.status == false) {
      return ResponseDataList(
        status: false,
        message: 'anda belum login / token invalid',
      );
    }

    try {
      final uri = Uri.parse('${url.baseUrl}/user/history_trans');
      final headers = {'Authorization': 'Bearer ${user.token}'};
      final response = await http.get(uri, headers: headers);

      if (response.statusCode != 200) {
        return ResponseDataList(
          status: false,
          message: 'gagal load riwayat dengan code error ${response.statusCode}',
        );
      }

      final decoded = json.decode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return ResponseDataList(
          status: false,
          message: 'Format respons riwayat tidak valid',
        );
      }

      if (decoded['status'] != true) {
        return ResponseDataList(
          status: false,
          message: decoded['message']?.toString() ?? 'Gagal memuat riwayat',
        );
      }

      final dynamic rawData = decoded['data'];
      List<dynamic> items = [];

      if (rawData is List) {
        items = rawData;
      } else if (rawData is Map<String, dynamic> && rawData['data'] is List) {
        items = rawData['data'] as List;
      }

      final histories = items
          .whereType<Map>()
          .map(
            (row) => HistoryTransaction.fromJson(Map<String, dynamic>.from(row)),
          )
          .toList();

      return ResponseDataList(
        status: true,
        message: decoded['message']?.toString() ?? 'Berhasil memuat riwayat',
        data: histories,
      );
    } catch (e) {
      return ResponseDataList(
        status: false,
        message: 'gagal memproses data riwayat: $e',
      );
    }
  }
}
