import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventoryapp/login/login.dart';
import 'package:inventoryapp/other/Components/Changepassword.dart';
import 'package:inventoryapp/other/Components/managerole.dart';
import 'package:inventoryapp/other/Components/shopsettings.dart';
import 'package:inventoryapp/other/Components/swichaccount.dart';
import 'package:inventoryapp/provider/provider.dart';
import 'package:inventoryapp/widget/nevbar.dart';
import 'package:provider/provider.dart';

class Other extends StatefulWidget {
  const Other({super.key});

  @override
  State<Other> createState() => _Other();
}

class _Other extends State<Other> {
  final _formKey = GlobalKey<FormState>();
  final db = FirebaseFirestore.instance;
  String nameStore = '';
  @override
  void initState() {
    super.initState();
    _fecthShop();
  }

  _fecthShop() async {
    final user = context.read<UserProvider>().user;
    await db.collection('stores').doc(user!.storeId).get().then((value) {
      setState(() {
        nameStore = value['store_name'];
      });
    });
  }

  void _clearData() {
    final provider = Provider.of<ItemProvider>(context, listen: false);
    final providerSell = Provider.of<SellProvider>(context, listen: false);
    final setIndex = Provider.of<IndexNavbar>(context, listen: false);

    provider.clearItem();
    providerSell.clearItem();
    setIndex.addIndex(0);
  }
  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'อื่นๆ',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.deepOrange,
        ),

        // สลับบัญชี
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: const Image(
                  image: AssetImage('assets/images/wh2.jpg'),
                  height: 150,
                  width: 200,
                ),
              ),
              Center(
                child: Text('ชื่อร้าน ' + nameStore),
              ),
              SizedBox(
                height: 20,
              ),
              user!.role == "เจ้าของร้าน"
                  ? Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            minimumSize: const Size.fromHeight(50),
                          ),
                          onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Shopsettings(),
                                )),
                          },
                          child: Row(
                            children: const <Widget>[
                              Text(
                                'ตั้งค่ารายละเอียดร้านค้า',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            minimumSize: const Size.fromHeight(50),
                          ),
                          onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ManageRole(),
                                )),
                          },
                          child: Row(
                            children: const <Widget>[
                              Text(
                                'จัดการบทบาทและผู้ช่วย/ผู้ใช้อื่น',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () async {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('คุณต้องการออกจากระบบ?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('ยกเลิก'),
                        ),
                        TextButton(
                          onPressed: () => {
                            _clearData(),
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginSreen()),
                                (route) => false),
                          },
                          child: const Text('ตกลง'),
                        ),
                      ],
                    ),
                  );
                },
                child: Row(
                  children: const <Widget>[
                    Text(
                      'ออกจากระบบ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavbar(
          number: 3,
          role: user!.role,
        ));
  }
}
