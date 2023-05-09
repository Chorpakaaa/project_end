import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventoryapp/imported/Class/subproduct.dart';
import 'package:inventoryapp/imported/imported.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:inventoryapp/db/my_project.dart';
import 'package:inventoryapp/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:dio/dio.dart';
import 'package:cloudinary/cloudinary.dart';

class Edit extends StatefulWidget {
  final String? productId;
  // const Edit({super.key});
  const Edit({Key? key, this.productId}) : super(key: key);
  @override
  State<Edit> createState() => _Edit();
}

class _Edit extends State<Edit> {
  final picker = ImagePicker();
  final cloudinary = Cloudinary.signedConfig(
    apiKey: "511693798369728",
    apiSecret: "3k1s6MVKEzrK20Y7ghWKE9Gsgqo",
    cloudName: "dvkhkj7jo",
  );
  XFile? image;
  String imagesdb = "";
  String? base64Image;
  bool? checkImage = false;
  List listProducts = [
    {"index": 0, "name": '', "cost": 0, "price": 0, "quantity": 0}
  ];
  final db = FirebaseFirestore.instance;
  final _productNameController = TextEditingController();
  final _productDetailController = TextEditingController();
  String codeUpdate = '';
  List listDelete = [];
  _generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  late String randomString = _generateRandomString(4);
  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      _updateQueryProduct(widget.productId!);
    }
  }

  _convertBase64() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await File(pickedFile!.path).readAsBytesSync();
      final fileType = pickedFile.path.split('.').last;
      setState(() {
        image = pickedFile;
        base64Image = "data:image/$fileType;base64," + base64Encode(bytes);
      });
    }
  }

// https://adaptive-testing-api.vercel.app/image/img
  _updateQueryProduct(String productId) async {
    await db.collection('products').doc(productId).get().then((value) {
      _productNameController.text = value['product_name'];
      _productDetailController.text = value['product_detail'];
      setState(() {
        codeUpdate = value['product_code'];
        imagesdb = value['product_image'];
      });
    });
    final quertSubproduct = await db
        .collection('sub_products')
        .where('product_id', isEqualTo: productId)
        .get();
    setState(() {
      listProducts.removeAt(0);
    });
    for (int i = 0; i < quertSubproduct.docs.length; i++) {
      setState(() {
        listProducts.add({
          "index": i,
          "name": quertSubproduct.docs[i].data()['sub_product_name'],
          "cost": quertSubproduct.docs[i].data()['sub_product_cost'],
          "price": quertSubproduct.docs[i].data()['sub_product_price'],
          "quantity": quertSubproduct.docs[i].data()['sub_product_quantity'],
          "sub_product_id": quertSubproduct.docs[i].id
        });
      });
    }
    // print(listProducts);
  }

  _updateChangeProduct() async {
    if (widget.productId != null) {
      _loading();
      String imageUrl = "";
      if (base64Image != null && image != null) {
        final response = await cloudinary.upload(
            fileBytes: File(image!.path).readAsBytesSync(),
            progressCallback: (count, total) {
              print('Uploading image from file with progress: $count/$total');
            });
        if (response.isSuccessful) {
          setState(() {
            imageUrl = response.secureUrl!;
          });
        }
      }
      final dataProduct = <String, dynamic>{
        "product_name": _productNameController.text,
        "product_detail": _productDetailController.text,
        "product_image": imageUrl == "" ? imagesdb : imageUrl
      };
      await db.collection('products').doc(widget.productId).update(dataProduct);
      for (final data in listProducts) {
        if (data['sub_product_id'] != null) {
          final updateSubproduct = <String, dynamic>{
            "sub_product_cost": data['cost'],
            "sub_product_name": data['name'],
            "sub_product_price": data['price'],
            "sub_product_quantity": data['quantity']
          };
          await db
              .collection('sub_products')
              .doc(data['sub_product_id'])
              .update(updateSubproduct);
        }
        if (data['sub_product_id'] == null) {
          final addSubproduct = <String, dynamic>{
            "sub_product_cost": data['cost'],
            "sub_product_name": data['name'],
            "sub_product_price": data['price'],
            "sub_product_quantity": data['quantity'],
            "product_id": widget.productId
          };
          await db.collection('sub_products').add(addSubproduct);
        }
      }
      if (listDelete.length > 0) {
        for (final data in listDelete) {
          await db.collection('sub_products').doc(data).delete();
        }
      }

      return true;
    }
    return false;
  }

  _loading() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("กำลังโหลด...")
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;
    final storeId = user != null ? user.storeId : null;
    _createProducts(String name, String detail) async {
      String noImage =
          'https://res.cloudinary.com/dvkhkj7jo/image/upload/v1681409220/3674270-200_m6r8be.png';
      _loading();
      String imageUrl = '';
      if (base64Image != null && image != null) {
        final response = await cloudinary.upload(
            fileBytes: File(image!.path).readAsBytesSync(),
            progressCallback: (count, total) {
              print('Uploading image from file with progress: $count/$total');
            });
        if (response.isSuccessful) {
          setState(() {
            imageUrl = response.secureUrl!;
          });
        }
      }
      final data = <String, dynamic>{
        "product_name": name,
        "product_image": imageUrl == "" ? noImage : imageUrl,
        "store_id": storeId,
        "product_code": randomString,
        "product_detail": detail
      };
      await db.collection('products').add(data).then((value) async {
        for (final add_sub_data in listProducts) {
          final create_sub = <String, dynamic>{
            "product_id": value.id,
            "sub_product_cost": add_sub_data['cost'],
            "sub_product_name": add_sub_data['name'],
            "sub_product_price": add_sub_data['price'],
            "sub_product_quantity": add_sub_data['quantity']
          };
          await db.collection('sub_products').add(create_sub).then((subValue) {
            print(
                'this productId : ${value.id} this sub_productId : ${subValue.id}');
          });
        }
      });
      return true;
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('รายละเอียดสินค้า'),
        actions: <Widget>[
          TextButton(
              onPressed: () async {
                if (widget.productId != null) {
                  if (await _updateChangeProduct()) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Imported()),
                        (route) => false);
                  }
                } else {
                  if (await _createProducts(_productNameController.text,
                      _productDetailController.text)) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Imported()),
                        (route) => false);
                  }
                }
              },
              child: const Text(
                'บันทึก',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ))
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            if (imagesdb != "" && image == null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                    child: FittedBox(
                        child: Image.network(
                  imagesdb.toString(),
                  height: 200,
                  width: 200,
                  fit: BoxFit.fill,
                ))),
              ),
            if (image != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Container(
                    height: 200,
                    width: 200,
                    child: Image.file(File(image!.path)),
                  ),
                ),
              ),
            Container(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () => {_convertBase64()},
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(8.0),
                      ),
                    ),
                    child: const Text(
                      'เลือกรูปสินค้า',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.only(top: 30),
                child: TextField(
                  controller: _productNameController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'ชื่อสินค้า',
                      fillColor: Colors.deepOrange,
                      filled: true),
                )),
            Container(
              height: 60,
              padding: const EdgeInsets.only(left: 10),
              color: Colors.deepOrange,
              child: Row(
                children: [
                  Text('รหัสสินค้า'),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    widget.productId == null ? randomString : codeUpdate,
                  ),
                ],
              ),
            ),
            TextField(
              controller: _productDetailController,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'รายละเอียดสินค้า',
                  fillColor: Colors.deepOrange,
                  filled: true),
            ),
            Column(
                children: List.generate(
                    listProducts.length,
                    (index) => Container(
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0),
                                blurRadius: 5.0,
                              ),
                            ],
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              listProducts.length > 1
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(right: 20),
                                            child: TextButton(
                                                onPressed: () => {
                                                      showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                          title: Text(
                                                              'ลบรายการสินค้า?'),
                                                          content: const Text(
                                                              'กรุณายืนยันเพื่อลบสินค้านี้'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context,
                                                                      'Cancel'),
                                                              child: const Text(
                                                                  'Cancel'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () => {
                                                                setState(() {
                                                                  if (listProducts[
                                                                              index]
                                                                          [
                                                                          'sub_product_id'] !=
                                                                      null) {
                                                                    listDelete.add(
                                                                        listProducts[index]
                                                                            [
                                                                            'sub_product_id']);
                                                                  }
                                                                  print(
                                                                      listDelete);
                                                                  if (listProducts
                                                                          .length !=
                                                                      1) {
                                                                    listProducts.removeWhere((item) =>
                                                                        item[
                                                                            'index'] ==
                                                                        listProducts[index]
                                                                            [
                                                                            'index']);
                                                                  }
                                                                }),
                                                                Navigator.pop(
                                                                    context,
                                                                    'OK')
                                                              },
                                                              child: const Text(
                                                                  'OK'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    },
                                                child: RichText(
                                                  text: const TextSpan(
                                                    children: [
                                                      WidgetSpan(
                                                        child: Icon(
                                                          Icons.delete,
                                                          size: 20,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )))
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                              Center(
                                child: IntrinsicWidth(
                                  child: TextField(
                                    controller: TextEditingController(
                                        text: listProducts[index]['name']
                                            .toString()),
                                    onChanged: (value) =>
                                        {listProducts[index]['name'] = value},
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.color_lens),
                                      hintText: 'ชื่อ/สี/ขนาด',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: IntrinsicWidth(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: TextEditingController(
                                        text: listProducts[index]['cost']
                                                    .toString() ==
                                                '0'
                                            ? ""
                                            : listProducts[index]['cost']
                                                .toString()),
                                    onChanged: (value) => {
                                      listProducts[index]['cost'] =
                                          double.parse(value)
                                    },
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.money),
                                      hintText: 'ราคาทุน',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: IntrinsicWidth(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: TextEditingController(
                                        text: listProducts[index]['price']
                                                    .toString() ==
                                                '0'
                                            ? ""
                                            : listProducts[index]['price']
                                                .toString()),
                                    onChanged: (value) => {
                                      listProducts[index]['price'] =
                                          double.parse(value)
                                    },
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.sell_outlined),
                                      hintText: 'ราคาขาย',
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: Center(
                                  child: IntrinsicWidth(
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      controller: TextEditingController(
                                          text: listProducts[index]['quantity']
                                                      .toString() ==
                                                  '0'
                                              ? ""
                                              : listProducts[index]['quantity']
                                                  .toString()),
                                      onChanged: (value) => {
                                        listProducts[index]['quantity'] =
                                            int.parse(value)
                                      },
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.add_box),
                                        hintText: 'จำนวนที่ซื้อเข้า',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () => {
                                setState(() {
                                  listProducts.add({
                                    "index":
                                        listProducts[listProducts.length - 1]
                                                ['index'] +
                                            1,
                                    "name": '',
                                    "cost": 0,
                                    "price": 0,
                                    "quantity": 0
                                  });
                                }),
                              },
                          child: Row(
                            children: const [
                              Text('เพิ่มรายการสินค้า',
                                  style: TextStyle(color: Colors.white)),
                              Icon(
                                Icons.add,
                                size: 20,
                              )
                            ],
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ])),
    );
  }
}
