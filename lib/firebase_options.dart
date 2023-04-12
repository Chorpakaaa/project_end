// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAU6sL5fTpadP-TwpaCRFEWuCC8R3qQXPE',
    appId: '1:352274340622:web:26cb86cfaca8a9df9d955f',
    messagingSenderId: '352274340622',
    projectId: 'project-inventory-7b10d',
    authDomain: 'project-inventory-7b10d.firebaseapp.com',
    storageBucket: 'project-inventory-7b10d.appspot.com',
    measurementId: 'G-BP6XD9ZKST',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD9sEqc_lc4OjbkOinMOFkIvinIm4RqgTc',
    appId: '1:352274340622:android:0439f2984c3cadbc9d955f',
    messagingSenderId: '352274340622',
    projectId: 'project-inventory-7b10d',
    storageBucket: 'project-inventory-7b10d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDlYywZ8pQDJfvNp18BNET_18eEbKc-vTs',
    appId: '1:352274340622:ios:e07826305e9998839d955f',
    messagingSenderId: '352274340622',
    projectId: 'project-inventory-7b10d',
    storageBucket: 'project-inventory-7b10d.appspot.com',
    iosClientId: '352274340622-cc4l3jlh0sbj7iqtr8l1m8ui80ssacaj.apps.googleusercontent.com',
    iosBundleId: 'com.example.inventoryapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDlYywZ8pQDJfvNp18BNET_18eEbKc-vTs',
    appId: '1:352274340622:ios:e07826305e9998839d955f',
    messagingSenderId: '352274340622',
    projectId: 'project-inventory-7b10d',
    storageBucket: 'project-inventory-7b10d.appspot.com',
    iosClientId: '352274340622-cc4l3jlh0sbj7iqtr8l1m8ui80ssacaj.apps.googleusercontent.com',
    iosBundleId: 'com.example.inventoryapp',
  );
}
