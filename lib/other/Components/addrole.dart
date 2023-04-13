import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventoryapp/other/Components/managerole.dart';
import 'package:inventoryapp/provider/provider.dart';
import 'package:provider/provider.dart';
import '../../widget/my_textfield.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AddRole extends StatefulWidget {
  const AddRole({super.key});

  @override
  State<AddRole> createState() => _AddRole();
}

class _AddRole extends State<AddRole> {
  final formKey = GlobalKey<FormState>();
  String name = "";
  String? selectedValue;
  String codeStore = "";
  final db = FirebaseFirestore.instance;
  final _textEmail = TextEditingController();
  final _textName = TextEditingController();
  final _password = TextEditingController();
  final List<String> items = [
    'ซื้อสินค้าเข้า',
    'ขายสินค้าออก',
    'บัญชี',
  ];

  @override
  void initState() {
    super.initState();
    _fecthShop();
  }

  _fecthShop() async {
    final user = context.read<UserProvider>().user;
    await db.collection('stores').doc(user!.storeId).get().then((value) {
      setState(() {
        codeStore = value['store_code'];
      });
    });
  }

  _addNewUser() async {
    final user = context.read<UserProvider>().user;
    try {
      final queryCheckUser = await db
          .collection('users')
          .where('email', isEqualTo: _textEmail.text)
          .get();
      if (queryCheckUser.docs.length > 0) {
        return  showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('มีชื่อผู้ใช้นี้แล้ว'),
            content: const Text('กรุณาเลือกผู้ใช้ใหม่'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('ตกลง'),
              ),
            ],
          ),
        );
      } else {
        await db.collection('users').add({
          "email": _textEmail.text,
          "name": _textName.text,
          "role": selectedValue ?? "ซื้อสินค้าเข้า",
          "password": _password.text,
          "store_id": user!.storeId
        });
      }
      return true;
    } catch (e) {
      print('err $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'รายละเอียดผู้ช่วย/ผู้ใช้อื่น',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save_alt),
              onPressed: () async {
                if (_password.text.isNotEmpty &&
                    _textEmail.text.isNotEmpty &&
                    _textName.text.isNotEmpty) {
                  if (await _addNewUser()) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ManageRole()));
                  }
                } else {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('เกิดข้อผิดพลาด'),
                        content: const Text('กรุณากรอกให้ครบถ้วน'),
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: const Text('ตกลง'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            )
          ],
          backgroundColor: Colors.deepOrange,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.02),
                  const Text(
                    "here ",
                    style: TextStyle(fontSize: 20, color: Color(000033)),
                  ),
                  SizedBox(height: height * 0.02),
                  TextFormField(
                    controller: _textName,
                    decoration: InputDecoration(
                      labelText: "ชื่อที่แสดง",
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  TextFormField(
                    controller: _textEmail,
                    decoration:
                        const InputDecoration(labelText: "ชื่อที่ใช้ล็อกอิน"),
                  ),
                  SizedBox(height: height * 0.02),
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "รหัสผ่าน"),
                  ),
                  SizedBox(height: height * 0.02),
                  TextFormField(
                    enabled: false,
                    controller: TextEditingController(text: codeStore),
                    decoration: InputDecoration(labelText: "รหัสร้านค้า"),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('กำหนดสิทธิ์การใช้งาน'),
                      SizedBox(
                        width: 10,
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          hint: Text(
                            items[0],
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: items
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as String;
                            });
                          },
                          buttonHeight: 40,
                          buttonWidth: 140,
                          itemHeight: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
