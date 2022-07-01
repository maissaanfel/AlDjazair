import 'package:aldjazair/models/monument.dart';
import 'package:aldjazair/services/database.dart';
import 'package:flutter/material.dart';
import 'package:aldjazair/home.dart';

class ListFav extends StatefulWidget {
  @override
  State<ListFav> createState() => ListFavState();
}

class ListFavState extends State<ListFav> {
  List<Monument> l = [];

  Future<String> constructrefav() async {
    l = await DatabaseService().convertFav();
    return 'ok';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: constructrefav(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (l.isNotEmpty) {
              return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        width: MediaQuery.of(context).size.width * 0.80,
                        child: Card(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Image(
                                    image: AssetImage('assets/Images/' +
                                        l.elementAt(index).titre +
                                        "1.jpg")),
                                width: 70,
                                height: 70,
                              ),
                            ),
                            Container(
                              constraints:
                                  BoxConstraints(minWidth: 100, maxWidth: 300),
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                      width: 220,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          //mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(l.elementAt(index).titre),
                                                IconButton(
                                                    icon: Icon(Icons.close),
                                                    onPressed: () async {
                                                      await DatabaseService()
                                                          .deleteFav(
                                                              l
                                                                  .elementAt(
                                                                      index)
                                                                  .latitude,
                                                              l
                                                                  .elementAt(
                                                                      index)
                                                                  .longitude);
                                                      setState(() {
                                                        //l.removeAt(index);
                                                      });
                                                    })
                                              ],
                                            ),
                                            const Padding(
                                                padding: EdgeInsets.all(5.0)),
                                            Text(l
                                                .elementAt(index)
                                                .shortdescription),
                                            Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: MaterialButton(
                                                    onPressed: () {
                                                      globalKey.currentState
                                                          .essai(
                                                              l
                                                                  .elementAt(
                                                                      index)
                                                                  .latitude,
                                                              l
                                                                  .elementAt(
                                                                      index)
                                                                  .longitude);
                                                    },
                                                    child: Text(
                                                        "Afficher sur la carte"))),
                                          ]))),
                            ),
                          ],
                        )));
                  },
                  itemCount: l.length);
            } else {
              return Center(
                  child: Text("Vous n'avez pas de favoris pour le moment!"));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
