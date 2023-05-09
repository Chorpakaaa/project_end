import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final picker = ImagePicker();
  XFile? image;
  String imagesdb = "";
  String? base64Image;

  final cloudinary = Cloudinary.signedConfig(
    apiKey: "511693798369728",
    apiSecret: "3k1s6MVKEzrK20Y7ghWKE9Gsgqo",
    cloudName: "dvkhkj7jo",
  );
  @override
  void initState() {
    super.initState();
    _fetchImage();
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

  _fetchImage() async {
    final user = context.read<UserProvider>().user;
    await db.collection('stores').doc(user!.storeId).get().then((value) {
      setState(() {
        imagesdb = value['store_image'];
      });
    });
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

  _changeNameShop() async {
    try {
      if (nameStore.text.length > 0) {
        final user = context.read<UserProvider>().user;
        String imageUrl = '';
        _loading();
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
        await db.collection('stores').doc(user!.storeId).update({
          "store_name": nameStore.text,
          "store_image": imageUrl == "" ? imagesdb : imageUrl
        });
        return true;
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('กรุณากรอกให้ครบถ้วน'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('ตกลง'),
              ),
            ],
          ),
        );
      }
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
                  Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Other()),
                                  (route) => false);
                } else {
                  Navigator.pop(context);
                }
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
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
