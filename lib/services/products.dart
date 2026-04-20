import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:postman_penugasan1/models/response_data_list.dart';
import 'package:postman_penugasan1/models/response_data_map.dart';
import 'package:postman_penugasan1/models/product_models.dart';
import 'package:postman_penugasan1/models/user_login.dart';
import 'package:postman_penugasan1/services/url.dart' as url;

class ProductService {
  Future<ResponseDataList> getProducts() async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    if (user.status == false) {
      return ResponseDataList(
        status: false,
        message: 'anda belum login / token invalid',
      );
    }

    try {
      var uri = Uri.parse(url.baseUrl + "/admin/getbarang");
      Map<String, String> headers = {"Authorization": 'Bearer ${user.token}'};
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is! Map<String, dynamic>) {
          return ResponseDataList(
            status: false,
            message: 'Format respons produk tidak valid',
          );
        }

        if (decoded["status"] == true) {
          final dynamic rawData = decoded["data"];
          List<dynamic> items = [];

          if (rawData is List) {
            items = rawData;
          } else if (rawData is Map<String, dynamic> &&
              rawData["data"] is List) {
            items = rawData["data"] as List;
          }

          final products = items
              .whereType<Map>()
              .map((r) => ProductModel.fromJson(Map<String, dynamic>.from(r)))
              .toList();

          return ResponseDataList(
            status: true,
            message: 'success load data',
            data: products,
          );
        } else {
          return ResponseDataList(
            status: false,
            message: decoded["message"]?.toString() ?? 'Failed load data',
          );
        }
      } else {
        return ResponseDataList(
          status: false,
          message: "gagal load produk dengan code error ${response.statusCode}",
        );
      }
    } catch (e) {
      return ResponseDataList(
        status: false,
        message: "gagal memproses data produk: $e",
      );
    }
  }

  Future<ResponseDataList> getUserProducts() async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    if (user.status == false) {
      return ResponseDataList(
        status: false,
        message: 'anda belum login / token invalid',
      );
    }

    try {
      var uri = Uri.parse(url.baseUrl + "/user/getbarang");
      Map<String, String> headers = {"Authorization": 'Bearer ${user.token}'};
      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded is! Map<String, dynamic>) {
          return ResponseDataList(
            status: false,
            message: 'Format respons produk tidak valid',
          );
        }

        if (decoded["status"] == true) {
          final dynamic rawData = decoded["data"];
          List<dynamic> items = [];

          if (rawData is List) {
            items = rawData;
          } else if (rawData is Map<String, dynamic> &&
              rawData["data"] is List) {
            items = rawData["data"] as List;
          }

          final products = items
              .whereType<Map>()
              .map((r) => ProductModel.fromJson(Map<String, dynamic>.from(r)))
              .toList();

          return ResponseDataList(
            status: true,
            message: 'Loading Sukses',
            data: products,
          );
        } else {
          return ResponseDataList(
            status: false,
            message: decoded["message"]?.toString() ?? 'Loading Gagal',
          );
        }
      } else {
        return ResponseDataList(
          status: false,
          message: "Gagal Load; Error ${response.statusCode}",
        );
      }
    } catch (e) {
      return ResponseDataList(
        status: false,
        message: "Gagal Memproses Data: $e",
      );
    }
  }

  Future insertProduct(request, image, id) async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();
    if (user.status == false) {
      ResponseDataList response = ResponseDataList(
        status: false,
        message: 'Token Invalid',
      );
      return response;
    }
    Map<String, String> headers = {
      "Authorization": 'Bearer ${user.token}',
      "Accept": "application/json",
    };
    http.MultipartRequest reponse;
    if (id == null) {
      reponse = http.MultipartRequest(
        'POST',
        Uri.parse("${url.baseUrl}/admin/insertbarang"),
      );
    } else {
      reponse = http.MultipartRequest(
        'POST',
        Uri.parse("${url.baseUrl}/admin/updatebarang/$id"),
      );
    }
    if (image != null) {
      reponse.files.add(await http.MultipartFile.fromPath('image', image.path));
    }
    reponse.headers.addAll(headers);
    reponse.fields['nama_barang'] = (request["nama_barang"] ?? "").toString();
    reponse.fields['deskripsi'] = (request["deskripsi"] ?? "").toString();
    reponse.fields['stok'] = (request["stok"] ?? "").toString();
    reponse.fields['harga'] = (request["harga"] ?? "").toString();

    var res = await reponse.send();
    var result = await http.Response.fromStream(res);

    try {
      final data = json.decode(result.body);
      if (data is Map<String, dynamic>) {
        if (res.statusCode == 200 && data["status"] == true) {
          ResponseDataMap response = ResponseDataMap(
            status: true,
            message: data["message"]?.toString() ?? 'Update Sukses',
            data: data["data"] is Map
                ? Map<String, dynamic>.from(data["data"])
                : null,
          );
          return response;
        }

        String message = data["message"]?.toString() ?? 'Unknown Error';
        if (data["message"] is Map) {
          final Map<String, dynamic> messages = Map<String, dynamic>.from(
            data["message"],
          );
          final flattened = messages.values
              .map(
                (v) => v is List && v.isNotEmpty
                    ? v.first.toString()
                    : v.toString(),
              )
              .join(", ");
          if (flattened.isNotEmpty) message = flattened;
        }
        return ResponseDataMap(status: false, message: message);
      }
    } catch (_) {}

    return ResponseDataMap(
      status: false,
      message: "Upload gagal dengan code ${res.statusCode}",
    );
  }

  Future hapusProduct(context, id) async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();
    if (user.status == false) {
      ResponseDataList response = ResponseDataList(
        status: false,
        message: 'anda belum login / token invalid',
      );
      return response;
    }

    if (id == null) {
      return ResponseDataList(status: false, message: 'ID produk tidak valid');
    }

    final uri = Uri.parse("${url.baseUrl}/admin/hapusbarang/$id");
    final headers = {
      "Authorization": 'Bearer ${user.token}',
      "Accept": "application/json",
    };

    Future<ResponseDataList?> parseDeleteResponse(http.Response res) async {
      try {
        final body = json.decode(res.body);
        if (body is Map<String, dynamic>) {
          final bool isSuccess = body["status"] == true;
          final String message =
              body["message"]?.toString() ??
              (isSuccess ? 'success hapus data' : 'Failed hapus data');
          return ResponseDataList(status: isSuccess, message: message);
        }
      } catch (_) {}

      if (res.statusCode == 200) {
        return ResponseDataList(status: true, message: 'success hapus data');
      }
      return null;
    }

    final deleteRes = await http.delete(uri, headers: headers);
    final parsedDelete = await parseDeleteResponse(deleteRes);
    if (parsedDelete != null) return parsedDelete;

    // Some backends expose delete endpoint via POST.
    final postRes = await http.post(uri, headers: headers);
    final parsedPost = await parseDeleteResponse(postRes);
    if (parsedPost != null) return parsedPost;

    return ResponseDataList(
      status: false,
      message:
          "gagal hapus produk. DELETE:${deleteRes.statusCode}, POST:${postRes.statusCode}",
    );
  }
}
