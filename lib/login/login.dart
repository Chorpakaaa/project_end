import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventoryapp/account/auditday.dart';
import 'package:inventoryapp/db/my_project.dart';
import 'package:inventoryapp/imported/imported.dart';
import 'package:inventoryapp/login/register.dart';
import 'package:inventoryapp/provider/provider.dart';
import 'package:inventoryapp/sell/sell.dart';
import 'package:provider/provider.dart';

class LoginSreen extends StatefulWidget {
  LoginSreen({super.key});

  @override
  State<LoginSreen> createState() => _LoginSreenState();
}

class _LoginSreenState extends State<LoginSreen> {
  int change_page = 1;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = '';
  final db = FirebaseFirestore.instance;
  String role = '';
  _login(String email, String password) async {
    final querydb = await db.collection("users").get();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final setIndex = Provider.of<IndexNavbar>(context, listen: false);
    List userLogin = [];
    querydb.docs.forEach((doc) {
      if (doc['email'] == email) {
        userLogin.add(doc.data());
      }
    });
    String setTransacId =
        await _createTableTransactions(userLogin[0]['store_id']);
    final modelUser = UserModel(
        email: userLogin[0]['email'],
        storeId: userLogin[0]['store_id'],
        transacId: setTransacId,
        role: userLogin[0]['role'],
        name:userLogin[0]['name']);
    userProvider.setUser(modelUser);
    setState(() {
      role = userLogin[0]['role'];
    });
    return userLogin
            .where((element) => element['password'] == password)
            .isNotEmpty
        ? true
        : false;
  }

  void getRoleIndex(String role) {
    if (role == "สินค้าเข้า") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Imported()),
          (route) => false);
    } else if (role == "ขายสินค้าออก") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Sell()),
          (route) => false);
    } else if (role == "บัญชี") {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Auditday()),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Imported()),
          (route) => false);
    }
  }

  Future<String> _createTableTransactions(String storeId) async {
    String transacId = '';
    String formattedDate = DateFormat('dd/MM/yy').format(DateTime.now());
    final checkQuery = await db
        .collection('transactions')
        .where('date', isEqualTo: formattedDate)
        .where('store_id', isEqualTo: storeId)
        .get();
    for (final data in checkQuery.docs) {
      setState(() {
        transacId = data.id;
      });
    }
    if (checkQuery.docs.isEmpty) {
      await db.collection('transactions').add({
        'date': formattedDate,
        'other_expenses': 0,
        'profit': 0,
        'sale': 0,
        'store_id': storeId
      }).then((value) {
        setState(() {
          transacId = value.id;
        });
      });
    }
    return transacId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0, bottom: 10.0),
                child: const Image(
                  image: AssetImage('assets/images/wh2.jpg'),
                  height: 150,
                  width: 200,
                ),
              ),
              change_page == 2
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      margin: EdgeInsets.only(top: 20.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(color: Colors.deepOrange),
                          ),
                          prefixIcon: Icon(Icons.supervisor_account),
                          hintText: 'รหัสร้านค้า',
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              const SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                margin: change_page == 2
                    ? EdgeInsets.only(top: 0.0)
                    : EdgeInsets.only(top: 20.0),
                child: TextFormField(
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
                    hintText: 'อีเมล',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
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
                    hintText: 'รหัสผ่าน',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: EdgeInsets.all(30.0),
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                    ),
                    child: Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      // if (user.length == 1) {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const Imported()),
                      //   );
                      // } else {
                      //   setState(() {
                      //     _errorMessage = 'อีเมล หรือ รหัส ผิด';
                      //   });
                      // }
                      if (await _login(
                          _emailController.text, _passwordController.text)) {
                        getRoleIndex(role);
                        // Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const Sell()),
                        //     (route) => false);
                      } else {
                        setState(() {
                          _errorMessage = 'อีเมล หรือ รหัส ผิด';
                        });
                      }
                    }),
              ),
              SizedBox(height: 8),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
              change_page == 1
                  ? TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()),
                        );
                      },
                      child: const Text(
                        'สมัครสมาชิก',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
