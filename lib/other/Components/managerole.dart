import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventoryapp/other/Components/addrole.dart';
import 'package:inventoryapp/provider/provider.dart';
import 'package:provider/provider.dart';

class ManageRole extends StatefulWidget {
  const ManageRole({super.key});

  State<ManageRole> createState() => _ManageRole();
}

class _ManageRole extends State<ManageRole> {
  final db = FirebaseFirestore.instance;
  List listUser = [];

  @override
  void initState() {
    super.initState();
    _fecthUser();
  }

  _fecthUser() async {
    final user = context.read<UserProvider>().user;
    await db
        .collection('users')
        .where('store_id', isEqualTo: user!.storeId)
        .get()
        .then((value) {
      for (final data in value.docs) {
        final dataUser = <String , dynamic>{
          "name":data['name'],
          "email":data["email"],
          "role":data["role"]
        };
        setState(() {
          listUser.add(dataUser);
          listUser = listUser.where((element) => element['role'] != "เจ้าของร้าน").toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'บริหารจัดการผู้ช่วยใช้/ผู้ใช้อื่น',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddRole(),
                    ));
              },
            )
          ],
          backgroundColor: Colors.deepOrange,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                TextField(
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(333399),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: " ค้นหา ",
                      prefixIcon: Icon(Icons.search),
                      prefixIconColor: Colors.amberAccent),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Column(
                    children: listUser
                        .map((i) => Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.person),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Column(
                                      children: [
                                        Text(i['name']),
                                        Text(i['role'])
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ))
                        .toList())
              ],
            ),
          ),
        ));
  }
}
