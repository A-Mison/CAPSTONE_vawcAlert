import 'package:flutter/material.dart';
import 'package:vawc_alert_proj/login_page.dart';
import 'package:vawc_alert_proj/sign_up.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,

    );
  }

}
