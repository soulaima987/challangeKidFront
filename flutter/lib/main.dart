import 'package:flutter/material.dart';
import 'widgets/signIn.dart';
import 'widgets/testGET.dart';
import 'widgets/signUp.dart';
import 'widgets/home.dart';
import 'widgets/favorite.dart';
import 'dart:io';

void main() {
  //HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
