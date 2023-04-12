
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventoryapp/account/Components/expenses.dart';
import 'package:inventoryapp/provider/provider.dart';
import 'package:provider/provider.dart';

class Productdetails extends StatefulWidget {
  const Productdetails({super.key});

  @override
  State<Productdetails> createState() => _ProductdetailsState();
}

class _ProductdetailsState extends State<Productdetails> {
  final db = FirebaseFirestore.instance;
  List listData = [];
  double totalCost = 0;
  double totalPrice = 0;
  num totalQuantity = 0;
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _fetchData() async {
    final user = context.read<UserProvider>().user;
    await db
        .collection('products')
        .where('store_id', isEqualTo: user!.storeId)
        .get()
        .then((value) async {
      for (final product in value.docs) {
        List listSubProduct = [];
        List sumCost = [];
        List sumPrice = [];
        List sumQunatity = [];
        await db
            .collection('sub_products')
            .where('product_id', isEqualTo: product.id)
            .get()
            .then((sub) {
          for (final subProduct in sub.docs) {
            final dataSub = <String, dynamic>{
              "sub_product_cost": subProduct['sub_product_cost'],
              "sub_product_id": subProduct.id,
              "sub_product_name": subProduct['sub_product_name'],
              "sub_product_price": subProduct['sub_product_price'],
              "sub_product_quantity": subProduct['sub_product_quantity'],
            };
            setState(() {
              listSubProduct.add(dataSub);
              sumCost.add(subProduct['sub_product_cost']);
              sumPrice.add(subProduct['sub_product_price']);
              sumQunatity.add(subProduct['sub_product_quantity']);
            });
          }
        });
        final addProduct = <String, dynamic>{
          "product_code": product['product_code'],
          "product_name": product['product_name'],
          "product_image": product['product_image'],
          "product_detail": product['product_detail'],
          "sub_product": [...listSubProduct],
          "product_id": product.id
        };
        setState(() {
          listData.add(addProduct);
          totalCost += sumCost.reduce((value, element) => value + element);
          totalPrice += sumPrice.reduce((value, element) => value + element);
          totalQuantity += sumQunatity.reduce((value, element) => value + element);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายละเอียดสินค้าคงคลัง"),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(width: 0.5, color: Colors.grey))),
                height: 50,
                child: Row(
                  children: [
                    const SizedBox(height: 30),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(5),
                        textStyle: const TextStyle(fontSize: 15),
                        primary: Colors.black,
                        side: const BorderSide(width: 1, color: Colors.black),
                        //backgroundColor: Colors.white,
                      ),
                      onPressed: () {},
                      child: const Text('Export PDF'), //ไฟล์ pdf
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(width: 0.5, color: Colors.grey))),
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("จำนวนสินค้าคงคลัง",
                        style: TextStyle(color: Colors.black, fontSize: 14)),
                   const Spacer(),
                    Text(totalQuantity.toString()),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(width: 0.5, color: Colors.grey))),
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    const Text("มูลค่าสินค้าคงคลัง",
                        style: TextStyle(color: Colors.black, fontSize: 14)),
                   const Spacer(),
                    Text(totalCost.toString(),
                        style: const TextStyle(color: Colors.black, fontSize: 14)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(width: 0.5, color: Colors.grey))),
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("มูลค่าราคาขายสินค้าคงคลัง",
                        style: TextStyle(color: Colors.black, fontSize: 14)),
                    const Spacer(),
                    Text(totalPrice.toString(),
                        style: const TextStyle(color: Colors.black, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.deepOrange,
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("รายการสินค้าคงคลัง",
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                  ],
                ),
              ), //
              Column(
                  children: listData
                      .map(
                        (i) => Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            )),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Image(
                                      image: AssetImage(i['product_image']),
                                      width: 100,
                                      height: 100,
                                    ),
                                    Text(i['product_name'])
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                    children: i['sub_product']
                                        .map<Widget>(
                                          (sub) => Container(
                                            child: Center(
                                              child: Column(children: [
                                                Text(sub['sub_product_name'],
                                                    style:const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14)),
                                                Text('จำนวน : ' + sub['sub_product_quantity'].toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14)),
                                                Text('มูลค่าต้นทุน : ' + sub['sub_product_cost'].toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14)),
                                                Text('มูลค่าราคาขาย : '  + sub['sub_product_price'].toString(),
                                                    style:const  TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14)),
                                                      const  SizedBox(height: 5,)
                                              ]),
                                            ),
                                          ),
                                        )
                                        .toList()),
                                Spacer()
                              ],
                            )),
                      )
                      .toList()),
            ],
          )
        ]),
      ),
    );
  }
}
