import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:postman_penugasan1/models/cart.dart';
import 'package:postman_penugasan1/models/response_data_map.dart';
import 'package:postman_penugasan1/models/user_login.dart';
import 'package:postman_penugasan1/services/url.dart' as url_cfg;

class CheckoutService {
  Future<ResponseDataMap> submitPurchase(List<Cart> items) async {
    final cleaned = items.where((c) => c.id != null).toList();
    if (cleaned.isEmpty) {
      return ResponseDataMap(status: false, message: 'Keranjang tidak valid.');
    }

    final userLogin = UserLogin();
    final user = await userLogin.getUserLogin();
    if (user.status == false) {
      return ResponseDataMap(
        status: false,
        message: 'anda belum login / token invalid',
      );
    }

    final uri = Uri.parse('${url_cfg.baseUrl}${url_cfg.checkoutPath}');

    final bodyMap = <String, dynamic>{
      'pesan': cleaned
          .map(
            (c) => <String, dynamic>{
              'barang_id': c.id!,
              'qty': c.quantity ?? 1,
            },
          )
          .toList(),
    };

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Authorization': 'Bearer ${user.token}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bodyMap),
      );

      final decoded = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode != 200) {
        final msg = _messageFromDecoded(decoded) ??
            'Checkout gagal (HTTP ${response.statusCode})';
        return ResponseDataMap(status: false, message: msg);
      }

      if (decoded is! Map<String, dynamic>) {
        return ResponseDataMap(
          status: false,
          message: 'Application Error',
        );
      }

      final ok = decoded['status'] == true;
      final message = _messageFromDecoded(decoded) ??
          (ok ? 'Checkout berhasil' : 'Checkout gagal');
      dynamic rawData = decoded['data'];
      Map? dataMap;
      if (rawData is Map) {
        dataMap = Map<String, dynamic>.from(rawData);
      }

      return ResponseDataMap(
        status: ok,
        message: message,
        data: dataMap,
      );
    } catch (e) {
      return ResponseDataMap(
        status: false,
        message: 'Gagal checkout: $e',
      );
    }
  }

  static String? _messageFromDecoded(dynamic decoded) {
    if (decoded is! Map<String, dynamic>) return null;
    final m = decoded['message'];
    if (m == null) return null;
    if (m is String) return m;
    if (m is Map) {
      final parts = <String>[];
      for (final entry in m.entries) {
        final v = entry.value;
        if (v is List && v.isNotEmpty) {
          parts.add(v.first.toString());
        } else {
          parts.add(v.toString());
        }
      }
      if (parts.isNotEmpty) return parts.join(' ');
    }
    return m.toString();
  }
}
