import 'package:aldjazair/login.dart';
import 'package:aldjazair/sign.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Bienvenue",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Patrick',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40)),
                            SizedBox(height: 20),
                            Text(
                                "El Djazair est l'application qui vous permetrra de découvrir la ville d'Alger !",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Patrick',
                                    color: Colors.grey[700],
                                    fontSize: 20)),
                            SizedBox(height: 40),
                            Container(
                                height: MediaQuery.of(context).size.height / 3,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/logo.png')))),
                            SizedBox(height: 40),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MaterialButton(
                                    height: 60,
                                    minWidth: double.infinity,
                                    onPressed: () {
                                      /* Navigator.push(
                                        context,
                                       MaterialPageRoute(
                                            builder: (context) => LoginPage()),
                                            
                                      );*/
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginPage()),
                                        (Route<dynamic> route) => false,
                                      );
                                    },
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.black),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Text("Se connecter",
                                        style: TextStyle(
                                            fontFamily: 'Patrick',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20))),
                                SizedBox(height: 20),
                                Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: MaterialButton(
                                        height: 60,
                                        color: Colors.blue.shade100,
                                        minWidth: double.infinity,
                                        onPressed: () {
                                          /* Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Test()));*/
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Test()),
                                            (Route<dynamic> route) => false,
                                          );
                                        },
                                        shape: RoundedRectangleBorder(
                                            side:
                                                BorderSide(color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Text("Créer un compte",
                                            style: TextStyle(
                                                fontFamily: 'Patrick',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20))))
                              ],
                            )
                          ])
                    ]))));
  }
}
