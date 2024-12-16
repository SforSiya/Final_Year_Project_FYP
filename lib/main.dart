import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Authentication/Login_Screen.dart';
import 'firebase_options.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MathMind',

      //darkTheme: darkMode,
      debugShowCheckedModeBanner: false, // Disable the debug banner
      home: LoginPage(),
    );
  }
}