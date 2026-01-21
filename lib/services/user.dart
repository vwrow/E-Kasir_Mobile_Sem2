import 'dart:convert';
import 'package:postman_penugasan1/models/response_data_map.dart';
import 'package:postman_penugasan1/models/user_login.dart';
import 'package:postman_penugasan1/services/url.dart' as url;
import 'package:http/http.dart' as http;

class UserService {
  
  Future registerUser(data) async {
    var uri = Uri.parse(url.BaseUrl + "/auth/register");
    var register = await http.post(uri, body: data);

    if (register.statusCode == 200) {
      var data = json.decode(register.body);
      if (data["status"] == true) {
        ResponseDataMap response = ResponseDataMap(
          status: true,
          message: "Sukses Menambah User",
          data: data,
        );
        return response;
      } else {
        var message = '';
        for (String key in data["message"].keys) {
          message += data["message"][key][0].toString();
        }
        if (message == "The email has already been taken.") {
          message = "Email Sudah Terdaftar";
        }

        ResponseDataMap response = ResponseDataMap(
          status: false,
          message: message,
        );
        return response;
      }
    } else {
      ResponseDataMap response = ResponseDataMap(
        status: false,
        message: "Register Gagal - Error ${register.statusCode}",
      );
      return response;
    }
  }

  Future loginUser(data) async {
    var uri = Uri.parse(url.BaseUrl + "/auth/login");
    var login = await http.post(uri, body: data);

    if (login.statusCode == 200) {
      var data = json.decode(login.body); 
      if (data["status"] == true) {
        UserLogin userLogin = UserLogin(
          status: data["status"],
          token: data["token"],
          message: data["message"],
          id: data["user"]["id"],
          nama_user: data["user"]["nama_user"],
          email: data["user"]["email"],
          role: data["user"]["role"],
        );
        await userLogin.setUserPrefs();
        ResponseDataMap response = ResponseDataMap(
          status: true,
          message: "Sukses Login User",
          data: data,
        );
        return response;
      } else {
        ResponseDataMap response = ResponseDataMap(
          status: false,
          message: 'Email & Password Tidak Cocok',
        );
        return response;
      }
    } else {
      ResponseDataMap response = ResponseDataMap(
        status: false,
        message: "Login Gagal - Error ${login.statusCode}",
      );
      return response;
    }
  }
}
