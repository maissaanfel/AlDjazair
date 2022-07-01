import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:aldjazair/magasin/magasin.dart';
import 'package:aldjazair/magasin/bd_mag.dart';
//import 'package:aldjazair/restaurant/comment.dart';
//import 'package:aldjazair/restaurant/test_comment.dart';
//import 'package:aldjazair/restaurant/databasee.dart';

class Commentaires extends StatelessWidget {
  final Magasin magasin;
  Commentaires(this.magasin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.grey,
          leading: BackButton(color: Colors.black),
          title: Text(
            'Commentaires',
            style: TextStyle(
              color: Colors.black,
              //fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
            margin: new EdgeInsets.only(top: 20.0),
            child: Center(
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Center(
                child: Container(
                    child:
                        Text("Pas de commentaire pour l'instant. Ajoutez un!")),
              ),
              SizedBox(height: 300),
              TextField(
                obscureText: false,
                decoration: InputDecoration(
                    labelText: 'ajoutez un commentaire',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Onpressedcomment(magasin),
                            ))
                      },
                    )),
              ),
            ]))));
  }
}
