//import 'package:aldjazair/models/user.dart';
import 'package:aldjazair/home.dart';
import 'package:aldjazair/homepage.dart';
//import 'package:aldjazair/verify.dart';

import 'package:firebase_auth/firebase_auth.dart';


import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'homepage.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user==null) {
      print("Pas d'user pour le moment");
      return MyHomePage();
    } 
    else {
      if(!user.emailVerified){
        print("l'email de l'user est pas vérifié");
        return MyHomePage();
      }
      else {
        print("L'email est verifié");
        return Home();
      }
    }
  }
}
