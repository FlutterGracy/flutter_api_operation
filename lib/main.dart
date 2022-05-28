import 'package:fetchdata/controller/auth_controller.dart';
import 'package:fetchdata/screen/holedo_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.put(AuthController()).initStorage();

  runApp( MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  HoledoHome();
  }
}
