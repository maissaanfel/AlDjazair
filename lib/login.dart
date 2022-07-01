import 'package:aldjazair/home.dart';
import 'package:aldjazair/homepage.dart';
import 'package:aldjazair/services/auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

//import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //final _formKey = GlobalKey<FormState>();

  final AuthService _auth = AuthService();

  String email = '';

  String password = '';

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
            height: MediaQuery.of(context).size.height,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: <
                    Widget>[
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Text(
                  "Se connecter",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Patrick'),
                ),
                SizedBox(height: 10),
                Text("Connectez vous à votre compte",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                        fontFamily: 'Patrick')),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    child: Form(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //email
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
                                        borderSide: BorderSide(
                                            color: Colors.grey[400])),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey[400])))),
                            SizedBox(height: 10),
                            //password
                            TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    labelText: 'Mot de passe',
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey[400])),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey[400]))))
                          ]),
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
                          minWidth: double.infinity,
                          onPressed: () async {
                            // if (_formKey.currentState.validate()) {
                            dynamic result =
                                await _auth.signIn(email, password);
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
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                                (Route<dynamic> route) => false,
                              );
                            }
                          }
                          //},
                          ,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(50)),
                          child: Text("Se connecter",
                              style: TextStyle(
                                  fontFamily: 'Patrick',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20)))),
                ),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Vous n'avez pas de compte ?"),
                SizedBox(width: 3),
                Text("Créez en un !",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
              ]),
              Expanded(child: ClipRect(child: Image.asset("assets/test.png")))
            ])));
  }
}

/*Widget makeInput(label, obscureText) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      SizedBox(height: 5),
      TextField(
          onChanged: (txt) => {},
          obscureText: obscureText,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400])),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]))))
    ],
  );
}*/
