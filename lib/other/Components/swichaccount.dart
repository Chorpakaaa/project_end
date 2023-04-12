import 'package:flutter/material.dart';
import 'package:inventoryapp/other/Components/addaccount.dart';

class SwitchAccount extends StatefulWidget {
  const SwitchAccount({super.key});

  @override
  State<SwitchAccount> createState() => _SwitchAccount();
}

class _SwitchAccount extends State<SwitchAccount> {
  Widget registerButton() {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAccount(),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'สลับบัญชี',
          style: TextStyle(fontSize: 16),
        ),
        actions: <Widget>[registerButton()],
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {},
              child: Row(
                children: const [
                  Icon(Icons.people),
                  Text('shop 1',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
