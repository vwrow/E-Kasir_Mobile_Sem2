import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:postman_penugasan1/views/products_view.dart';
import 'package:postman_penugasan1/views/dash_view.dart';
import 'package:postman_penugasan1/views/login_view.dart';
import 'package:postman_penugasan1/views/messages_view.dart';
import 'package:postman_penugasan1/views/register_user_view.dart';
import 'package:postman_penugasan1/views/splash_view.dart';
import 'package:postman_penugasan1/views/transaksi_view.dart';
import 'package:postman_penugasan1/views/historty_view.dart';
import 'package:postman_penugasan1/views/test.dart';
import 'package:postman_penugasan1/provider/provider_Cart.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
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
          '/history': (context) => HistoryView(),
          '/test': (context) => PesanView(),
        },
      ),
    ),
  );
}
