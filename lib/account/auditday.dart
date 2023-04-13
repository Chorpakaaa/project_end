import 'dart:io';
import 'dart:typed_data';

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
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
  double totalProfit = 0;
  int otherExpenses = 0;
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

    final fetchTransac = await db
        .collection('transactions')
        .where('date', isEqualTo: date)
        .where('store_id', isEqualTo: user!.storeId)
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
            "name": orderData['name'],
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
        otherExpenses = data['other_expenses'];
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
      totalProfit -= otherExpenses;
    });

    await db
        .collection('transactions')
        .doc(user!.transacId)
        .update({"profit": totalProfit});
  }

  void _selectDate(BuildContext context) async {
    final user = context.read<UserProvider>().user;
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
        .where('store_id', isEqualTo: user!.storeId)
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
              "name": orderData['name'],
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
          otherExpenses = data['other_expenses'];
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
        totalProfit -= otherExpenses;
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
                                                    onPressed: () {
                                                      _generatePdfIn(i);
                                                    },
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
                                                        children: <Widget>[
                                                          const Text(
                                                              'ค่าใช้จ่ายอื่นๆ',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14)),
                                                          Spacer(),
                                                          Text(
                                                              i['other_expenses']
                                                                  .toString(),
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
          )),
    );
  }

  _generatePdfIn(Map<String, dynamic> data) async {
    print(data);
    final pdf = pw.Document();
    String formattedDateTime =
        DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    String formattedDate = DateFormat('dd/MM/yy').format(DateTime.now());
    final font = await PdfGoogleFonts.k2DThin();
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Column(children: [
          pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text('Export Date ' + formattedDateTime)),
          pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Text('รายรับรายจ่าย วันที่ ' + formattedDate,
                  style: pw.TextStyle(font: font, fontSize: 18))),
          pw.Table(children: [
            pw.TableRow(children: [
              pw.SizedBox(
                  width: 150,
                  child: pw.Text('รายการซื้อขาย',
                      style: pw.TextStyle(font: font, fontSize: 18))),
              pw.SizedBox(
                  width: 50,
                  child: pw.Text('',
                      style: pw.TextStyle(font: font, fontSize: 18))),
              pw.Container(
                  child: pw.Text('รายรับ',
                      style: pw.TextStyle(font: font, fontSize: 18))),
              pw.Container(
                  child: pw.Text('รายจ่าย',
                      style: pw.TextStyle(font: font, fontSize: 18)))
            ]),
            for (final subData in data['order'])
              pw.TableRow(children: [
                pw.SizedBox(
                    width: 150,
                    child: pw.Text(
                        subData['date_time'] + ' ' + subData['status'],
                        style: pw.TextStyle(font: font, fontSize: 12))),
                pw.SizedBox(
                    width: 50,
                    child: pw.Text('',
                        style: pw.TextStyle(font: font, fontSize: 18))),
                pw.Container(
                    child: pw.Text(
                        subData['status'] == "ขาย"
                            ? subData['total'].toString()
                            : ' ',
                        style: pw.TextStyle(font: font, fontSize: 12))),
                pw.Container(
                    child: pw.Text(
                        subData['status'] == "ซื้อ"
                            ? subData['total'].toString()
                            : ' ',
                        style: pw.TextStyle(font: font, fontSize: 12))),
              ]),
            pw.TableRow(children: [
              pw.Row(children: [
                pw.SizedBox(width: 100, height: 40),
              ]),
              pw.Padding(
                  padding: pw.EdgeInsets.only(top: 10, bottom: 10),
                  child: pw.Container(
                      child: pw.Text('ยอดรวม',
                          style: pw.TextStyle(font: font, fontSize: 12)))),
              pw.Padding(
                  padding: pw.EdgeInsets.only(top: 10, bottom: 10),
                  child: pw.Container(
                      child: pw.Text(totalSale.toString(),
                          style: pw.TextStyle(font: font, fontSize: 12)))),
              pw.Padding(
                  padding: pw.EdgeInsets.only(top: 10, bottom: 10),
                  child: pw.Container(
                      child: pw.Text(totalBuy.toString(),
                          style: pw.TextStyle(font: font, fontSize: 12)))),
            ]),
            pw.TableRow(children: [
              pw.Row(children: [
                pw.SizedBox(width: 100, height: 20),
              ]),
              pw.Container(
                  child: pw.Text('ค่าใช้จ่ายอื่นๆ',
                      style: pw.TextStyle(font: font, fontSize: 12))),
              pw.Container(
                  child: pw.Text(data['other_expenses'].toString(),
                      style: pw.TextStyle(font: font, fontSize: 12))),
              pw.Container(
                  child: pw.Text('',
                      style: pw.TextStyle(font: font, fontSize: 12)))
            ]),
            pw.TableRow(children: [
              pw.Row(children: [
                pw.SizedBox(
                  width: 100,
                ),
              ]),
              pw.Container(
                  child: pw.Text('กำไรสุทธิ',
                      style: pw.TextStyle(font: font, fontSize: 12))),
              pw.Container(
                  child: pw.Text(totalProfit.toString(),
                      style: pw.TextStyle(font: font, fontSize: 12))),
              pw.Container(
                  child: pw.Text('',
                      style: pw.TextStyle(font: font, fontSize: 12)))
            ]),
          ])
        ]);
      },
    ));
    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final file = File('$appDocPath/transaction.pdf');
    await file.writeAsBytes(await pdf.save(), flush: true);
    await OpenFile.open(file.path);
  }
}
