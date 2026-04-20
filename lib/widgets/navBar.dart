import 'package:flutter/material.dart';
import 'package:postman_penugasan1/models/user_login.dart';

class BottomNav extends StatefulWidget {
  final int activePage;
  const BottomNav(this.activePage, {super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  UserLogin userLogin = UserLogin();
  String? role;
  getDataLogin() async {
    var user = await userLogin.getUserLogin();
    if (!mounted) return;
    if (user.status != false) {
      setState(() {
        role = user.role;
      });
    } else {
      Navigator.popAndPushNamed(context, '/login');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataLogin();
  }

  void getLink(index) {
    if (role == "admin") {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/dash');
      } else if (index == 1) {
        Navigator.pushReplacementNamed(context, '/items');
      }
    } else if (role == "user") {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, '/dash');
      } else if (index == 1) {
        Navigator.pushReplacementNamed(context, '/trans');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color.fromARGB(255, 230, 114, 41);
    final unselected = const Color.fromARGB(255, 222, 208, 203);
    return role == "admin"
        ? BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: themeColor,
            unselectedItemColor: unselected,
            currentIndex: widget.activePage,
            onTap: (index) => {getLink(index)},
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.file_copy),
                label: 'Produk',
              ),
            ],
          )
        : role == "user"
        ? BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: themeColor,
            unselectedItemColor: unselected,
            currentIndex: widget.activePage,
            onTap: (index) => {getLink(index)},
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_rounded),
                label: 'Pesanan',
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
