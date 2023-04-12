import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventoryapp/account/auditday.dart';
import 'package:inventoryapp/provider/provider.dart';
import 'package:provider/provider.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  String formattedDate = DateFormat('dd/MM/yy').format(DateTime.now());
  final db = FirebaseFirestore.instance;
  final _expenses = TextEditingController();

  _updateExpansesSate() async {
  final user = context.read<UserProvider>().user;
    await db.collection('transactions').doc(user!.transacId).update({"other_expenses" : _expenses.text});
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ค่าใช้จ่ายอื่นๆ"),
        actions: [
          TextButton(
            onPressed: () async {
              if(await _updateExpansesSate()){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Auditday()),
              );
              }
            },
            child: const Text("บันทึก"),
            style: TextButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 20,
              ),
              primary: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(width: 0.5, color: Colors.grey))),
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "วันที่ทำรายการ",
                      style: TextStyle(color: Colors.black),
                    ),
                    Expanded(
                      child: Text(
                        formattedDate, //ทำเป็นวันที่จริงๆ
                        style: const TextStyle(color: Colors.black),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              // Container(
              //   decoration: const BoxDecoration(
              //       border: Border(
              //           bottom: BorderSide(width: 0.5, color: Colors.grey))),
              //   child: const TextField(
              //     decoration: InputDecoration(
              //       border: InputBorder.none,
              //       icon: Icon(Icons.article_outlined),
              //       hintText: 'ระบุค่าใช้จ่ายเพิ่มเติม',
              //       hintStyle: TextStyle(color: Colors.black),
              //       fillColor: Colors.white,
              //       filled: true,
              //     ),
              //     style: TextStyle(color: Colors.black),
              //   ),
              // ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 0.5, color: Colors.grey))),
                child:  TextField(
                  controller: _expenses,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.money),
                    hintText: 'ราคา',
                    hintStyle: TextStyle(color: Colors.black),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  style: TextStyle(color: Colors.black),
                ),
              ),
              // Container(
              //   decoration: const BoxDecoration(
              //       border: Border(
              //           bottom: BorderSide(width: 0.5, color: Colors.grey))),
              //   child: const TextField(
              //     decoration: InputDecoration(
              //       icon: Icon(Icons.comment),
              //       border: InputBorder.none,
              //       hintText: 'รายละเอียดอื่นๆ',
              //       hintStyle: TextStyle(color: Colors.black),
              //       fillColor: Colors.white,
              //       filled: true,
              //     ),
              //     style: TextStyle(color: Colors.black),
              //   ),
              // ),
            ],
          )
        ]),
      ),
    );
  }
}
