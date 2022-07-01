import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:aldjazair/magasin/magasin.dart';
import 'package:aldjazair/magasin/note.dart';
import 'package:aldjazair/magasin/comment.dart';

class Decouvrir extends StatelessWidget {
  final Magasin magasin;
  Decouvrir(this.magasin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.grey,
          leading: BackButton(color: Colors.black),
          actions: [
            Align(
              alignment: Alignment.centerRight,
              child: IconTheme(
                data: IconThemeData(
                  color: Colors.amber,
                  size: 25,
                ),
                child: Note(value: this.magasin.note),
              ),
            ),
          ],
          title: Text(
            this.magasin.name,
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
                      this.magasin.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),*/
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  this.magasin.url,
                  width: 370,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              SizedBox(
                height: 300,
                child: ListTile(
                  title: Text(this.magasin.desc, textAlign: TextAlign.center),
                ),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Commentaires(magasin),
                        //Commentaires(restaurant)
                      ))
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.grey)),
                child: Text(
                  'Commentez',
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          )),
        ));
  }
}
