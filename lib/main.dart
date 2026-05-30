import 'package:flutter/material.dart';
//import 'search_page.dart';
import '/pages/Register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: RegisterPage(key: null,),
      ),
    );
  }
}
