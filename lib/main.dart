import 'package:flutter/material.dart';
import 'package:snake_app/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initiazeApp;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(brightness: Brightness.dark),
    );
  }
}
