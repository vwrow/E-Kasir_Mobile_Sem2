import 'package:flutter/material.dart';
import 'package:postman_penugasan1/views/products_view.dart';
import 'package:postman_penugasan1/views/dash_view.dart';
import 'package:postman_penugasan1/views/login_view.dart';
import 'package:postman_penugasan1/views/messages_view.dart';
import 'package:postman_penugasan1/views/register_user_view.dart';
import 'package:postman_penugasan1/views/splash_view.dart';
import 'package:postman_penugasan1/views/transaksi_view.dart';
import 'package:postman_penugasan1/views/test.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashView(),
        '/register': (context) => RegisterUserView(),
        '/login': (context) => LoginView(),
        '/dash': (comtext) => DashboardView(),
        '/message': (context) => MessageView(),
        '/items': (context) => ItemsView(),
        '/trans': (context) => TransactionView(),
        '/test': (context) => TestPage(),
      },
    ),
  );
}
