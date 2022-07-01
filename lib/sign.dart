//import 'package:aldjazair/services/auth.dart';

//import 'package:aldjazair/verify.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:aldjazair/homepage.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

import 'services/auth.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String nom = '';
  String prenom = '';
  String email = '';
  String password = '';
  String error = '';
  String secondpassword = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              //Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                  (Route<dynamic> route) => false);
            },
            icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
          ),
        ),
        body: Container(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Crée un compte",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Patrick'),
                ),
                //Spacer(),
                Text("Créez un compte pour profiter de l'application !",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontFamily: 'Patrick')),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child: Column(
                      children: [
                        
                        
                        TextFormField(
                            onChanged: (value) {
                              setState(() => nom = value);
                            },
                            decoration: InputDecoration(
                                labelText: "Nom",
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400])),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400])))),

                        SizedBox(height: 20),

                        TextFormField(
                            onChanged: (value) {
                              setState(() => prenom = value);
                            },
                            decoration: InputDecoration(
                                labelText: "Prenom",
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400])),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400])))),
                        SizedBox(height: 20),

                        TextFormField(
                            validator: (val) => EmailValidator.validate(val)
                                ? null
                                : 'Format email incorrect',
                            onChanged: (value) {
                              setState(() => email = value);
                            },
                            decoration: InputDecoration(
                                labelText: "Email",
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400])),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400])))),
                        SizedBox(height: 20),
                        TextFormField(
                            obscureText: true,
                            validator: (val) => val.length < 6
                                ? 'Mot de passe trop court !'
                                : null,
                            onChanged: (value) {
                              setState(() => password = value);
                            },
                            decoration: InputDecoration(
                                labelText: "Mot de passe",
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400])),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400])))),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                            obscureText: true,
                            validator: (value) => password != secondpassword
                                ? 'les mot de passe ne sont pas identique'
                                : null,
                            onChanged: (value) {
                              setState(() => secondpassword = value);
                            },
                            decoration: InputDecoration(
                                labelText: "Confirmez votre mot de passe",
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400])),
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400]))))
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 2),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: MaterialButton(
                          height: 60,
                          color: Colors.blue.shade100,
                          //minWidth: double.infinity,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              dynamic result =
                                  _auth.registerWithEmailAndPassword(
                                      email, password,nom,prenom);
                              if (result == null) {
                                await showDialog(
                                    context: context,
                                    builder: (_) => new AlertDialog(
                                            title: Text("Erreur"),
                                            content: Text(
                                                "Une erreur s'est produite veuillez réessayer plus tard"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Ok"))
                                            ]));
                              } else {
                                await showDialog(
                                    context: context,
                                    builder: (_) => new AlertDialog(
                                            title:
                                                Text("Email de Confirmation"),
                                            content: Text(
                                                "Un email de confirmation vous a été envoyez à votre adresse mail"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Ok"))
                                            ]));
                                await _auth.emailVerification();
                              }
                              //Navigator.pop(context);
                            }
                          },
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(50)),
                          child: Text("Créer un compte",
                              style: TextStyle(
                                  fontFamily: 'Patrick',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20)))),
                ),
              ],
            ),
          ),
        ));
  }
}
