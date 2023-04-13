import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventoryapp/provider/provider.dart';
import 'package:inventoryapp/sell/Components/sellsuccess.dart';
import 'package:inventoryapp/sell/sell.dart';
import 'package:inventoryapp/widget/nevbar.dart';
import 'package:provider/provider.dart';

class Export extends StatefulWidget {
  final List? dataOrdering;
  const Export({Key? key, this.dataOrdering}) : super(key: key);
  @override
  State<Export> createState() => _ExportState();
}

String generateRandomNumber() {
  Random random = Random();
  int randomNumber = random.nextInt(900000) +
      100000; // Generates a random number between 100000 and 999999
  return randomNumber.toString();
}

class _ExportState extends State<Export> {
  List arr = [];
  int allQuantity = 0;
  final db = FirebaseFirestore.instance;
  num allProduct_price = 0;
  String genNumber = '0000' + generateRandomNumber();
  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() {
    setState(() {
      arr = widget.dataOrdering!;
    });
    List newQuantity = [];
    List newPrice = [];
    for (final e in arr) {
      e['new_subproduct'].map((value) {
        setState(() {
          newQuantity.add(value['new_quantity']);
          newPrice.add(value['sub_product_price'] * value['new_quantity']);
        });
      }).toList();
    }
    allQuantity = newQuantity.reduce((value, element) => value + element);
    allProduct_price = newPrice.reduce((value, element) => value + element);
  }

  Future<bool> _sendData() async {
    final provider = Provider.of<SellProvider>(context, listen: false);
    for (final i in arr) {
      for (final j in i['new_subproduct']) {
        final washingtonRef =
            db.collection("sub_products").doc(j['sub_product_id']);
        washingtonRef.update({
          "sub_product_quantity": j['sub_product_quantity'] - j['new_quantity']
        }).then((value) => print("DocumentSnapshot successfully updated!"),
            onError: (e) => print("Error updating document $e"));
      }
    }

    final user = context.read<UserProvider>().user;

    final orderSend = <String, dynamic>{
      "status": "ขาย",
      "date_time": formattedDate,
      "order_number": genNumber,
      "name": user!.name,
      "total": allProduct_price,
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
              "sub_item_price": subData['sub_product_price'],
              "sub_item_cost": 0,
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
        title: const Text('รายละเอียดการขาย'),
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
                        title: const Text('ออเดอร์ขายสำเร็จ'),
                        content: const Text('คลิก ตกลง เพื่อกลับหน้าหลัก'),
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: const Text('ตกลง'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Sell()),
                              );
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
                    Text(formattedDate,
                        style: TextStyle(fontSize: 18)), //ทำให้เป็นวันที่จริงๆ
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
                                        .map<Widget>((i_sub) => Row(
                                              children: [
                                                Container(
                                                    width: 80,
                                                    child: Text(i_sub[
                                                        'sub_product_name'])),
                                                Text(i_sub['sub_product_price']
                                                        .toString() +
                                                    ' x ' +
                                                    i_sub['new_quantity']
                                                        .toString()),
                                                Text(' = ' +
                                                    (i_sub['sub_product_price'] *
                                                            i_sub[
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
                    Text(genNumber.toString() == "0"
                        ? ""
                        : genNumber.toString()),
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
                    const Text("ราคารวมทั้งสิ้น"),
                    const Spacer(),
                    Text(allProduct_price.toString() == "0"
                        ? ""
                        : allProduct_price.toString()),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                height: 150,
                width: 400,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 3.0,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(0.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
