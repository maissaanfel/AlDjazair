import 'package:flutter/material.dart';
import 'package:aldjazair/restaurant/restaurant.dart';
import 'package:aldjazair/restaurant/favoriterestcard.dart';
import 'package:aldjazair/restaurant/databasee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'databasee.dart';

class Favorite extends StatefulWidget {
  final List<Restaurant> favRestaurant;

  const Favorite({Key key, this.favRestaurant}) : super(key: key);
  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<Restaurant> favorites = [];
  List<Restaurant> restaurents = [];
  int index;

  Future<String> getresto() async {
    // ignore: unused_local_variable
    QuerySnapshot query = await DatabaseRService().getRestaurant();
    restaurents = DatabaseRService().convert(query);
    return 'ok';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Container(
            child: (widget.favRestaurant.length) != 0
                ? Scaffold(
                    body: Container(
                        child: ListView.builder(
                      itemCount: widget.favRestaurant.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          child: FavoriteRestCard(
                            widget.favRestaurant[index],
                          ),
                          width: 150,
                          height: 382,
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
