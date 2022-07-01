import 'package:aldjazair/magasin/magasin.dart';
import 'package:flutter/material.dart';
import 'package:aldjazair/magasin/decouvrir.dart';
//import 'package:aldjazair/restaurant/resthome.dart';s
//import 'store.dart';

class FavoriteMagCard extends StatelessWidget {
  final Magasin magasin;
  FavoriteMagCard(this.magasin);

  set inFavorite(bool f) => {inFavorite = f};

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Container(
            //color: Colors.red,
            padding: EdgeInsets.only(top: 20),
            child: Card(
              color: Colors.grey[300],
              child: Column(
                children: [
                  ListTile(
                    title: Text(this.magasin.name),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            this.magasin.url,
                            width: 300,
                            height: 170,
                            fit: BoxFit.cover,
                          ))),
                  Padding(
                      padding: EdgeInsets.only(top: 10, left: 15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(this.magasin.desc),
                            TextButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.grey)),
                                onPressed: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Decouvrir(magasin),
                                          ))
                                    },
                                child: Text('DECOUVRIR',
                                    style: TextStyle(color: Colors.black))),
                          ]))
                ],
              ),
            )));
  }
}
