import 'package:flutter/material.dart';
import 'package:inventoryapp/account/Components/auditmonth.dart';

class Saleproductyear extends StatefulWidget {
  const Saleproductyear({super.key});

  @override
  State<Saleproductyear> createState() => _SaleproductyearState();
}

class _SaleproductyearState extends State<Saleproductyear> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 5, right: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: const <Widget>[
                            Text('ปี : 2022', style: TextStyle(fontSize: 16)),//ปฏิทิน
                            Spacer(),
                            Text('26,550.00', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      Row(
                        children: [
                          Padding(padding: const EdgeInsets.all(5),
                         child: Row(
                          children: [
                              const SizedBox(height: 30),
                              TextButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.all(5),
                                  textStyle: const TextStyle(fontSize: 15),
                                  primary: Colors.black,
                                  side: const BorderSide(
                                      width: 1, color: Colors.black),
                                ),
                                onPressed: () {},
                                child: const Text('Export PDF',//ไฟล์ pdf
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ],
                         ),
                         
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: const <Widget>[
                                  Icon(Icons.people),
                                  Text('ผู้ขาย',
                                      style: TextStyle(fontSize: 17)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                children: const <Widget>[
                                  Icon(Icons.paste_rounded),
                                  Text('เจ้าของร้าน',
                                      style: TextStyle(fontSize: 15)),
                                  Spacer(),
                                  Text('120.00',
                                      style: TextStyle(fontSize: 15)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
                ),
                  Container(
                  margin: const EdgeInsets.only(top: 20, left: 5, right: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: const <Widget>[
                            Text('ปี : 2022', style: TextStyle(fontSize: 16)),
                            Spacer(),
                            Text('0.00', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.fromLTRB(110, 0, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(30),
                              child: Row(
                                children: const <Widget>[
                                  Text('ไม่มีข้อมูล',
                                      style: TextStyle(fontSize: 17)),
                                ],
                              ),
                            ),
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
      );
  }
}