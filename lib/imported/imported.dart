import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventoryapp/db/my_project.dart';
import 'package:inventoryapp/db/store.dart';
import 'package:inventoryapp/imported/Components/edit.dart';
import 'package:inventoryapp/imported/Components/odering.dart';
import 'package:inventoryapp/sell/sell.dart';
import 'Class/product.dart';
import 'Components/order.dart';
import '../main.dart';
import '../widget/nevbar.dart';

import 'package:inventoryapp/provider/provider.dart';
import 'package:provider/provider.dart';

class Imported extends StatefulWidget {
  final Map<String, dynamic>? dataCallback;
  const Imported({Key? key, this.dataCallback}) : super(key: key);

  @override
  State<Imported> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Imported> {
  late String storeId = "";
  final db = FirebaseFirestore.instance;
  List listDatas = [];
  List newData = [];
  int newQuantity = 0;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    final user = context.read<UserProvider>().user;
    final item = context.read<ItemProvider>().items;
    final provider = Provider.of<ItemProvider>(context, listen: false);
    storeId = user != null ? user.storeId : '';
    if (item.length == 0) {
      QuerySnapshot querySnapshot = await db
          .collection('products')
          .where('store_id', isEqualTo: storeId)
          .get();
      querySnapshot.docs.forEach((element) {
        setState(() {
          listDatas.add({
            "product_id": element.id,
            "product_name": element['product_name'],
            "product_image": element['product_image']
          });
        });
      });
      provider.addItem(listDatas);
    } else {
      _newDataCallback(item);
    }
  }

  void _newDataCallback(List data) async {
    final item = context.read<ItemProvider>().items;
    final provider = Provider.of<ItemProvider>(context, listen: false);
    List updatedData = [];
    if (widget.dataCallback != null) {
      final Map<String, dynamic> subNewQuantity = widget.dataCallback!;
      data.forEach((element) {
        if (element['product_id'] == subNewQuantity['product_id']) {
          Map<String, dynamic> updatedElement =
              Map<String, dynamic>.from(element);
          updatedElement['new_subproduct'] =
              subNewQuantity['new_subproduct'].toList();
          updatedData.add(updatedElement);
        } else {
          updatedData.add(element);
        }
      });
      provider.addItem(updatedData);
      setState(() {
        listDatas = updatedData;
      });
    } else {
      QuerySnapshot querySnapshot = await db
          .collection('products')
          .where('store_id', isEqualTo: storeId)
          .get();
      querySnapshot.docs.forEach((element) {
        setState(() {
          listDatas.add({
            "product_id": element.id,
            "product_name": element['product_name'],
            "product_image": element['product_image']
          });
        });
      });
      provider.addItem(listDatas);
    }
    List resultQuantity = [];
    listDatas.forEach((element) {
      if (element['new_subproduct'] != null) {
        element['new_subproduct']
            .map((x) => resultQuantity.add(x['new_quantity']))
            .toList();
      }
    });
    newQuantity = resultQuantity.length > 0 ? resultQuantity.reduce((value, element) => value + element) : 0;
  }


  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('เพิ่ม/ซื้อสินค้าเข้า'),
        actions: <Widget>[
          Center(
            child: Text(
              newQuantity.toString() == "0" ? "" : newQuantity.toString(),
              style: TextStyle(fontSize: 22),
            ),
          ),
          IconButton(
              icon: const Icon(
                Icons.arrow_forward,
                size: 25,
              ),
              onPressed: () {
                List dataOrdering = [];
                listDatas.forEach((element) {
                  if (element['new_subproduct'] != null)
                    dataOrdering.add(element);
                });
                if (newQuantity > 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Odering(dataOrdering: dataOrdering)),
                  );
                } else {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('ไม่มีสินค้าในรายการที่ถูกเลือก'),
                        content: const Text('กรุณาเลือกสินค้าและระบุจำนวน'),
                        actions: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            child: const Text('ตกลง'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              }
              ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: " ค้นหา ",
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: Colors.deepOrange),
            ),
            Container(
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.deepOrange,
              ),
              child: Row(
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.only(left: 10, right: 0, top: 0, bottom: 0),
                    child: Icon(
                      Icons.folder_copy_outlined,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('หมวดหมู่สินค้า'),
                          content: SizedBox(
                            height: 70,
                            child: Column(
                              children: const [
                                Text('หมวดหมู่สินค้าทั้งหมด(3)'),
                                Text('หมวดหมู่DRESS(1)'),
                                Text('หมวดหมู่Oversize(2)'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      ),
                      child: const Text(
                        'หมวดหมู่ทั้งหมด',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: GridView.count(
                    crossAxisCount: 2,
                    children: listDatas
                        .map(
                          (data) => InkWell(
                              onTap: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderProduct(
                                              productId: data['product_id'])),
                                    )
                                  },
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 10.0,
                                      bottom: 10.0,
                                      top: 10.0,
                                      right: 10.0),
                                  decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0.0, 1.0),
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                    color: data['new_subproduct'] != null
                                        ? Color.fromARGB(255, 247, 143, 132)
                                        : Colors.deepOrange[50],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0, bottom: 5.0, top: 5.0),
                                        child: Text(
                                          data['product_name'],
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Center(
                                          child: FittedBox(
                                              child: Image(
                                        image:
                                            AssetImage(data['product_image']),
                                        height: 90,
                                        width: 90,
                                        fit: BoxFit.fill,
                                      )))
                                    ],
                                  ))),
                        )
                        .toList())),
          ],
        ),
      ),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const Imported()), //ต้องไปกล้องถ่ายQr
              )
            },
            heroTag: "fit_screen_sharp",
            child: const Icon(Icons.fit_screen_sharp),
          ),
        ),
        FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Edit()),
            );
          },
          heroTag: "add",
          child: const Icon(Icons.add),
        ),
      ]),
      bottomNavigationBar: BottomNavbar(number: 0 , role: user!.role,),
    );
  }
}
