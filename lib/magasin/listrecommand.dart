import 'package:aldjazair/magasin/magasin.dart';
import 'package:aldjazair/magasin/database.dart';
import 'package:aldjazair/magasin/favoritemagcard.dart';
import 'package:flutter/material.dart';

class ListRecomend extends StatefulWidget {
  @override
  State<ListRecomend> createState() => ListRecomendState();
}

class ListRecomendState extends State<ListRecomend> {
  List<Magasin> magasin = [];
  int index;

  Future<List<Magasin>> recommend() async {
    magasin = await DatabaseMService().getNoteFav();
    return magasin;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: recommend(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            magasin = snapshot.data;
            if (magasin.isNotEmpty) {
              return ListView.builder(
                itemCount: magasin.length,
                itemBuilder: (BuildContext context, int index) {
                  return FavoriteMagCard(magasin[index]);
                },
              );
            } else {
              return Center(
                  child: Text(
                      "Au vue de votre profil aucune recommendation n'a pu votre fait"));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
