import 'package:aldjazair/magasin/magasin.dart';
import 'package:aldjazair/magasin/magasincard.dart';
import 'package:aldjazair/magasin/favoris.dart';
import 'package:aldjazair/magasin/search.dart';
import 'package:aldjazair/magasin/database.dart';
import 'package:aldjazair/magasin/listrecommand.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MagasinHome extends StatefulWidget {
  @override
  _MagasinHomeState createState() => _MagasinHomeState();
}

class _MagasinHomeState extends State<MagasinHome> {
  List<Magasin> magasin = [];
  List<Magasin> favorite = [];
  Future<String> getresto() async {
    // ignore: unused_local_variable
    QuerySnapshot query = await DatabaseMService().getMagasin();
    magasin = DatabaseMService().convert(query);
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
                backgroundColor: Colors.grey,
                iconTheme: IconThemeData(color: Colors.black),
                title: Text(
                  'LES MAGASINS:',
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
                                delegate: RestSearchDelegate(magasin))
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
                          color: Colors.grey,
                          child: TabBar(
                            tabs: [
                              Tab(
                                text: "Favoris",
                                icon: Icon(Icons.favorite),
                              ),
                              Tab(
                                text: "Recommandation",
                                icon: Icon(Icons.shopping_bag),
                              ),
                              //Tab(text: "options", icon: Icon(Icons.settings)),
                            ],
                          ),
                        ),
                        Expanded(
                            child: TabBarView(children: [
                          Container(
                              child: Favorite(
                            favMagasin: favorite,
                          )),
                          Container(
                              child:
                                  ListRecomend() /*Text("recommandation.")*/),
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
                      itemCount: magasin.length,
                      itemBuilder: (BuildContext context, int index) {
                        return MagasinCard(magasin[index], () => {}, favorite);
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
