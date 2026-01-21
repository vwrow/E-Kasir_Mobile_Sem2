import 'package:flutter/material.dart';
import 'package:postman_penugasan1/views/dash_view.dart';
import 'package:postman_penugasan1/views/login_view.dart';
import 'package:postman_penugasan1/views/register_user_view.dart';
import 'package:postman_penugasan1/views/splash_view.dart';

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
      },
    ),
  );
}
