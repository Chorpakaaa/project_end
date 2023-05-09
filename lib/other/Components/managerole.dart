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

  _dialogDelete(String idUser, String name) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('คุณแน่ใจหรือไม่ ต้องจะการจะลบชื่อผู้ใช้  ' + name + ''),
          content: const Text('คลิกตกลงเพื่อลบผู้ใช้งาน'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('ตกลง'),
              onPressed: () async {
                await db.collection('users').doc(idUser).delete();
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => super.widget));
              },
            ),
          ],
        );
      },
    );
  }

  _fecthUser() async {
    final user = context.read<UserProvider>().user;
    await db
        .collection('users')
        .where('store_id', isEqualTo: user!.storeId)
        .get()
        .then((value) {
      for (final data in value.docs) {
        final dataUser = <String, dynamic>{
          "name": data['name'],
          "email": data["email"],
          "role": data["role"],
          "user_id": data.id
        };
        setState(() {
          listUser.add(dataUser);
          listUser = listUser
              .where((element) => element['role'] != "เจ้าของร้าน")
              .toList();
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
            'จัดการผู้ช่วยใช้/ผู้ใช้อื่น',
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
                Column(
                    children: listUser
                        .map((i) => InkWell(
                            onLongPress: () {
                              _dialogDelete(i['user_id'], i['name']);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                      color: Colors.deepOrange,
                                      width: 1.0,
                                    ),
                                    top: BorderSide(
                                        color: Colors.deepOrange, width: 0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.person_add_alt_rounded,color: Colors.deepOrange),
                                    const SizedBox(
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
                            )))
                        .toList())
              ],
            ),
          ),
        ));
  }
}
