import 'package:flutter/material.dart';

class Barcode extends StatefulWidget {
  const Barcode({super.key});

  @override
  State<Barcode> createState() => _BarcodeState();
}

class _BarcodeState extends State<Barcode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('รายละเอียดสินค้า'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  alignment: Alignment.topLeft,
                  child: const Text('ชื่อสินค้า',style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold)),
                  ),
              Container(
                  alignment: Alignment.topCenter,
                  child: const Image(
                    image: AssetImage('assets/images/barcode1.png'),
                    height: 150,
                    width: 200,
                  )),
              Container(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: const [Text('A565P412')],
                      ),
                    ],
                  ),
                  ),
            ]
            )
            );
  }
}
