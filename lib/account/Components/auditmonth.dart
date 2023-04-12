import 'package:flutter/material.dart';
import 'package:inventoryapp/account/Components/saleproduct.dart';

class Auditmonth extends StatefulWidget {
  const Auditmonth({super.key});

  @override
  State<Auditmonth> createState() => _AuditmonthState();
}

class _AuditmonthState extends State<Auditmonth> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                        'วันที่ 1-31 มีนาคม 2023'), //ทำเป็นวันที่จริงๆ
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(15, 12),
                        textStyle: const TextStyle(fontSize: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(45))),
                  ),
                ],
              ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            children: [
                              const SizedBox(height: 30),
                              TextButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.all(5),
                                  textStyle: const TextStyle(fontSize: 15),
                                  primary: Colors.black,
                                  side: const BorderSide(
                                      width: 1, color: Colors.black),
                                ),
                                onPressed: () {},
                                child: const Text('Export PDF',//ไฟล์ pdf
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: const <Widget>[
                                    Text('ยอดขายรวม',
                                        style: TextStyle(fontSize: 17)),
                                    Spacer(),
                                    Text('1,220.00',
                                        style: TextStyle(fontSize: 17)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: const <Widget>[
                                  Text('รายการจ่ายแล้ว',
                                      style: TextStyle(fontSize: 14)),
                                  Spacer(),
                                  Text('1,220.00',
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: const <Widget>[
                                  Text('รายการค้างจ่าย',
                                      style: TextStyle(fontSize: 14)),
                                  Spacer(),
                                  Text('00.00', style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: const <Widget>[
                                    Text('ยอดซื้อรวม',
                                        style: TextStyle(fontSize: 17)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: const <Widget>[
                                  Text('รายการจ่ายแล้ว',
                                      style: TextStyle(fontSize: 14)),
                                  Spacer(),
                                  Text('1,220.00',
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: const <Widget>[
                                  Text('รายการค้างจ่าย',
                                      style: TextStyle(fontSize: 14)),
                                  Spacer(),
                                  Text('00.00', style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: const <Widget>[
                                    Text('ค่าใช้จ่ายอื่นๆ',
                                        style: TextStyle(fontSize: 17)),
                                    Spacer(),
                                    Text('1,990.00',
                                        style: TextStyle(fontSize: 17)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const <Widget>[
                                  Text('รายรับ',
                                      style: TextStyle(fontSize: 17)),
                                  Text('รายจ่าย',
                                      style: TextStyle(fontSize: 17)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const <Widget>[
                                  Text('22,000.00',
                                      style: TextStyle(fontSize: 17)),
                                  Text('2,000.00',
                                      style: TextStyle(fontSize: 17)),
                                ],
                              ),
                            ],
                          ),
                        ),
                         const SizedBox(height: 15,),

                        Container(
                 margin: const EdgeInsets.only( left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                    ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: const <Widget>[
                          Text('กำไรสุทธิ', style: TextStyle(fontSize: 16)),
                          Spacer(),
                          Text('1,900.00',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
               const SizedBox(height: 15,),
               
                        
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 5, right: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            children: [
                              const SizedBox(height: 30),
                              TextButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.all(5),
                                  textStyle: const TextStyle(fontSize: 15),
                                  primary: Colors.black,
                                  side: const BorderSide(
                                      width: 1, color: Colors.black),
                                ),
                                onPressed: () {},
                                child: const Text('Export PDF',//ไฟล์ pdf
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: const <Widget>[
                                    Text('ยอดขายรวม',
                                        style: TextStyle(fontSize: 17)),
                                    Spacer(),
                                    Text('00.00',
                                        style: TextStyle(fontSize: 17)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: const <Widget>[
                                  Text('รายการจ่ายแล้ว',
                                      style: TextStyle(fontSize: 14)),
                                  Spacer(),
                                  Text('00.00',
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: const <Widget>[
                                  Text('รายการค้างจ่าย',
                                      style: TextStyle(fontSize: 14)),
                                  Spacer(),
                                  Text('00.00', style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: const <Widget>[
                                    Text('ยอดซื้อรวม',
                                        style: TextStyle(fontSize: 17)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: const <Widget>[
                                  Text('รายการจ่ายแล้ว',
                                      style: TextStyle(fontSize: 14)),
                                  Spacer(),
                                  Text('00.00',
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: const <Widget>[
                                  Text('รายการค้างจ่าย',
                                      style: TextStyle(fontSize: 14)),
                                  Spacer(),
                                  Text('00.00', style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  children: const <Widget>[
                                    Text('ค่าใช้จ่ายอื่นๆ',
                                        style: TextStyle(fontSize: 17)),
                                    Spacer(),
                                    Text('00.00',
                                        style: TextStyle(fontSize: 17)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const <Widget>[
                                  Text('รายรับ',
                                      style: TextStyle(fontSize: 17)),
                                  Text('รายจ่าย',
                                      style: TextStyle(fontSize: 17)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const <Widget>[
                                  Text('00.00',
                                      style: TextStyle(fontSize: 17)),
                                  Text('00.00',
                                      style: TextStyle(fontSize: 17)),
                                ],
                              ),
                            ],
                          ),
                        ),
                         const SizedBox(height: 15,),

                        Container(
                 margin: const EdgeInsets.only( left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                    ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: const <Widget>[
                          Text('กำไรสุทธิ', style: TextStyle(fontSize: 16)),
                          Spacer(),
                          Text('00.00',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
               const SizedBox(height: 15,),     
                      ],
                    ),
                  ),
                  
                ],
              ),
            ],
          ),
        );
  }
}
