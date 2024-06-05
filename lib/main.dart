import 'package:flutter/material.dart';
import 'package:snake_app/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBngv2QqQ3ncZBFoNR028IHG91Cc6AzXC8",
          authDomain: "snake-1d656.firebaseapp.com",
          projectId: "snake-1d656",
          storageBucket: "snake-1d656.appspot.com",
          messagingSenderId: "1027823195464",
          appId: "1:1027823195464:web:57ba42830b022b5d214f7d",
          measurementId: "G-GJJ68ZPQ68"));
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
