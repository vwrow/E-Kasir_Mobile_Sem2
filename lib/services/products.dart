import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:postman_penugasan1/models/response_data_list.dart';
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
}
