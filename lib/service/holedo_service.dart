import 'dart:convert';

import 'package:fetchdata/controller/auth_controller.dart';
import 'package:fetchdata/model/holedo_model.dart';
import 'package:get/get.dart' as Store;
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class HoledoService {
  /// fetch data
  Future<HoledoModel> getUserApi() async {
    var token =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjM2MDgsImV4cCI6MTk2ODkwMTA3MH0.2ZAY9rbWkgPMVdqyZfJgkLSrJzj58M9Lixmca-2VGxg';
    var uri = 'https://api.holedo.com/rest/users/me';

    try {
      final response = await http.get(Uri.parse(uri), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'AuthApi': 'Bearer ${token}'
      });
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return HoledoModel.fromJson(data);
      } else {
        return Future.error('Server Error !');
      }
    } catch (SocketException) {
      return Future.error('Error Fetching Data !');
    }
  }

  /// update data
  Future<HoledoModel> updateUserProfileSummary(
      Map<String, dynamic> data) async {
    var token =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjM2MDgsImV4cCI6MTk2ODkwMTA3MH0.2ZAY9rbWkgPMVdqyZfJgkLSrJzj58M9Lixmca-2VGxg';
    try {
      final response = await http.post(
        Uri.parse('https://${AuthData.apiHost}/rest/users/update'),

        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'apikey': AuthData.apiKey,
          'Accept': 'application/json',
          // 'AuthApi': 'Bearer ${token}'
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        final model = Get.put(AuthController()).restoreModel();
        model.setData = HoledoModel.fromJson(jsonDecode(response.body));
        Get.find<AuthController>().authModel(model);
        return model.data;

      } else {
        throw Exception('Failed to update album.');
      }
    } catch (SocketException) {
      return Future.error('Error Fetching Data !');
    }
  }

}
