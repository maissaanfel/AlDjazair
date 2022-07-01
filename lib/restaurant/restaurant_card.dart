import 'package:aldjazair/restaurant/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:aldjazair/restaurant/decouvrir.dart';
import 'package:aldjazair/restaurant/icon.dart';

// ignore: must_be_immutable
class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final List<Restaurant> favorite;
  final Function onPressed;
  bool isFavorite = false;

  RestaurantCard(this.restaurant, this.favorite, this.onPressed);

  void addOrRemove(bool isFavorite) {
    isFavorite ? favorite.add(restaurant) : favorite.remove(restaurant);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 12),
        width: 344,
        height: 382,
        child: Card(
          color: Colors.blueGrey[100],
          child: Column(
            children: [
              SizedBox(
                  height: 72,
                  child: ListTile(
                    title: Text(
                      this.restaurant.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        this.restaurant.url,
                        width: 370,
                        height: 194,
                        fit: BoxFit.cover,
                      ))),
              SizedBox(
                height: 108,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        child: Text(
                          this.restaurant.stitr,
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.only(top: 10, left: 10)),
                    Row(
                      children: [
                        SizedBox(width: 8),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                onPressed: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Decouvrir(restaurant),
                                      ))
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.blueGrey[300])),
                                child: Text(
                                  'En savoir plus',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(width: 220),
                              FavoriteIcon(
                                fun: addOrRemove,
                              ),
                            ])
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
