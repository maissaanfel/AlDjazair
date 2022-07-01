import 'package:aldjazair/restaurant/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:aldjazair/restaurant/decouvrir.dart';
//import 'package:aldjazair/restaurant/resthome.dart';s
//import 'store.dart';

class FavoriteRestCard extends StatelessWidget {
  final Restaurant restaurant;
  FavoriteRestCard(this.restaurant);

  set inFavorite(bool f) => {inFavorite = f};

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Container(
            padding: EdgeInsets.only(top: 20),
            child: Card(
              color: Colors.blueGrey[100],
              child: Column(
                children: [
                  ListTile(
                    title: Text(this.restaurant.name),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            this.restaurant.url,
                            width: 300,
                            height: 170,
                            fit: BoxFit.cover,
                          ))),
                  Padding(
                      padding: EdgeInsets.only(top: 10, left: 15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(this.restaurant.stitr),
                            TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.blueGrey[300])),
                                onPressed: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Decouvrir(restaurant),
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
