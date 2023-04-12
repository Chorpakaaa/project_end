import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
class UserModel {
  final String email , storeId , transacId , role;
  UserModel({ required this.email, required this.storeId , required this.transacId , required this.role});
}
class UserProvider with ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;
   void setUser(UserModel userModel) {
    _user = userModel;
    notifyListeners();
  }
  void removeUser() {
    _user = null;
    notifyListeners();
  }
}

class ItemProvider with ChangeNotifier {
  List _items = [];

  List get items => _items;

  void addItem(List item) {
    _items = item;
    notifyListeners();
  }

  void clearItem(){
    _items = [];
    notifyListeners();
  }
}
class SellProvider with ChangeNotifier {
  List _items = [];

  List get items => _items;

  void addItem(List item) {
    _items = item;
    notifyListeners();
  }

  void clearItem(){
    _items = [];
    notifyListeners();
  }
}
class IndexNavbar with ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void addIndex(int item) {
    _index = item;
    notifyListeners();
  }

}