import 'package:fetchdata/model/holedo_model.dart';
import 'package:flutter/material.dart';
import '../service/holedo_service.dart';
import 'done.dart';

class HoledoHome extends StatefulWidget {
  const HoledoHome({Key? key}) : super(key: key);

  @override
  State<HoledoHome> createState() => _HoledoHomeState();
}

class _HoledoHomeState extends State<HoledoHome> {

  final HoledoService _holedoService = HoledoService();
  TextEditingController? fNameController;

  TextEditingController? lNameController;

  User? user;
  bool isUpdating = false;

  Future<void> updateData(dynamic id, String fname, String lname) async {
    setState(() {
      isUpdating = true;
    });
    if (fname.toString() != '' && lname.toString() != '') {
      Map<String, dynamic> data = {
        "id": id,
        "first_name": fname,
        "last_name": lname,
      };
      dynamic res = await _holedoService.updateUserProfileSummary(data);

      if (res?.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('success: ${res?.success}'),
            backgroundColor: Colors.green.shade300,
          ),
        );
        print(res.data.user.firstName.toString());

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Done(res: res.data)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${res?.messages}'),
            backgroundColor: Colors.red.shade300,
          ),
        );
      }
    }
    setState(() {
      isUpdating = false;
    });
  }

  Future alertDialog(
      {required dynamic id, required String fname, required String lname}) {
    TextEditingController _fnm=TextEditingController(text: fname);
    TextEditingController _lnm=TextEditingController(text: lname);


    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            TextField(
              controller: _fnm,
              onChanged: (value) {
                setState(() {
                  fname = value;
                });
              },
            ),
            TextField(
              controller: _lnm,
              onChanged: (value) {
                setState(() {
                  lname = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                updateData(id, _fnm.text, _lnm.text);
              },
              child: Text('submitted'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holedo Home'),
      ),
      body: Column(
        children: [

          FutureBuilder<HoledoModel>(
              future: _holedoService.getUserApi(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(snapshot.data!.data!.user!.id.toString()),
                        Text(snapshot.data!.data!.user!.fullName.toString()),
                        Text(snapshot.data!.data!.user!.firstName.toString()),
                        Text(snapshot.data!.data!.user!.lastName.toString()),

                        // Padding(
                        //   padding: EdgeInsets.all(8.0),
                        //   child: TextField(
                        //     controller: fNameController,
                        //     decoration:
                        //     InputDecoration(border: OutlineInputBorder()),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: TextField(
                        //     controller: lNameController,
                        //     decoration:
                        //     const InputDecoration(border: OutlineInputBorder()),
                        //   ),
                        // ),

                        OutlinedButton(
                          onPressed: () {
                            alertDialog(
                                id: snapshot.data!.data!.user!.id.toString(),
                                fname:
                                    snapshot.data!.data!.user!.firstName.toString(),
                                lname:
                                    snapshot.data!.data!.user!.lastName.toString());
                          },
                          child: Text('popUp'),
                        ),

                        // isUpdating
                        //     ? const CircularProgressIndicator()
                        //     : ElevatedButton(
                        //         onPressed: updateData,
                        //         child: const Text('submit Data'),
                        //       )
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
        ],
      ),
    );
  }
}
