import 'package:flutter/material.dart';
import 'package:inventoryapp/other/Components/swichaccount.dart';
import '../../widget/my_textfield.dart';

class AddAccount extends StatefulWidget {
  AddAccount({super.key});

  //signin
  void signUserIn() {}

  @override
  State<AddAccount> createState() => _AddAccountState();
}

TextEditingController LoginaddController = TextEditingController();
TextEditingController passwordaddController = TextEditingController();

class _AddAccountState extends State<AddAccount> {
  int change_number = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'เพิ่มบัญชีเข้าใช้งานเจ้าของ',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          change_number = 1;
                        });
                      },
                      child: const Text('เจ้าของ'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          minimumSize: const Size(55, 45),
                          textStyle: const TextStyle(fontSize: 13),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2)))),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          change_number = 2;
                        });
                      },
                      child: const Text('ผู้ช่วยผู้ดูแล'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          minimumSize: const Size(55, 45),
                          textStyle: const TextStyle(fontSize: 13),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2)))),
                ],
              ),
              const SizedBox(height: 30),
              change_number == 2
                  ? MyTextField(
                      controller: LoginaddController,
                      hintText: ('รหัสร้านค้า'),
                      obscureText: false)
                  : SizedBox.shrink(),
              const SizedBox(height: 10),
              MyTextField(
                  controller: LoginaddController,
                  hintText: ('อีเมล'),
                  obscureText: false),
              const SizedBox(height: 10),
              MyTextField(
                  controller: passwordaddController,
                  hintText: ('รหัสผ่าน'),
                  obscureText: true),

              const SizedBox(height: 20),
//button

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(13),
                    margin: EdgeInsets.symmetric(horizontal: 100),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SwitchAccount(),
                            ));
                      },
                      child: Text('เพิ่มบัญชีเข้าใช้งาน'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
