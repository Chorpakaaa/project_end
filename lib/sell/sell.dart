import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventoryapp/imported/Class/product.dart';
import 'package:inventoryapp/imported/imported.dart';
import 'package:inventoryapp/provider/provider.dart';
import 'package:inventoryapp/sell/Components/details.dart';
import 'package:inventoryapp/sell/Components/export.dart';
import 'package:provider/provider.dart';
import '../widget/nevbar.dart';

class Sell extends StatefulWidget {
  final Map<String, dynamic>? dataCallback;
  const Sell({Key? key, this.dataCallback}) : super(key: key);
  // const Sell({super.key});

  @override
  State<Sell> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Sell> {
  late String storeId = "";
  late String role = "";
  TextEditingController _searchController = TextEditingController();
  List _searchResultList = [];
  final db = FirebaseFirestore.instance;
  List listDatas = [];
  List newData = [];
  int newQuantity = 0;
  List checkQuantity = [];
  @override
  void initState() {
    super.initState();
    _getData();
    _checkQuantity();
  }

  _checkQuantity() async {
    final user = context.read<UserProvider>().user;
    storeId = user != null ? user.storeId : '';
    await db
        .collection('products')
        .where('store_id', isEqualTo: storeId)
        .get()
        .then((value) async {
      for (final i in value.docs) {
        List quantityValue = [];
        await db
            .collection('sub_products')
            .where('product_id', isEqualTo: i.id)
            .get()
            .then((subData) {
          for (final j in subData.docs) {
            setState(() {
              quantityValue.add(j['sub_product_quantity']);
            });
          }
        });
        setState(() {
          checkQuantity.add({
            "product_id": i.id,
            "sub_quantity": [...quantityValue]
          });
        });
      }
    });
    checkQuantity.forEach((value) {
      value['sub_quantity'] =
          value['sub_quantity'].reduce((numr, e) => numr + e);
    });
    if (listDatas.isNotEmpty) {
      int i = 0;
      listDatas.forEach((element) {
        if (checkQuantity
            .map((e) => e['product_id'])
            .toList()
            .contains(element['product_id'])) {
          element['sale_out'] = checkQuantity[i]['sub_quantity'];
        }
        i++;
      });
    }
  }

  void _getData() async {
    final user = context.read<UserProvider>().user;
    final item = context.read<SellProvider>().items;
    final provider = Provider.of<SellProvider>(context, listen: false);
    storeId = user != null ? user.storeId : '';
    setState(() {
      role = user!.role;
    });
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
      _search('');
      provider.addItem(listDatas);
    } else {
      _newDataCallback(item);
    }
  }

  void _newDataCallback(List data) async {
    final item = context.read<SellProvider>().items;
    final provider = Provider.of<SellProvider>(context, listen: false);
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
      _search('');
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
      _search('');
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
    newQuantity = resultQuantity.length > 0
        ? resultQuantity.reduce((value, element) => value + element)
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('ขายสินค้าออก',style: TextStyle(fontSize: 20)),
          actions: <Widget>[
            Center(
              child: Text(
                newQuantity.toString() == "0" ? "" : newQuantity.toString(),
                style: TextStyle(fontSize: 22)
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
                    if (element['new_subproduct'] != null) {
                      dataOrdering.add(element);
                    }
                  });
                  if (newQuantity > 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Export(dataOrdering: dataOrdering)),
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
                                textStyle:
                                    Theme.of(context).textTheme.labelLarge,
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
                }),
          ],
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _searchController,
                onChanged: (query) => _search(query),
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: " ค้นหา ",
                    prefixIcon: Icon(Icons.search),
                    prefixIconColor: Colors.deepOrange),
              ),
              Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      children: _searchResultList
                          .map((i) => InkWell(
                              onTap: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Details(
                                              productId: i['product_id'])),
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
                                  color: i['new_subproduct'] != null
                                      ? Color.fromARGB(255, 247, 143, 132)
                                      : Colors.deepOrange[50],
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0)),
                                ),
                                child: Stack(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              left: 10.0,
                                              bottom: 5.0,
                                              top: 5.0),
                                          child: Text(i['product_name'],
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight:FontWeight.bold)),
                                        ),
                                        Center(
                                            child: FittedBox(
                                                child: Image.network(
                                          i['product_image'],
                                          height: 120,
                                          width: 120,
                                          fit: BoxFit.fill,
                                        )))
                                      ],
                                    ),
                                    if (i['sale_out'] != null)
                                      i['sale_out'] < 1
                                          ? Positioned.fill(
                                              child: Center(
                                                child: Container(
                                                  height: 30,
                                                  width: 100,
                                                  color: Colors.red,
                                                  child: Center(
                                                      child: Text('สินค้าหมด',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white))),
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink()
                                  ],
                                ),
                              )))
                          .toList()))
            ],
          ),
        ),
        bottomNavigationBar: BottomNavbar(
          number: 1,
          role: role,
        ));
  }

  void _search(String query) {
    List matches = [];
    matches.addAll(listDatas);
    if (query.isNotEmpty) {
      matches.retainWhere((match) {
        String productName = match['product_name'];
        return productName.toLowerCase().contains(query.toLowerCase());
      });
    }
    setState(() {
      _searchResultList.clear();
      _searchResultList.addAll(matches);
    });
  }
}
