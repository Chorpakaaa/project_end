import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventoryapp/account/Components/orderdetail.dart';
import 'package:inventoryapp/account/Components/saleproductmonth.dart';
import 'package:inventoryapp/account/Components/saleproductyear.dart';
import 'package:inventoryapp/account/auditday.dart';
import 'package:inventoryapp/provider/provider.dart';
import 'package:inventoryapp/widget/nevbar.dart';
import 'package:provider/provider.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
    String formattedDate = DateFormat('dd/MM/yy').format(DateTime.now());
    final user = context.read<UserProvider>().user;
    await db
        .collection('transactions')
        .where('store_id', isEqualTo: user!.storeId)
        .get()
        .then((value) async {
      for (final data in value.docs) {
        List sumSale = [];
        List listOrder = [];
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
              "name": subData['name'],
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
                                              padding: const EdgeInsets.all(5),
                                              textStyle:
                                                  const TextStyle(fontSize: 15),
                                              primary: Colors.black,
                                              side: const BorderSide(
                                                  width: 1,
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              _generatePdf(i);
                                            },
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
                                                          alignment:
                                                              Alignment.topLeft,
                                                          height: 35,
                                                          width: 60,
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          color:
                                                              Colors.green[300],
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
                                                            children: <Widget>[
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
                                                      padding: const EdgeInsets
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
                                                      padding: const EdgeInsets
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
                                                      padding: const EdgeInsets
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
                                                                            'name'],
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
                                            padding: const EdgeInsets.fromLTRB(
                                                110, 0, 0, 0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(30),
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
            )
          ],
        )
      ),
    );
  }

  _generatePdf(Map<String, dynamic> data) async {
    final doc = pw.Document();
    String formattedDateTime =
        DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    final font = await PdfGoogleFonts.k2DThin();
    List userOrder = [];
    final obj = {};
    List sum = [];
    for (final i in data['order']) {
      userOrder.add({"name": i['name'], "total": i['total']});
    }
    Map<String, dynamic> result = {};
    for (final item in userOrder) {
      final name = item['name'];
      final total = item['total'];

      if (result.containsKey(name)) {
        result[name] += total;
      } else {
        result[name] = total;
      }
    }
    final output = result.entries
        .map((entry) => {"name": entry.key, "total": entry.value})
        .toList();
    doc.addPage(pw.Page(
      build: (context) {
        return pw.Column(children: [
          pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text('Export Date ' + formattedDateTime)),
          pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Text('ยอดขายวันที่ ' + data['date'],
                  style: pw.TextStyle(font: font, fontSize: 18))),
          pw.SizedBox(height: 10),
          pw.Table(
              border: pw.TableBorder(
                  bottom: pw.BorderSide(
                color: PdfColors.grey,
                width: 1.0,
                style: pw.BorderStyle.solid,
              )),
              children: [
                pw.TableRow(children: [
                  pw.Container(
                      width: 50,
                      child: pw.Center(
                          child: pw.Text('เวลาทำรายการ',
                              style: pw.TextStyle(font: font, fontSize: 14)))),
                  pw.Container(
                      width: 50,
                      child: pw.Center(
                          child: pw.Text('เลขที่อ้างอิง',
                              style: pw.TextStyle(font: font, fontSize: 14)))),
                  pw.Container(
                      width: 50,
                      child: pw.Center(
                          child: pw.Text('ผู้ขาย',
                              style: pw.TextStyle(font: font, fontSize: 14)))),
                  pw.Container(
                      width: 80,
                      child: pw.Center(
                          child: pw.Text('ยอดขาย',
                              style: pw.TextStyle(font: font, fontSize: 14)))),
                ]),
              ]),
          pw.SizedBox(height: 5),
          pw.Table(
              border: pw.TableBorder(
                  bottom: pw.BorderSide(
                color: PdfColors.grey,
                width: 1.0,
                style: pw.BorderStyle.solid,
              )),
              children: [
                for (final subData in data['order'])
                  pw.TableRow(children: [
                    pw.Container(
                        width: 50,
                        child: pw.Text(subData['date_time'],
                            style: pw.TextStyle(font: font, fontSize: 10))),
                    pw.Container(
                        width: 50,
                        child: pw.Text(subData['order_number'].toString(),
                            style: pw.TextStyle(font: font, fontSize: 10))),
                    pw.Container(
                        width: 50,
                        child: pw.Center(
                            child: pw.Text(subData['name'],
                                style:
                                    pw.TextStyle(font: font, fontSize: 10)))),
                    pw.Container(
                        width: 80,
                        child: pw.Align(
                            alignment: pw.Alignment.centerRight,
                            child: pw.Padding(
                                padding: pw.EdgeInsets.only(right: 10),
                                child: pw.Text(subData['total'].toString(),
                                    style: pw.TextStyle(
                                        font: font, fontSize: 10))))),
                  ]),
              ]),
          pw.SizedBox(height: 10),
          pw.Container(
            height: 100,
            child: pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    width: double.infinity,
                  ),
                ),
                pw.Expanded(
                  child: pw.Container(
                    width: double.infinity,
                    child: pw.Column(children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('ยอดขายรวม',
                                style: pw.TextStyle(font: font, fontSize: 14)),
                            pw.Padding(
                                padding: pw.EdgeInsets.only(right: 10),
                                child: pw.Text(data['profit'].toString(),
                                    style: pw.TextStyle(
                                        font: font, fontSize: 14))),
                          ]),
                      pw.Divider(thickness: 0.5),
                      pw.Align(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Column(children: [
                          pw.Text('ผู้ขาย',
                              style: pw.TextStyle(font: font, fontSize: 14)),
                          pw.Divider(thickness: 0.5),
                          for (final i2 in output)
                            pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Text(i2['name'],
                                      style: pw.TextStyle(
                                          font: font, fontSize: 10)),
                                  pw.Padding(
                                      padding: pw.EdgeInsets.only(right: 10),
                                      child: pw.Text(i2['total'].toString(),
                                          style: pw.TextStyle(
                                              font: font, fontSize: 10))),
                                ]),
                        ]),
                      ),
                      pw.Divider(thickness: 0.5)
                    ]),
                  ),
                ),
              ],
            ),
          )
        ]);
      },
    ));
    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final file = File('$appDocPath/ordersale.pdf');
    await file.writeAsBytes(await doc.save(), flush: true);
    await OpenFile.open(file.path);
  }
}
