import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventoryapp/sell/Components/export.dart';
import 'package:inventoryapp/sell/sell.dart';
import 'package:flutter/services.dart';

class Details extends StatefulWidget {
  final String productId;
  const Details({Key? key, required this.productId}) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  List sub_list = [];
  final db = FirebaseFirestore.instance;
  var prouduct = <String, dynamic>{
    "product_name": "",
    "product_code": "",
    "product_detail": "",
    "product_image": ""
  };
  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      _getData(widget.productId);
    }
  }

  _getData(String productId) async {
    await db.collection('products').doc(productId).get().then((value) {
      setState(() {
        prouduct = {
          "product_name": value['product_name'],
          "product_code": value['product_code'],
          "product_detail": value['product_detail'],
          "product_image": value['product_image']
        };
      });
    });

    QuerySnapshot querySnapshot = await db
        .collection('sub_products')
        .where('product_id', isEqualTo: productId)
        .get();
    querySnapshot.docs.forEach((element) {
      setState(() {
        final dataQuery = {
          "product_id": productId,
          "sub_product_id": element.id,
          "sub_product_name": element['sub_product_name'],
          "sub_product_cost": element['sub_product_cost'],
          "sub_product_price": element['sub_product_price'],
          "sub_product_quantity": element['sub_product_quantity'],
          "new_quantity": 0
        };
        sub_list.add(dataQuery);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('รายละเอียดสินค้า'),
          actions: <Widget>[
            IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                  size: 25,
                ),
                onPressed: () {
                  final checkNewQuantity = sub_list
                      .where((element) =>
                          element['new_quantity'] >
                          element['sub_product_quantity'])
                      .toList();
                  final checkAddQuantity = sub_list
                      .where((element) => element['new_quantity'] > 0)
                      .toList();
                  if (checkAddQuantity.length > 0) {
                    if (checkNewQuantity.length > 0) {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title:
                              const Text('กรุณาเช็คว่าเพิ่มสินค้าเกินหรือไม่'),
                          content: const Text('ตรวจสอบ จำนวน ให้ถูกต้อง'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      final dataCallback = <String, dynamic>{
                        "product_id": widget.productId,
                        "new_subproduct": checkAddQuantity.map((e) => ({
                              'sub_product_id': e['sub_product_id'],
                              'new_quantity': e['new_quantity'],
                              'sub_product_name': e['sub_product_name'],
                              'sub_product_price': e['sub_product_price'],
                              'sub_product_quantity': e['sub_product_quantity']
                            }))
                      };
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Sell(dataCallback: dataCallback)),
                      );
                    }
                  } else {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('ไม่ได้ระบุจำนวน'),
                        content: const Text('กรุณาระบุจำนวน'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'ตกลง'),
                            child: const Text('ตกลง'),
                          ),
                        ],
                      ),
                    );
                  }
                }),
          ],
        ),
        body: ListView(children: [
         Padding(
           padding: const EdgeInsets.all(10.0),
           child: Center(
                    child: FittedBox(
                        child: Image.network(
                    prouduct['product_image'].toString(),
                    height: 200,
                    width: 200,
                    fit: BoxFit.fill,
                  ))),
         ),
          Padding(
              padding: EdgeInsets.only(top: 30),
              child: TextField(
                enabled: false,
                controller:
                    TextEditingController(text: prouduct['product_name']),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'ชื่อสินค้า',
                    fillColor: Colors.deepOrange,
                    filled: true),
              )),
          TextField(
            enabled: false,
            controller: TextEditingController(text: prouduct['product_code']),
            decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'รหัสสินค้า',
                fillColor: Colors.deepOrange,
                filled: true),
          ),
          TextField(
            enabled: false,
            controller: TextEditingController(text: prouduct['product_detail']),
            decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'รายละเอียดสินค้า',
                fillColor: Colors.deepOrange,
                filled: true),
          ),
          Column(
            children: sub_list
                .map(
                  (i) => Container(
                    height: 140,
                    width: 400,
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0),
                          blurRadius: 5.0,
                        ),
                      ],
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(i['sub_product_name'],
                                style: const TextStyle(fontSize: 18)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    i['new_quantity'] -= 1;
                                  });
                                },
                                icon: Icon(Icons.remove),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    width: 150,
                                    height: 40,
                                    child: TextField(
                                      controller: TextEditingController(
                                          text: i['sub_product_price']
                                              .toString()),
                                      onChanged: (value) {
                                        i['sub_product_price'] =
                                            double.parse(value);
                                      },
                                      style: const TextStyle(
                                          color: Color(0xFFbdc6cf)),
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          icon: Icon(Icons.money_rounded),
                                          hintText: 'ราคา',
                                          fillColor: Colors.deepOrange,
                                          filled: true),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    height: 40,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 40),
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        controller: TextEditingController(
                                            text: i['new_quantity']
                                                        .toString() ==
                                                    "0"
                                                ? ""
                                                : i['new_quantity'].toString()),
                                        onChanged: (value) {
                                          i['new_quantity'] = int.parse(value);
                                        },
                                        style: const TextStyle(
                                            color: Color(0xFFbdc6cf)),
                                        decoration: const InputDecoration(
                                            contentPadding:
                                                EdgeInsets.only(left: 4.0),
                                            border: InputBorder.none,
                                            hintText: 'จำนวน',
                                            fillColor: Colors.deepOrange,
                                            filled: true),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      i['new_quantity'] += 1;
                                    });
                                  },
                                  icon: Icon(Icons.add)),
                              Row(
                                children: [
                                  Icon(Icons.warehouse),
                                  Text(i['sub_product_quantity'].toString()),
                                ],
                              )
                            ],
                          )
                        ]),
                  ),
                )
                .toList(),
          )
        ]));
  }
}
