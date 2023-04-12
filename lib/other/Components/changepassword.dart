import 'package:flutter/material.dart'; 
import '../../widget/my_textfield.dart';

class ChangPassword extends StatefulWidget {
  const ChangPassword({super.key});

  @override
  State<ChangPassword> createState() => _ChangPasswordState();
}


TextEditingController changpassController = TextEditingController();
TextEditingController changpassmaiController = TextEditingController();
TextEditingController changpassmaiiController = TextEditingController();


class _ChangPasswordState extends State<ChangPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         centerTitle: true,
         title: const Text('เปลี่ยนรหัสผ่าน',style: TextStyle(fontSize: 16),),
        backgroundColor: Colors.deepOrange,
    ),

      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              
              const SizedBox(height: 50),

              //username textfied

              MyTextField(
                  controller: changpassController,
                  hintText: ('รหัสผ่านเดิม'),
                  obscureText: true),

              const SizedBox(height: 15),

              //password

              MyTextField(
                  controller: changpassmaiController,
                  hintText: ('รหัสผ่านใหม่'),
                  obscureText: true),

              const SizedBox(height: 15),

              MyTextField(
                  controller: changpassmaiiController,
                  hintText: ('ยืนยันรหัสผ่าน'),
                  obscureText: true),

const SizedBox(height: 10),
              //buntton
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
                        Navigator.pop(context,);
                      },
                      child: Text('เปลี่ยนรหัสผ่าน'),
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
