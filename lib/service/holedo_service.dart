import 'dart:convert';

import 'package:fetchdata/model/holedo_model.dart';

import 'package:http/http.dart' as http;

class HoledoService {



/// fetch data
  Future<HoledoModel> getUserApi() async {
    var token =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjM2MDgsImV4cCI6MTk2ODkwMTA3MH0.2ZAY9rbWkgPMVdqyZfJgkLSrJzj58M9Lixmca-2VGxg';
    // 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjM4MjksImV4cCI6MTk2NzcyMjMyNX0.Nx62HzFr5GGZ-QbDYstApelOdKzOn5nWxuBS3K653Yc';
    var uri = 'https://api.holedo.com/rest/users/me';

    try {
      final response = await http.get(Uri.parse(uri), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'AuthApi': 'Bearer ${token}'
      });
      var data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print(response.body);
        return HoledoModel.fromJson(data);
      } else {
        return Future.error('Server Error !');
      }
    } catch (SocketException) {
      return Future.error('Error Fetching Data !');
    }
  }
/// update data
  Future<HoledoModel?> updateUserProfileSummary(
      Map<String, dynamic> data) async {
    var token =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjM2MDgsImV4cCI6MTk2ODkwMTA3MH0.2ZAY9rbWkgPMVdqyZfJgkLSrJzj58M9Lixmca-2VGxg';
    // 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjM4MjksImV4cCI6MTk2NzcyMjMyNX0.Nx62HzFr5GGZ-QbDYstApelOdKzOn5nWxuBS3K653Yc';
    try {
      var response = await http.post(
        Uri.parse('https://api.holedo.com/rest/users/me'),
        body: jsonEncode(data),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'AuthApi': 'Bearer ${token}'
        },
      );
      if (response.statusCode == 200) {
        print(response.body);
        return HoledoModel.fromJson(response.body);
        // return "success";
      } else {
        return Future.error('Server Error !');
      }
    } catch (SocketException) {
      return Future.error('Error Fetching Data !');
    }
  }


















// Future<HoledoModel?> postUserApi(String firstName) async {
//   var token =
//       'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjM4MjksImV4cCI6MTk2NzcyMjMyNX0.Nx62HzFr5GGZ-QbDYstApelOdKzOn5nWxuBS3K653Yc';
//   var uri = 'https://api.holedo.com/rest/users/update';
//
//   final response = await http.post(
//     Uri.parse(uri),
//     headers: <String, String>{
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//       'AuthApi': 'Bearer ${token}'
//     },
//     body: jsonEncode(<String, String>{
//       'first_Name': firstName,
//     }),
//   );

//   if (response.statusCode == 200) {
//     // If the server did return a 201 CREATED response,
//     // then parse the JSON.
//     return HoledoModel.fromJson(jsonDecode(response.body));
//   } else {
//     // If the server did not return a 201 CREATED response,
//     // then throw an exception.
//     throw Exception('Failed to create album.');
//   }
// }
}
