import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventoryapp/account/Components/orderdetail.dart';
import 'package:inventoryapp/account/Components/saleproductmonth.dart';
import 'package:inventoryapp/account/Components/saleproductyear.dart';
import 'package:inventoryapp/account/auditday.dart';
import 'package:inventoryapp/provider/provider.dart';
import 'package:inventoryapp/widget/nevbar.dart';
import 'package:provider/provider.dart';

class saleproduct extends StatefulWidget {
  const saleproduct({super.key});

  @override
  State<saleproduct> createState() => _saleproductState();
}

class _saleproductState extends State<saleproduct> {
  int change_page = 1;
  final db = FirebaseFirestore.instance;
  List listData = [];
  double totalSale = 0;
  @override
  void initState() {
    super.initState();
    _queryOrder();
  }

  _queryOrder() async {
    List listOrder = [];

    final user = context.read<UserProvider>().user;
    await db
        .collection('transactions')
        .where('store_id', isEqualTo: user!.storeId)
        .get()
        .then((value) async {
      for (final data in value.docs) {
        List sumSale = [];
        await db
            .collection('orders')
            .where('transac_id', isEqualTo: data.id)
            .where('status', isEqualTo: 'ขาย')
            .get()
            .then((order) {
          for (final subData in order.docs) {
            final addData = <String, dynamic>{
              "date_time": subData['date_time'],
              "order_number": subData['order_number'],
              "role": subData['role'],
              "status": subData['status'],
              "total": subData['total'],
              "total_quantity": subData['total_quantity'],
              "order_id": subData.id
            };
            setState(() {
              listOrder.add(addData);
              sumSale.add(addData['total']);
            });
          }
        });
        totalSale = sumSale.length > 0
            ? sumSale.reduce((value, element) => value + element)
            : 0;
        final setData = <String, dynamic>{
          "date": data['date'],
          "profit": totalSale,
          "order": [...listOrder]
        };
        setState(() {
          listData.add(setData);
          listData.sort((a, b) => b['date'].compareTo(a['date']));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
        final user = context.read<UserProvider>().user;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('ยอดขาย'),
            // bottom: const TabBar(
            //   isScrollable: true,
            //   tabs: <Widget>[
            //     Tab(
            //       icon:
            //           Icon(Icons.bar_chart_sharp), //ใส่ลิงค์หน้าไป saleproduct
            //       text: "รายรับ/จ่าย-วัน",
            //     ),
            //     Tab(
            //       icon: Icon(
            //           Icons.bar_chart_sharp), //ใส่ลิงค์ไปหน้า productdetails
            //       text: "รายรับ/จ่าย-เดือน",
            //     ),
            //     Tab(
            //       icon: Icon(
            //           Icons.bar_chart_sharp), //ใส่ลิงค์ไปหน้า productdetails
            //       text: "รายรับ/จ่าย-ปี",
            //     ),
            //   ],
            // ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Column(
                      children: listData
                          .map<Widget>(
                            (i) => Container(
                              margin: const EdgeInsets.only(
                                  top: 20, left: 5, right: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.grey)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      children: <Widget>[
                                        Text(i['date'],
                                            style: TextStyle(fontSize: 16)),
                                        Spacer(),
                                        Text(i['profit'].toString(),
                                            style: TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 1,
                                    color: Colors.grey,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          children: [
                                            const SizedBox(height: 30),
                                            TextButton(
                                              style: OutlinedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                textStyle: const TextStyle(
                                                    fontSize: 15),
                                                primary: Colors.black,
                                                side: const BorderSide(
                                                    width: 1,
                                                    color: Colors.black),
                                              ),
                                              onPressed: () {},
                                              child: const Text(
                                                  'Export PDF', //ไฟล์ pdf
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const Divider(
                                    thickness: 1,
                                    color: Colors.grey,
                                  ),
                                  Column(
                                    children: i['order'].length > 0
                                        ? i['order']
                                            .map<Widget>((iSub) => Center(
                                                    child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Orderdetail(
                                                                  orderId: iSub[
                                                                      'order_id'])),
                                                    );
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            alignment: Alignment
                                                                .topLeft,
                                                            height: 35,
                                                            width: 60,
                                                            margin:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            color: Colors
                                                                .green[300],
                                                            child: Text(
                                                                iSub['status'],
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            12),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                    'เลขที่ ' +
                                                                        iSub['order_number']
                                                                            .toString(),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            15)),
                                                                const Spacer(),
                                                                const Text(
                                                                    'จ่ายแล้ว',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15)),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                20, 0, 0, 0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  const Text(
                                                                      'จำนวน',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15)),
                                                                  Spacer(),
                                                                  Text(
                                                                      iSub['total_quantity']
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              15)),
                                                                  const SizedBox(
                                                                    width: 40,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                20, 0, 0, 0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                      'เวลาทำรายการ ' +
                                                                          iSub[
                                                                              'date_time'],
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              15)),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                20, 0, 0, 0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                      'สร้างโดย : ' +
                                                                          iSub[
                                                                              'role'],
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              15)),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )))
                                            .toList()
                                        : [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      110, 0, 0, 0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            30),
                                                    child: Row(
                                                      children: const <Widget>[
                                                        Text('ไม่มีข้อมูล',
                                                            style: TextStyle(
                                                                fontSize: 17)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
              Saleproductmonth(),
              Saleproductyear()
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Auditday()),
              ),
            },
            child: const Icon(Icons.monetization_on_rounded),
            backgroundColor: Colors.deepOrange,
          ),
          bottomNavigationBar: BottomNavbar(
            number: 2,
            role: user!.role,
          )
          ),
    );
  }
}
