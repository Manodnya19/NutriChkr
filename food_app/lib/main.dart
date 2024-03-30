import 'package:flutter/material.dart';
import './pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure the widget binding is initialized before calling Firebase.initializeApp()
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MaterialApp(home: LoginPage()));
  //runApp(MyApp());
}


