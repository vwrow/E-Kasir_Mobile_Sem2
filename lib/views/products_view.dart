import 'package:flutter/material.dart';
import 'package:postman_penugasan1/widgets/navBar.dart';

class ItemsView extends StatefulWidget {
  const ItemsView({super.key});

  @override
  State<ItemsView> createState() => _ItemsViewState();
}

class _ItemsViewState extends State<ItemsView> {
  @override
  Widget build(BuildContext context) {
    final themeColor = const Color.fromARGB(255, 230, 114, 41);
    final washedTheme = const Color.fromARGB(255, 222, 208, 203);
    return Scaffold(
      backgroundColor: themeColor,
      bottomNavigationBar: BottomNav(1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Products",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Popins",
                        ),
                      ),
                      IconButton(
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.add,
                            size: 20,
                            color: Color.fromARGB(230, 0, 0, 0),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 26),
            Container(
              height: 605,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 200,
                        height: 335,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: BorderDirectional(
                            bottom: BorderSide(
                              color: washedTheme,
                              width: 2.0,
                              style: BorderStyle.solid,
                            ),
                            start: BorderSide(
                              color: washedTheme,
                              width: 2.0,
                              style: BorderStyle.solid,
                            ),
                            end: BorderSide(
                              color: washedTheme,
                              width: 2.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Icon(Icons.image, color: Colors.black),
                            ),
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                horizontal: 15,
                                vertical: 15,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "Nama Product",
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Popins",
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Deskripsi singkat panjang banget",
                                    style: const TextStyle(
                                      color: Color.fromARGB(175, 0, 0, 0),
                                      fontSize: 12,
                                      fontFamily: "Popins",
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    "Rp. 100.000,00",
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Popins",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 200,
                        height: 335,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: BorderDirectional(
                            bottom: BorderSide(
                              color: washedTheme,
                              width: 2.0,
                              style: BorderStyle.solid,
                            ),
                            start: BorderSide(
                              color: washedTheme,
                              width: 2.0,
                              style: BorderStyle.solid,
                            ),
                            end: BorderSide(
                              color: washedTheme,
                              width: 2.0,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Icon(Icons.image, color: Colors.black),
                            ),
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                horizontal: 15,
                                vertical: 15,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "Nama Product",
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Popins",
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Deskripsi singkat panjang banget",
                                    style: const TextStyle(
                                      color: Color.fromARGB(175, 0, 0, 0),
                                      fontSize: 12,
                                      fontFamily: "Popins",
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Text(
                                    "Rp. 100.000,00",
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Popins",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
