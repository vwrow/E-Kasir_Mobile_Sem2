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

    var uri = Uri.parse(url.adminUrl + "/getbarang");
    Map<String, String> headers = {"Authorization": 'Bearer ${user.token}'};
    var response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["status"] == true) {
        List<ProductModel> products = (data["data"] as List)
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
          message: data["message"]?.toString() ?? 'Failed load data',
        );
      }
    } else {
      return ResponseDataList(
        status: false,
        message: "gagal load produk dengan code error ${response.statusCode}",
      );
    }
  }

    Future insertProduct(request, image, id) async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();
    if (user.status == false) {
      ResponseDataList response = ResponseDataList(
        status: false,
        message: 'anda belum login / token invalid',
      );
      return response;
    }
    Map<String, String> headers = {
      "Authorization": 'Bearer ${user.token}',
      "Content-type": "multipart/form-data",
    };
    var reponse;
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
      reponse.files.add(
        http.MultipartFile(
          'posterpath',
          image.readAsBytes().asStream(),
          image.lengthSync(),
          filename: image.path.split('/').last,
        ),
      );
    }
    reponse.headers.addAll(headers);
    reponse.fields['title'] = request["title"];
    reponse.fields['voteaverage'] = request["voteaverage"];
    reponse.fields['overview'] = request["overview"];

    var res = await reponse.send();
    var result = await http.Response.fromStream(res);

    if (res.statusCode == 200) {
      var data = json.decode(result.body);
      if (data["status"] == true) {
        ResponseDataMap response = ResponseDataMap(
          status: true,
          message: 'success insert / update data',
        );
        return response;
      } else {
        ResponseDataMap response = ResponseDataMap(
          status: false,
          message: 'Failed insert / update data',
        );
        return response;
      }
    } else {
      ResponseDataMap response = ResponseDataMap(
        status: false,
        message: "gagal load movie dengan code error ${res.statusCode}",
      );
      return response;
    }
  }

  Future hapusProduct(context, id) async {
    UserLogin userLogin = UserLogin();
    var uri = Uri.parse(url.baseUrl + "/admin/hapusbarang/$id");
    var user = await userLogin.getUserLogin();
    if (user.status == false) {
      ResponseDataList response = ResponseDataList(
        status: false,
        message: 'anda belum login / token invalid',
      );
      return response;
    }
    Map<String, String> headers = {"Authorization": 'Bearer ${user.token}'};
    var hapusMovie = await http.delete(uri, headers: headers);

    if (hapusMovie.statusCode == 200) {
      var result = json.decode(hapusMovie.body);
      if (result["status"] == true) {
        ResponseDataList response = ResponseDataList(
          status: true,
          message: 'success hapus data',
        );
        return response;
      } else {
        ResponseDataList response = ResponseDataList(
          status: false,
          message: 'Failed hapus data',
        );
        return response;
      }
    } else {
      ResponseDataList response = ResponseDataList(
        status: false,
        message: "gagal hapus movie dengan code error ${hapusMovie.statusCode}",
      );
      return response;
    }
  }
}
