import 'package:aldjazair/magasin/magasin.dart';
//import 'package:aldjazair/restaurant/resthome.dart';
import 'package:flutter/material.dart';
import 'package:aldjazair/services/auth.dart';

class Parametre extends StatefulWidget {
  @override
  State<Parametre> createState() => ParametreState();
}

class ParametreState extends State<Parametre> {
  List<Magasin> r = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () => AuthService().signOut(),
                child: Text("log out", style: TextStyle(color: Colors.black)))
          ],
        ),
      ),
    );
  }
}
