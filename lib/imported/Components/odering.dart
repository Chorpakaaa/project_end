import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventoryapp/imported/imported.dart';
import 'package:inventoryapp/provider/provider.dart';
import 'package:inventoryapp/widget/nevbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Odering extends StatefulWidget {
  final List? dataOrdering;
  const Odering({Key? key, this.dataOrdering}) : super(key: key);

  @override
  State<Odering> createState() => _OderingState();
}

String generateRandomNumber() {
  Random random = Random();
  int randomNumber = random.nextInt(900000) + 100000;
  return randomNumber.toString();
}

class _OderingState extends State<Odering> {
  List arr = [];
  int allQuantity = 0;
  final db = FirebaseFirestore.instance;
  num allProduct_cost = 0;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  String orderNumber = '0000' + generateRandomNumber();
  _getData() {
    setState(() {
      arr = widget.dataOrdering!;
    });
    List newQuantity = [];
    List newCost = [];
    for (final e in arr) {
      e['new_subproduct'].map((value) {
        setState(() {
          newQuantity.add(value['new_quantity']);
          newCost.add(value['sub_product_cost'] * value['new_quantity']);
        });
      }).toList();
    }
    allQuantity = newQuantity.reduce((value, element) => value + element);
    allProduct_cost = newCost.reduce((value, element) => value + element);
  }

  Future<bool> _sendData() async {
    final provider = Provider.of<ItemProvider>(context, listen: false);
    for (final i in arr) {
      for (final j in i['new_subproduct']) {
        final washingtonRef =
            db.collection("sub_products").doc(j['sub_product_id']);
        washingtonRef.update({
          "sub_product_quantity": j['sub_product_quantity'] + j['new_quantity']
        }).then((value) => print("DocumentSnapshot successfully updated!"),
            onError: (e) => print("Error updating document $e"));
      }
    }
    @override
    final user = context.read<UserProvider>().user;
    final orderSend = <String, dynamic>{
      "status": "ซื้อ",
      "date_time": formattedDate,
      "order_number": orderNumber,
      "name": user!.name,
      "total": allProduct_cost,
      'total_quantity': allQuantity,
      'transac_id': user.transacId,
    };
    await db.collection('orders').add(orderSend).then((value) async {
      for (final data in arr) {
        final addOrderItem = <String, dynamic>{
          "item_image": data['product_image'],
          "item_name": data['product_name'],
          "order_id": value.id
        };
        await db
            .collection('order_item')
            .add(addOrderItem)
            .then((orderItem) async {
          for (final subData in data['new_subproduct']) {
            final addSubItem = <String, dynamic>{
              "order_item_id": orderItem.id,
              "sub_item_cost": subData['sub_product_cost'],
              "sub_item_price": 0,
              "sub_item_name": subData['sub_product_name'],
              "sub_item_quantity": subData['new_quantity']
            };
            await db
                .collection('sub_item')
                .add(addSubItem)
                .then((_) => print('succes'));
          }
        });
      }
    });

    provider.clearItem();
    return true;
  }

  String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('รายละเอียดการสั่งซื้อ'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.check,
                size: 25,
              ),
              onPressed: () async {
                if (await _sendData()) {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('ออเดอร์ซื้อสำเร็จ'),
                        content: const Text('คลิก ตกลง เพื่อกลับหน้าหลัก'),
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: const Text('ตกลง'),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Imported()),
                                  (route) => false);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 20.0, left: 5, right: 5),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    const Text("เวลาทำรายการ", style: TextStyle(fontSize: 18)),
                    Spacer(),
                    Text(formattedDate, style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              Column(
                  children: arr
                      .map(
                        (i) => Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 1.0, color: Colors.grey),
                              bottom:
                                  BorderSide(width: 1.0, color: Colors.grey),
                            ),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  FittedBox(
                                      child: Image.network(
                                    i['product_image'],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.fill,
                                  ))
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    i['product_name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  Column(
                                    children: i['new_subproduct']
                                        .map<Widget>((iSub) => Row(
                                              children: [
                                                Container(
                                                    width: 80,
                                                    child: Text(iSub[
                                                        'sub_product_name'])),
                                                Text(iSub['sub_product_cost']
                                                        .toString() +
                                                    ' x ' +
                                                    iSub['new_quantity']
                                                        .toString()),
                                                Text(' = ' +
                                                    (iSub['sub_product_cost'] *
                                                            iSub[
                                                                'new_quantity'])
                                                        .toString())
                                              ],
                                            ))
                                        .toList(),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                      .toList()),
              Container(
                padding: const EdgeInsets.all(10.0),
                height: 50,
                width: 400,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 0.5, color: Colors.grey),
                  ),
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    const Text("เลขที่"),
                    const Spacer(),
                    Text(orderNumber.toString() == "0"
                        ? ""
                        : orderNumber.toString()),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                height: 50,
                width: 400,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 0.5, color: Colors.grey),
                  ),
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    const Text("จำนวนสินค้ารวม"),
                    const Spacer(),
                    Text(allQuantity.toString() == "0"
                        ? ""
                        : allQuantity.toString()),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                height: 50,
                width: 400,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 0.5, color: Colors.grey),
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    const Text("ราคารวมทั้งหมด"),
                    const Spacer(),
                    Text(allProduct_cost.toString() == "0"
                        ? ""
                        : allProduct_cost.toString()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
