
import 'package:flutter/material.dart';

class Done extends StatelessWidget {
  final res;
  const Done({Key? key,this.res}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:Center(child:Text(res.user.firstName.toString())));
  }
}
