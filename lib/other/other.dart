import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventoryapp/login/login.dart';
import 'package:inventoryapp/other/Components/managerole.dart';
import 'package:inventoryapp/other/Components/shopsettings.dart';
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
  String imageUrl = "";
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
        imageUrl = value['store_image'];
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
            'อื่นๆ',style: TextStyle(fontSize: 20),
          ),
          backgroundColor: Colors.deepOrange,
        ),

        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              if(imageUrl != "")
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                      child: FittedBox(
                          child: Image.network(
                    imageUrl.toString(),
                    height: 200,
                    width: 200,
                    fit: BoxFit.fill,
                  ))),
                ),
              Center(
                child: Text('ชื่อร้านค้า ' + nameStore,style: const TextStyle(fontSize: 16,fontWeight:FontWeight.bold)),
              ),
              const SizedBox(
                height: 15,
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
                                style: TextStyle(fontSize: 16,color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
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
                                style: TextStyle(fontSize: 16,color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
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
                      style: TextStyle(fontSize: 16,color: Colors.white),
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
