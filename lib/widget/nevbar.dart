import 'package:flutter/material.dart';
import 'package:inventoryapp/Other/other.dart';
import 'package:inventoryapp/account/auditday.dart';
import 'package:inventoryapp/provider/provider.dart';
import 'package:inventoryapp/sell/Components/export.dart';
import 'package:provider/provider.dart';
import '../imported/imported.dart';
import '../sell/sell.dart';
// class BottomNavbar extends StatelessWidget {
// int _currentIndex = 0; //Current selected index of the bottom navigation bar tab

// void changeTab(int index) {
//   setState(() => _currentIndex = index);
// }
//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: _currentIndex,
//         onTap: (index) => changeTab(index),
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: const Color(0xFFFFA500),
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.add_circle_outline),
//             label: 'สินค้าเข้า',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.sell_outlined),
//             label: 'สินค้าออก',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.list_alt),
//             label: 'รายการซื้อขาย',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.more_horiz),
//             label: 'อื่นๆ',
//           ),
//         ],
//         selectedItemColor: Colors.white,
//         selectedLabelStyle: const TextStyle(fontSize: 13),
//         onTap: (int index) {
//           switch (index) {
//             case 0:
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(builder: (context) => const Myapp()),
//               // );
//               break;
//             case 1:
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const Imported()),
//               );
//               break;
//           }
//         },
//       );
//   }
// }

class BottomNavbar extends StatefulWidget {
  final int number;
  final String role;
  // const BottomNavbar({super.key this.number});
  const BottomNavbar({Key? key, required this.number, required this.role})
      : super(key: key);
  @override
  State<BottomNavbar> createState() => _navbarState();
}

class _navbarState extends State<BottomNavbar> {
  @override
  Widget build(BuildContext context) {
   final tracking = Provider.of<IndexNavbar>(context, listen: false);
   final indexNav = context.read<IndexNavbar>().index;
    void _onItemTapped(int index) {
      tracking.addIndex(index);
      if (widget.role == "ซื้อสินค้าเข้า") {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Imported()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Other()),
            );
            break;
        }
      }

      if (widget.role == "ขายสินค้าออก") {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Sell()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Other()),
            );
            break;
        }
      }

      if (widget.role == "เจ้าของร้าน") {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Imported()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Sell()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Auditday()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Other()),
            );
            break;
        }
      }
    }

    return Visibility(
        visible: widget.role == 'เจ้าของร้าน' ||
            widget.role == 'ซื้อสินค้าเข้า' ||
            widget.role == 'ขายสินค้าออก' ||
            widget.role == "บัญชี",
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Color.fromARGB(255, 255, 98, 0),
            items: <BottomNavigationBarItem>[
              if (widget.role == "ซื้อสินค้าเข้า" || widget.role == 'เจ้าของร้าน')
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_circle_outline),
                  label: 'สินค้าเข้า',
                ),
              if (widget.role == "ขายสินค้าออก" || widget.role == 'เจ้าของร้าน')
                BottomNavigationBarItem(
                  icon: Icon(Icons.sell_outlined),
                  label: 'สินค้าออก',
                ),
              if (widget.role == "บัญชี" || widget.role == 'เจ้าของร้าน')
                BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt),
                  label: 'รายการซื้อขาย',
                ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz),
                label: 'อื่นๆ',
              ),
            ],
            currentIndex: indexNav ?? 0,
            selectedItemColor: Colors.white,
            selectedLabelStyle: const TextStyle(fontSize: 13),
            onTap: _onItemTapped));
  }
}
