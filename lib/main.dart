import 'package:aldjazair/services/auth.dart';
import 'package:aldjazair/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
        value: AuthService().user,
        initialData: null,
        child: MaterialApp(
            theme: ThemeData(backgroundColor: Colors.grey),
            debugShowCheckedModeBanner: false,
            home: Wrapper()));
  }
}
