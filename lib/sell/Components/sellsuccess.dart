import 'package:flutter/material.dart';
import 'package:inventoryapp/provider/provider.dart';
import 'package:inventoryapp/sell/sell.dart';
import 'package:inventoryapp/widget/nevbar.dart';
import 'package:provider/provider.dart';

class SellSuccess extends StatefulWidget {
  const SellSuccess({super.key});

  @override
  State<SellSuccess> createState() => _SellSuccessState();
}

class _SellSuccessState extends State<SellSuccess> {
  List<int> arr = [1,3];
  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('รายละเอียดการขาย'),
      actions: <Widget>[
          TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    textStyle: const TextStyle(fontSize: 18)
                  ),
                  onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Sell()),
                );
              },
                  child: const Text('เสร็จ'),
                ),
        ],),
      body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 20.0, left: 5, right: 5),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(Icons.check_circle, color: Colors.green),
                      Text(
                        "ทำรายการสำเร็จ",
                        style: TextStyle(color: Colors.green, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: const <Widget>[
                      Text("เลขที่ 2152200320066", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
                Column(
                      children: arr.map((i) => 
                      Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: Colors.grey),
                    bottom: BorderSide(width: 1.0, color: Colors.grey),
                  ),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Column(
                      children: const [
                        Image(
                          image: AssetImage('assets/images/folder.png'),
                          width: 150,
                          height: 200,
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [Text('ชื่อสินค้า')],
                        ),
                        Row(
                          children: const <Widget>[
                            Text("ชื่อ/สี/ขนาด"),
                            Text("ราคาขาย*จำนวน=ราคา"),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),).toList()),
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
                    children: const <Widget>[
                      Text("จำนวนรวม"),
                      Spacer(),
                      Text("10"),
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
                    children: const <Widget>[
                      Text("ราคารวมทั้งสิ้น"),
                      Spacer(),
                      Text("1430"),
                    ],
                  ),
                ),
                Container(
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
                  // child: const IntrinsicWidth(
                  //   child: TextField(
                  //     textAlignVertical: TextAlignVertical.top,
                  //     decoration: InputDecoration(
                  //       hintText: 'รายละเอียดอื่นๆ',
                  //       border: InputBorder.none,
                  //     ),
                  //   ),
                  // ),ถ้าหน้าก่อนหน้ามีรายละเอียดยกมาจากหน้าก่อนหน้า ถ้าไม่มีหน้านี้ก็ไม่ขึ้นรายละเอียด
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavbar(number: 1,role: user!.role,),
        );
  }
}
