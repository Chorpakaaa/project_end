import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Orderdetail extends StatefulWidget {
  final String orderId;
  const Orderdetail({Key? key, required this.orderId}) : super(key: key);

  @override
  State<Orderdetail> createState() => _OrderdetailState();
}

class _OrderdetailState extends State<Orderdetail> {
  List arr = [];
  final db = FirebaseFirestore.instance;
  var dataOrder = <String, dynamic>{};
  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData() async {
    await db.collection('orders').doc(widget.orderId).get().then((value) async {
      setState(() {
        dataOrder = {
          "date_time": value['date_time'],
          "order_number": value['order_number'],
          "role": value['role'],
          "total": value['total'],
          "total_quantity": value['total_quantity']
        };
      });
      final queryOrderItem = await db
          .collection('order_item')
          .where('order_id', isEqualTo: value.id)
          .get();
      for (final dataOrderItem in queryOrderItem.docs) {
        final querySubItem = await db
            .collection('sub_item')
            .where('order_item_id', isEqualTo: dataOrderItem.id)
            .get();
        List subItem = [];
        for (final dataSubItem in querySubItem.docs) {
          setState(() {
            subItem.add(dataSubItem.data());
          });
        }
        setState(() {
           arr.add({
            "item_image": dataOrderItem['item_image'],
            "item_name": dataOrderItem['item_name'],
            "sub_product":[...subItem]
          });
        });
      }
    });
  print(arr);
    // print(dataOrder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('รายละเอียดการออเดอร์'),
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
                    Text(dataOrder['date_time'],
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
                                  Image(
                                    image: AssetImage(i['item_image']),
                                    width: 100,
                                    height: 100,
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    i['item_name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  Column(
                                    children: i['sub_product']
                                        .map<Widget>((iSub) => Row(
                                              children: [
                                                Container(
                                                    width: 80,
                                                    child: Text(iSub[
                                                        'sub_item_name'])),
                                                Text((iSub['sub_item_cost'] == 0 ? iSub['sub_item_price'] : iSub['sub_item_cost'])
                                                        .toString() +
                                                    ' x ' +
                                                    iSub['sub_item_quantity']
                                                        .toString()),
                                                Text(' = ' +
                                                    (iSub['sub_item_cost'] *
                                                            iSub[
                                                                'sub_item_quantity'])
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
                    Text(dataOrder['order_number']),
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
                    Text(dataOrder['total_quantity'].toString()),
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
                    Text(dataOrder['total'].toString()),
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
                    const Text("สร้างโดย"),
                    const Spacer(),
                    Text(dataOrder['role']),
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
      // bottomNavigationBar: BottomNavbar(number: 0),
    );
  }
}
