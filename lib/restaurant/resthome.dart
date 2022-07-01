import 'package:aldjazair/restaurant/restaurant.dart';
import 'package:aldjazair/restaurant/restaurant_card.dart';
//import 'package:aldjazair/restaurant/favoriterestcard.dart';
import 'package:aldjazair/restaurant/favoris.dart';
import 'package:aldjazair/restaurant/search.dart';
import 'package:aldjazair/restaurant/listrecommand.dart';
//import 'package:aldjazair/models/listrecommend.dart';
//import 'package:aldjazair/restaurant/try.dart';
import 'package:aldjazair/restaurant/databasee.dart';
//import 'package:aldjazair/restaurant/icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'databasee.dart';

class Resthome extends StatefulWidget {
  @override
  _ResthomeState createState() => _ResthomeState();
}

class _ResthomeState extends State<Resthome> {
  List<Restaurant> restaurents = [];
  List<Restaurant> favorite = [];
  Future<String> getresto() async {
    // ignore: unused_local_variable
    QuerySnapshot query = await DatabaseRService().getRestaurant();
    restaurents = DatabaseRService().convert(query);
    return 'ok';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getresto(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blueGrey[300],
                iconTheme: IconThemeData(color: Colors.black),
                title: Text(
                  'LES RESTAURANTS:',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () => {
                            showSearch(
                                context: context,
                                delegate: RestSearchDelegate(restaurents))
                          })
                ],
              ),
              drawer: SizedBox(
                width: MediaQuery.of(context).size.width * 0.80,
                child: Drawer(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          color: Colors.blueGrey[300],
                          child: TabBar(
                            tabs: [
                              Tab(
                                text: "Favoris",
                                icon: Icon(Icons.favorite),
                              ),
                              Tab(
                                text: "Recommandation",
                                icon: Icon(Icons.restaurant_menu_sharp),
                              ),
                              /*Tab(
                                text: "Recommandation Monument",
                                icon: Icon(Icons.map),
                              ),*/
                              //Tab(text: "options", icon: Icon(Icons.settings)),
                            ],
                          ),
                        ),
                        Expanded(
                            child: TabBarView(children: [
                          Container(
                              child: Favorite(
                            favRestaurant: favorite,
                          )),
                          Container(child: ListRecomendR()),
                          //Container(child: ListRecomend()),
                          /*Container(
                            child: Parametre(),
                          )*/
                        ]))
                      ],
                    ),
                  ),
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: restaurents.length,
                      itemBuilder: (BuildContext context, int index) {
                        return RestaurantCard(
                            restaurents[index], favorite, () => {});
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
