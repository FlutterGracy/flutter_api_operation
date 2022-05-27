import 'dart:convert';

import 'package:fetchdata/model/holedo_model.dart';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../service/holedo_service.dart';

class HoledoHome extends StatefulWidget {
  const HoledoHome({Key? key}) : super(key: key);

  @override
  State<HoledoHome> createState() => _HoledoHomeState();
}

class _HoledoHomeState extends State<HoledoHome> {
  late Future<HoledoModel?> _holdedo;

  final HoledoService _holedoService = HoledoService();
  User? user;
  late TextEditingController fullNameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _holedoService;
    _holdedo = _holedoService.getUserApi();
    fullNameController =
        TextEditingController(text: userStoreData.read('full_name'));
  }

  GetStorage userStoreData = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holedo Home'),
      ),
      body: FutureBuilder<HoledoModel?>(
          future: _holdedo,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              userStoreData.write(
                  'full_name', snapshot.data!.data!.user!.fullName.toString());

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.data!.data!.user!.fullName.toString()),
                    TextField(
                      controller: fullNameController,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _holdedo = _holedoService.updateUserProfileSummary(
                                user!.id, fullNameController.text);
                            print(snapshot.data!.data!.user!.fullName.toString());
                          });
                        },
                        child: const Text('Submit Data'),
                      ),
                    )
                  ],
                ),
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
