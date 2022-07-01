import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:aldjazair/restaurant/restaurant.dart';
import 'package:aldjazair/restaurant/commentaire.dart';
import 'package:aldjazair/restaurant/note.dart';
//import 'package:aldjazair/restaurant/page.dart';
//import 'package:aldjazair/restaurant/comment.dart';
//import 'package:aldjazair/restaurant/test_comment.dart';
//import 'package:aldjazair/restaurant/databasee.dart';

class Decouvrir extends StatelessWidget {
  final Restaurant restaurant;
  Decouvrir(this.restaurant);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[100],
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[300],
          leading: BackButton(color: Colors.black),
          actions: [
            Align(
              alignment: Alignment.centerRight,
              child: IconTheme(
                data: IconThemeData(
                  color: Colors.amber,
                  size: 25,
                ),
                child: Note(value: this.restaurant.note),
              ),
            ),
          ],
          title: Text(
            this.restaurant.name,
            style: TextStyle(
              color: Colors.black,
              //fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          margin: new EdgeInsets.only(top: 20.0),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /*SizedBox(
                  height: 72,
                  child: ListTile(
                    title: Text(
                      this.restaurant.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),*/
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  this.restaurant.url,
                  width: 370,
                  height: 194,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              SizedBox(
                height: 300,
                child: ListTile(
                  title:
                      Text(this.restaurant.desc, textAlign: TextAlign.center),
                ),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Commentaires(restaurant),
                        //Commentaires(restaurant)
                      ))
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blueGrey[300])),
                child: Text(
                  'Commentez',
                  style: TextStyle(color: Colors.black),
                ),
              )
              //bottomNavigationBar
            ],
          )),
        ));
  }
}
