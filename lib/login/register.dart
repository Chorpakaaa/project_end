import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:inventoryapp/db/logindb.dart';
import 'package:inventoryapp/db/my_project.dart';
import 'package:inventoryapp/db/store.dart';
import 'package:inventoryapp/login/login.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var uuid = Uuid();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final db = FirebaseFirestore.instance;
  _generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  _register(String email, String password) async {
    final queryCheckUser = await db
          .collection('users')
          .where('email', isEqualTo: _emailController.text)
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
      }
    final store = <String, dynamic>{
      "store_name": email,
      "store_code": _generateRandomString(8)
    };
    db.collection("stores").add(store).then((value) {
      final user = <String, dynamic>{
        "name": "เจ้าของร้าน",
        "email": email,
        "password": password,
        "role": "เจ้าของร้าน",
        "store_id": value.id,
      };
      _createTransactions(value.id);
      db.collection("users").add(user).then((DocumentReference doc) {
        print('DocumentSnapshot added with ID: ${doc.id}');
      });
    });
  }

  _createTransactions(String storeId) async {
    String formattedDate = DateFormat('dd/MM/yy').format(DateTime.now());
    await db.collection('transactions').add({
      'date': formattedDate,
      'other_expenses': 0,
      'profit': 0,
      'sale': 0,
      'store_id': storeId
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('สมัครสมาชิก'),
      ),
      body: Padding(
        padding: EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.deepOrange),
                ),
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
                labelText: 'อีเมล',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: true,
              controller: _passwordController,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.deepOrange),
                ),
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
                labelText: 'รหัสผ่าน',
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton(
                      onPressed: () async => {
                            await _register(_emailController.text.trim(),
                                _passwordController.text.trim()),
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginSreen()),
                            )
                          },
                      child: const Text('สมัครสมาชิก')),
                )),
          ],
        ),
      ),
    );
  }
}
