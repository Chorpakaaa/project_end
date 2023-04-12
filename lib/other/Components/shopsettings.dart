import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventoryapp/Other/other.dart';
import 'package:inventoryapp/provider/provider.dart';
import 'package:provider/provider.dart';
import '../../widget/my_textfield.dart';

class Shopsettings extends StatefulWidget {
  const Shopsettings({super.key});

  @override
  State<Shopsettings> createState() => _Shopsettings();
}

TextEditingController NameController = TextEditingController();
TextEditingController AddressController = TextEditingController();
TextEditingController NumberController = TextEditingController();

class _Shopsettings extends State<Shopsettings> {
  final db = FirebaseFirestore.instance;
  final nameStore = TextEditingController();

  _changeNameShop() async {
    try {
      final user = context.read<UserProvider>().user;
      await db
          .collection('stores')
          .doc(user!.storeId)
          .update({"store_name": nameStore.text});
      return true;
    } catch (e) {
      print('err $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'รายละเอียดร้านค้า',
          style: TextStyle(fontSize: 16),
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.save_alt,
                size: 25,
              ),
              onPressed: () async {
                if (await _changeNameShop()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Other()),
                  );
                }
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
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
              MyTextField(
                  controller: nameStore,
                  hintText: ('ชื่อร้าน'),
                  obscureText: false),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
