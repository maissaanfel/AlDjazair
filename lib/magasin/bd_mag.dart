import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:aldjazair/magasin/decouvrir.dart';
import 'package:aldjazair/magasin/magasin.dart';
//import 'package:aldjazair/restaurant/restaurant.dart';
//import 'package:aldjazair/restaurant/comment.dart';
//import 'package:aldjazair/restaurant/test_comment.dart';
//import 'package:aldjazair/restaurant/databasee.dart';

class Onpressedcomment extends StatelessWidget {
  final Magasin magasin;
  Onpressedcomment(this.magasin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.grey,
          leading: BackButton(
              color: Colors.black,
              onPressed: () => {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Decouvrir(this.magasin)),
                    )
                  }),
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
                    margin: EdgeInsets.only(top: 12),
                    child: Card(
                        color: Colors.grey,
                        child: Column(children: [
                          SizedBox(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                      'https://st2.depositphotos.com/1104517/11967/v/950/depositphotos_119675554-stock-illustration-male-avatar-profile-picture-vector.jpg'),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Benabed Anfel :',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 6),
                                    Text('memoire'),
                                  ],
                                )
                              ],
                            ),
                          )
                        ]))),
              ),
              SizedBox(height: 250),
              TextField(
                obscureText: false,
                decoration: InputDecoration(
                    labelText: 'ajoutez un commentaire',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () => {},
                    )),
              ),
            ]))));
  }
}
