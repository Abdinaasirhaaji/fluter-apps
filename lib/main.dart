import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:xasuus_tus/screen/screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const XasuusQoreApp());
}

class XasuusQoreApp extends StatelessWidget {
  const XasuusQoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'XasuusQoreApp',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Color(0xffe9e9f3)),
      home: const HomeScreen(),
    );
  }
}
