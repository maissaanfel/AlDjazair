import 'package:aldjazair/magasin/magasin.dart';
import 'package:flutter/material.dart';
import 'package:aldjazair/magasin/decouvrir.dart';
import 'package:aldjazair/magasin/icon.dart';

// ignore: must_be_immutable
class MagasinCard extends StatelessWidget {
  final Magasin magasin;
  final Function onPressed;
  final List<Magasin> favorite;
  bool isFavorite = false;

  MagasinCard(this.magasin, this.onPressed, this.favorite);

  void addOrRemove(bool isFavorite) {
    isFavorite ? favorite.add(magasin) : favorite.remove(magasin);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 15),
        width: 344,
        height: 382,
        child: Card(
          color: Colors.grey[300],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  height: 72,
                  child: ListTile(
                    title: Text(
                      this.magasin.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        this.magasin.url,
                        width: 370,
                        height: 194,
                        fit: BoxFit.cover,
                      ))),
              SizedBox(
                height: 108,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 30, left: 10)),
                    Row(
                      children: [
                        SizedBox(width: 8),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.grey)),
                                  onPressed: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Decouvrir(magasin),
                                            ))
                                      },
                                  child: Text('En savoir plus',
                                      style: TextStyle(color: Colors.black))),
                              SizedBox(width: 220),
                              FavoriteIcon(
                                fun: addOrRemove,
                              ),
                              /*IconButton(
                                  icon: Icon(Icons.favorite_border),
                                  onPressed: () => {}),*/
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
