import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventoryapp/account/Components/auditmonth.dart';
import 'package:inventoryapp/account/Components/expenses.dart';
import 'package:inventoryapp/account/Components/orderdetail.dart';
import 'package:inventoryapp/account/Components/productdetails.dart';
import 'package:inventoryapp/account/Components/saleproduct.dart';
import 'package:inventoryapp/provider/provider.dart';
import 'package:inventoryapp/widget/nevbar.dart';
import 'package:provider/provider.dart';

class Auditday extends StatefulWidget {
  const Auditday({super.key});

  @override
  State<Auditday> createState() => AuditdayState();
}

class AuditdayState extends State<Auditday> {
  int change_page = 1;
  final db = FirebaseFirestore.instance;
  DateTime _selectedDate = DateTime.now();
  String formattedDate = DateFormat('dd/MM/yy').format(DateTime.now());
  double totalSale = 0;
  double totalBuy = 0;
  double otherExpenses = 0;
  double totalProfit = 0;
  int lengthSale = 0;
  List arr = [];
  @override
  void initState() {
    super.initState();
    _queryTransactions(formattedDate);
  }

  _queryTransactions(String date) async {
    List listOrder = [];
     final user = context.read<UserProvider>().user;
    // String formattedDate = DateFormat('dd/MM/yy').format(DateTime.now());

    final fetchTransac = await db
        .collection('transactions')
        .where('date', isEqualTo: date)
        .get();
    for (final data in fetchTransac.docs) {
      await db
          .collection('orders')
          .where('transac_id', isEqualTo: data.id)
          .get()
          .then((value) {
        for (final orderData in value.docs) {
          final addData = <String, dynamic>{
            "date_time": orderData['date_time'],
            "order_number": orderData['order_number'],
            "role": orderData['role'],
            "status": orderData['status'],
            "total": orderData['total'],
            "total_quantity": orderData['total_quantity'],
            "order_id": orderData.id
          };
          setState(() {
            listOrder.add(addData);
          });
        }
      });
      final setData = <String, dynamic>{
        "date": data['date'],
        "profit": data['profit'],
        "sale": data['sale'],
        "other_expenses": data['other_expenses'],
        "order": [...listOrder]
      };
      setState(() {
        arr.add(setData);
      });
    }
    List sumSale = [];
    List sumProfit = [];
    lengthSale = 0;

    for (final data in arr) {
      for (final subData in data['order']) {
        if (subData['status'] == "ขาย") {
          sumSale.add(subData['total']);
        }
        if (subData['status'] == "ซื้อ") {
          sumProfit.add(subData['total']);
        }
        if (subData['status'] == "ขาย") {
          lengthSale += 1;
        }
      }
    }
    setState(() {
      totalBuy = sumProfit.length > 0
          ? sumProfit.reduce((value, element) => value + element)
          : 0;
      totalSale = sumSale.length > 0
          ? sumSale.reduce((value, element) => value + element)
          : 0;
      totalProfit = totalSale - totalBuy;
    });

    await db.collection('transactions').doc(user!.transacId).update({"profit" : totalProfit});

  }

  void _selectDate(BuildContext context) async {
    List listOrder = [];
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
    String formatted = DateFormat('dd/MM/yy').format(_selectedDate);
    final fetchTransac = await db
        .collection('transactions')
        .where('date', isEqualTo: formatted)
        .get();
    if (fetchTransac.docs.isNotEmpty) {
      for (final data in fetchTransac.docs) {
        await db
            .collection('orders')
            .where('transac_id', isEqualTo: data.id)
            .get()
            .then((value) {
          for (final orderData in value.docs) {
            final addData = <String, dynamic>{
              "date_time": orderData['date_time'],
              "order_number": orderData['order_number'],
              "role": orderData['role'],
              "status": orderData['status'],
              "total": orderData['total'],
              "total_quantity": orderData['total_quantity'],
              "order_id": orderData.id
            };
            setState(() {
              listOrder.add(addData);
            });
          }
        });
        final setData = <String, dynamic>{
          "date": data['date'],
          "profit": data['profit'],
          "sale": data['sale'],
          "other_expenses": data['other_expenses'],
          "order": [...listOrder]
        };
        setState(() {
          arr = [setData];
        });
      }
      List sumSale = [];
      List sumProfit = [];
      lengthSale = 0;
      for (final data in arr) {
        for (final subData in data['order']) {
          if (subData['status'] == "ขาย") {
            sumSale.add(subData['total']);
          }
          if (subData['status'] == "ซื้อ") {
            sumProfit.add(subData['total']);
          }
          if (subData['status'] == "ขาย") {
            lengthSale += 1;
          }
        }
      }
      setState(() {
        totalBuy = sumProfit.length > 0
            ? sumProfit.reduce((value, element) => value + element)
            : 0;
        totalSale = sumSale.length > 0
            ? sumSale.reduce((value, element) => value + element)
            : 0;
        totalProfit = totalSale - totalBuy;
      });
    } else {
      setState(() {
        arr = [];
        totalBuy = 0;
        totalProfit = 0;
        totalSale = 0;
        lengthSale = 0;
      });
    }
  }

  Widget build(BuildContext context) {
        final user = context.read<UserProvider>().user;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('รายการ/รับ-จ่าย'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.deepOrange,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Productdetails()),
                          );
                        },
                        child: Text('มูลค่าสินค้าคงคลัง'),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  change_page = 1;
                                });
                              },
                              child: const Text('รายรับ/จ่าย-วัน'),
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(150, 45),
                                  textStyle: const TextStyle(fontSize: 15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2)))),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const saleproduct()),
                                  );
                                });
                              },
                              child: const Text('ยอดขาย'),
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(150, 45),
                                  textStyle: const TextStyle(fontSize: 15),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2)))),
                        ],
                      ),
                    )
                  ],
                ),
                change_page == 1
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () => _selectDate(context),
                                child: const Text(
                                    'รายการย้อนหลังจากวันที่ : ปัจจุบัน'),
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(15, 12),
                                    textStyle: const TextStyle(fontSize: 15),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(45))),
                              ),
                            ],
                          ),
                          Column(
                              children: arr
                                  .map((i) => Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(i['date'],
                                                        style: const TextStyle(
                                                            fontSize: 14)),
                                                    Spacer(),
                                                    Text(
                                                        '(รายการขาย ' +
                                                            lengthSale
                                                                .toString() +
                                                            ' รายการ)',
                                                        style: TextStyle(
                                                            fontSize: 14)),
                                                  ],
                                                ),
                                              ),
                                              const Divider(
                                                thickness: 1,
                                                color: Colors.grey,
                                              ),
                                              Row(
                                                children: [
                                                  const SizedBox(height: 30),
                                                  OutlinedButton(
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      textStyle:
                                                          const TextStyle(
                                                              fontSize: 15),
                                                      primary: Colors.black,
                                                      side: const BorderSide(
                                                          width: 1,
                                                          color: Colors.black),
                                                      //backgroundColor: Colors.white,
                                                    ),
                                                    onPressed: () {},
                                                    child: const Text(
                                                        'Export PDF'), //ไฟล์ pdf
                                                  ),
                                                  const Spacer(),
                                                  const Text('รายรับ',
                                                      style: TextStyle(
                                                          fontSize: 14)),
                                                  const Spacer(),
                                                  const Text('รายจ่าย',
                                                      style: TextStyle(
                                                          fontSize: 14)),
                                                ],
                                              ),
                                              const Divider(
                                                thickness: 1,
                                                color: Colors.grey,
                                              ),
                                              Column(
                                                children: i['order']
                                                    .map<Widget>(
                                                        (iSub) =>
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          Orderdetail(
                                                                              orderId: iSub['order_id'])),
                                                                );
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            10),
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    height: 35,
                                                                    width: 60,
                                                                    margin:
                                                                        const EdgeInsets.all(
                                                                            10),
                                                                    color: iSub['status'] ==
                                                                            "ซื้อ"
                                                                        ? Colors.red[
                                                                            300]
                                                                        : Colors
                                                                            .green[300],
                                                                    child: Text(
                                                                        iSub[
                                                                            'status'],
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                12),
                                                                        textAlign:
                                                                            TextAlign.center),
                                                                  ),
                                                                  const Spacer(),
                                                                  Text(
                                                                      iSub['status'] ==
                                                                              "ขาย"
                                                                          ? (iSub['total'])
                                                                              .toString()
                                                                          : '',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              14)),
                                                                  const Spacer(),
                                                                  Text(
                                                                      iSub['status'] ==
                                                                              "ซื้อ"
                                                                          ? (iSub['total'])
                                                                              .toString()
                                                                          : '',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              14)),
                                                                ],
                                                              ),
                                                            ))
                                                    .toList(),
                                              ),
                                              Row(
                                                children: [
                                                  const Spacer(),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    alignment:
                                                        Alignment.topLeft,
                                                    height: 35,
                                                    width: 100,
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    color: Colors.green[300],
                                                    child: Text(
                                                        totalSale.toString() ==
                                                                "0"
                                                            ? "0"
                                                            : totalSale
                                                                .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  const Spacer(),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    alignment:
                                                        Alignment.topLeft,
                                                    height: 35,
                                                    width: 100,
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    color: Colors.red[300],
                                                    child: Text(
                                                        totalBuy.toString() ==
                                                                "0"
                                                            ? "0"
                                                            : totalBuy
                                                                .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  const Spacer()
                                                ],
                                              ),
                                              const Divider(
                                                thickness: 1,
                                                color: Colors.grey,
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Row(
                                                        children: <Widget>[
                                                          const Text('ยอดขาย',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14)),
                                                          const Spacer(),
                                                          Text(
                                                              totalSale
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          14)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Row(
                                                        children:  <
                                                            Widget>[
                                                         const Text(
                                                              'ค่าใช้จ่ายอื่นๆ',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14)),
                                                          Spacer(),
                                                          Text(i['other_expenses'].toString(),
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: Row(
                                                        children: <Widget>[
                                                          const Text(
                                                              'กำไรสุทธิ',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14)),
                                                          const Spacer(),
                                                          Text(
                                                              totalProfit
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          14)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ))
                                  .toList()),
                          const SizedBox(
                            height: 60,
                          ),
                          // Container(
                          //   margin: const EdgeInsets.only(
                          //       top: 20, left: 5, right: 5),
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(15),
                          //       border: Border.all(color: Colors.grey)),
                          //   child: Column(
                          //     mainAxisSize: MainAxisSize.min,
                          //     children: [
                          //       Padding(
                          //         padding: const EdgeInsets.all(5),
                          //         child: Row(
                          //           children: const <Widget>[
                          //             Text('31/03/2022',
                          //                 style: TextStyle(fontSize: 16)),
                          //             Spacer(),
                          //             Text('(รายการขาย 0 รายการ)',
                          //                 style: TextStyle(fontSize: 16)),
                          //           ],
                          //         ),
                          //       ),
                          //       const Divider(
                          //         thickness: 1,
                          //         color: Colors.grey,
                          //       ),
                          //       Padding(
                          //         padding:
                          //             const EdgeInsets.fromLTRB(110, 0, 0, 0),
                          //         child: Column(
                          //           mainAxisSize: MainAxisSize.min,
                          //           children: [
                          //             Padding(
                          //               padding: const EdgeInsets.all(30),
                          //               child: Row(
                          //                 children: const <Widget>[
                          //                   Text('ไม่มีข้อมูล',
                          //                       style: TextStyle(fontSize: 17)),
                          //                 ],
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // )
                        ],
                      )
                    : Auditmonth()
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.small(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Expenses()),
              )
            },
            heroTag: "monetization_on_rounded",
            child: const Icon(Icons.monetization_on_rounded),
          ),
          bottomNavigationBar: BottomNavbar(
            number: 2,
            role: user!.role,
          )
          ),
    );
  }
}
