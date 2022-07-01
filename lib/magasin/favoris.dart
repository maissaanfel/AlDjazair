import 'package:aldjazair/magasin/magasin.dart';
import 'package:flutter/material.dart';
import 'package:aldjazair/magasin/favoritemagcard.dart';
import 'package:aldjazair/magasin/database.dart';
//import 'package:aldjazair/restaurant/icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Favorite extends StatefulWidget {
  final List<Magasin> favMagasin;

  const Favorite({Key key, this.favMagasin}) : super(key: key);
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<Magasin> favorites = [];
  //Restaurant restaurents;
  List<Magasin> restaurents = [];
  int index;

  Future<String> getMag() async {
    // ignore: unused_local_variable
    QuerySnapshot query = await DatabaseMService().getMagasin();
    restaurents = DatabaseMService().convert(query);
    return 'ok';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Container(
            child: (widget.favMagasin.length) != 0
                ? Scaffold(
                    body: Container(
                        child: ListView.builder(
                      itemCount: widget.favMagasin.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          child: FavoriteMagCard(
                            widget.favMagasin[index],
                          ),
                          width: 150,
                          height: 400,
                        );
                      },
                      padding: EdgeInsets.all(10),
                    )),
                  )
                : Scaffold(
                    body: Center(
                    child: Text("Vous n'avez pas encore de favoris !"),
                  ))));
  }
}
