// import 'package:inventoryapp/imported/imported.dart';
//import 'package:inventoryapp/sell/sell.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inventoryapp/login/login.dart';
import 'package:inventoryapp/sell/sell.dart';
import './db/test.dart';
import './login/login.dart';
import 'firebase_options.dart';
import 'package:inventoryapp/provider/provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Myapp());
}
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//  await Firebase.initializeApp(
//   options: DefaultFirebaseOptions.currentPlatform,
// );
//   runApp(const Myapp());
// }

class Myapp extends StatelessWidget {
  const Myapp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => ItemProvider()),
          ChangeNotifierProvider(create: (_) => SellProvider()),
          ChangeNotifierProvider(create: (_) => IndexNavbar()),
          
        ],
        child: MaterialApp(
          title: 'Flutter',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
          ),
          debugShowCheckedModeBanner: false,
          home: LoginSreen(),
        ));
  }
}
