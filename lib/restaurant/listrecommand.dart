import 'package:aldjazair/restaurant/restaurant.dart';
import 'package:aldjazair/restaurant/databasee.dart';
import 'package:aldjazair/restaurant/favoriterestcard.dart';
import 'package:flutter/material.dart';

class ListRecomendR extends StatefulWidget {
  @override
  State<ListRecomendR> createState() => ListRecomendState();
}

class ListRecomendState extends State<ListRecomendR> {
  List<Restaurant> restaurents = [];
  int index;

  /*Future<String> getresto() async {
    // ignore: unused_local_variable
    QuerySnapshot query = await DatabaseRService().getRestaurant();
    restaurents = DatabaseRService().convert(query);
    return 'ok';
  }*/

  Future<List<Restaurant>> recommend() async {
    restaurents = await DatabaseRService().getNoteFav();
    return restaurents;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: recommend(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            restaurents = snapshot.data;
            if (restaurents.isNotEmpty) {
              return ListView.builder(
                itemCount: restaurents.length,
                itemBuilder: (BuildContext context, int index) {
                  return FavoriteRestCard(restaurents[index]);
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
