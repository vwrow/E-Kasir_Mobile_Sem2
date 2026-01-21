import 'package:flutter/material.dart';
import 'package:postman_penugasan1/models/user_login.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  UserLogin userLogin = UserLogin();
  String? nama;
  String? role;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  getUserLogin() async {
    var user = await userLogin.getUserLogin();
    if (user.status != false) {
      setState(() {
        nama = user.nama_user;
        role = user.role;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLogin();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color.fromARGB(255, 230, 114, 41);
    // final gradient = LinearGradient(
    //   begin: Alignment.topLeft,
    //   end: Alignment.bottomRight,
    //   colors: [
    //     const Color.fromARGB(255, 247, 138, 70), // Lighter orange
    //     themeColor, // Original orange
    //     const Color.fromARGB(255, 192, 76, 13), // Darker orange
    //   ],
    // );
    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(gradient: gradient),
        decoration: BoxDecoration(color: themeColor),
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(top: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selamat Pagi, $nama!",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Popins",
                          ),
                        ),
                        Text(
                          "Anda adalah $role",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Popins",
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 26),
                  Container(
                    height: 600,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 32,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(36, 16, 42, 88),
                          blurRadius: 24,
                          offset: Offset(0, 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              left: 16,
              right: 16,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 0,
                        ),
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(66, 0, 0, 0),
                              blurRadius: 24,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 7),
                              child: Icon(
                                Icons.search,
                                size: 20,
                                color: const Color.fromARGB(230, 0, 0, 0),
                              ),
                            ),
                            hintText: "Search...",
                            hintStyle: TextStyle(
                              color: Color.fromARGB(230, 0, 0, 0),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.shopping_cart_outlined,
                          size: 20,
                          color: Color.fromARGB(230, 0, 0, 0),
                        ),
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.logout_outlined,
                          size: 20,
                          color: Color.fromARGB(230, 0, 0, 0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
