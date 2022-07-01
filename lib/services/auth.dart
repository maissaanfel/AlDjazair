//import 'package:aldjazair/models/user.dart';
import 'dart:async';

import 'package:aldjazair/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

//import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /*Userapp _userFromFirebaseUser(User user) {
    return user != null ? Userapp(uid: user.uid) : null;
  }*/


  Stream<User> get user {
    return _auth.authStateChanges();
  }
  
  /*Stream<Userapp> get user {
    return _auth
        .authStateChanges()
        .map((User user) => _userFromFirebaseUser(user));
  }*/
  
    
  Future signIn(String email,String password,) async {
      try {
          UserCredential result=await _auth.signInWithEmailAndPassword(email: email, password: password);
          if (result.user.emailVerified){
            //print("email verifié");
           
            return result.user;
          }
          else {
            //print("pas verifier");
            return null;

          }
      }
      catch (e){
        return null;
      }
  }
  
  Future registerWithEmailAndPassword(String email, String password,String nom,String prenom) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (result.user!=null){
        result.user.sendEmailVerification();
         DatabaseService().updataUserData(result.user.uid, email,nom,prenom);
      }
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  Future emailVerification() async {
    //_auth.currentUser.reload();
    _auth.currentUser.sendEmailVerification();
  }
  Future signOut() async {
    try {

       var logOut =await _auth.signOut();
       notifyListeners();
      return logOut;
    } catch (e) {
      print(e);
      return null;
    }
  }

  String uidUser() {
    return _auth.currentUser.uid;
  }
}
