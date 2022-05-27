import 'dart:convert';

import 'package:fetchdata/model/holedo_model.dart';

import 'package:http/http.dart' as http;

class HoledoService {
  Future<HoledoModel> getUserApi() async {
    var token =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjM4MjksImV4cCI6MTk2NzcyMjMyNX0.Nx62HzFr5GGZ-QbDYstApelOdKzOn5nWxuBS3K653Yc';
    var uri = 'https://api.holedo.com/rest/users/me';

    final response = await http.get(Uri.parse(uri), headers: <String,String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'AuthApi': 'Bearer ${token}'
    });
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      return HoledoModel.fromJson(data);
    } else {
      return HoledoModel.fromJson(data);
    }
  }

  Future<HoledoModel> updateUserProfileSummary(
      dynamic id, String fullName) async {
    var token =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjM4MjksImV4cCI6MTk2NzcyMjMyNX0.Nx62HzFr5GGZ-QbDYstApelOdKzOn5nWxuBS3K653Yc';

    var response = await http.put(
      Uri.parse('https://api.holedo.com/rest/users/update'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'AuthApi': 'Bearer ${token}'
      },
      body: jsonEncode(<String, dynamic>{
        "id": id,
        "full_name": fullName.toString(),
      }),
    );

    if (response.statusCode == 200) {
      return HoledoModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update album.');
    }
  }

  Future<HoledoModel?> postUserApi(String firstName) async {
    var token =
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjM4MjksImV4cCI6MTk2NzcyMjMyNX0.Nx62HzFr5GGZ-QbDYstApelOdKzOn5nWxuBS3K653Yc';
    var uri = 'https://api.holedo.com/rest/users/update';

    final response = await http.post(
      Uri.parse(uri),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'AuthApi': 'Bearer ${token}'
      },
      body: jsonEncode(<String, String>{
        'first_Name': firstName,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return HoledoModel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
}
