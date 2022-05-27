import 'dart:convert';

import 'package:fetchdata/model/holedo_model.dart';
import 'package:flutter/material.dart';
import '../service/holedo_service.dart';

class HoledoHome extends StatefulWidget {
  const HoledoHome({Key? key}) : super(key: key);

  @override
  State<HoledoHome> createState() => _HoledoHomeState();
}

class _HoledoHomeState extends State<HoledoHome> {
  late Future<HoledoModel?> _holdedo;

  final HoledoService _holedoService = HoledoService();

  // User? user;
  TextEditingController? fNameController;
  TextEditingController? lNameController;

  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user;
  fNameController=TextEditingController();
  lNameController=TextEditingController();
  }

  String? lname;
  String? fname;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holedo Home'),
      ),
      body: FutureBuilder<HoledoModel>(
          future: _holedoService.getUserApi(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              // if (snapshot.data!.data!.user==null) {
              //   return const Center(
              //     child: Text('No Data available'),
              //   );
              // }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.data!.data!.user!.id.toString()),
                    Text(snapshot.data!.data!.user!.fullName.toString()),
                    Text(snapshot.data!.data!.user!.firstName.toString()),
                    Text(snapshot.data!.data!.user!.lastName.toString()),

                    // Text(snapshot.data!.data!.user!.lastName.toString()),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: fNameController,
                        onChanged: (value) {
                          fname = value;
                        },
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: lNameController,
                        onChanged: (value) {
                          lname = value;
                        },
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () async {
                        // print(fname);
                        // print(lname);

                        Map<String, dynamic> data = {
                          "id": user?.id,
                          // "first_name": fNameController?.text,
                          // "last_name": lNameController?.text,
                          "first_name": fname,
                          "last_name": lname,
                        };
                        dynamic res = await _holedoService
                            .updateUserProfileSummary(data);
                        if (res?.errors == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Done: ${res?.messages}'),
                              backgroundColor: Colors.green.shade300,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: ${res?.messages}'),
                              backgroundColor: Colors.red.shade300,
                            ),
                          );
                        }

                        // print(lNameController.toString());
                      },
                      child: const Text('submit Data'),
                    )
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('error::- ${snapshot.hasError.toString()}'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
