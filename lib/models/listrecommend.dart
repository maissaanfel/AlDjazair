import 'package:aldjazair/models/monument.dart';
import 'package:aldjazair/services/database.dart';
import 'package:flutter/material.dart';
import 'package:aldjazair/home.dart';

class ListRecomend extends StatefulWidget {
  @override
  State<ListRecomend> createState() => ListRecomendState();
}

class ListRecomendState extends State<ListRecomend> {
  List<Monument> l = [];

  Future<List<Monument>> constructrecommend() async {
    l = await DatabaseService().getVisitedAndFav();
    return l;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: constructrecommend(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            l = snapshot.data;
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
                                        "1.jpg"),
                                    width: 70,
                                    height: 70,
                                  ),
                                )),
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
                                                l.length > 3
                                                    ? Row(children: [
                                                        Text(l
                                                            .elementAt(index)
                                                            .note
                                                            .toString()),
                                                        Icon(Icons.star,
                                                            color:
                                                                Colors.yellow)
                                                      ])
                                                    : Text(
                                                        l
                                                            .elementAt(index)
                                                            .note
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: l
                                                                        .elementAt(
                                                                            index)
                                                                        .note >
                                                                    80
                                                                ? Colors
                                                                    .green[900]
                                                                : l.elementAt(index).note >
                                                                        60
                                                                    ? Colors.green[
                                                                        700]
                                                                    : l.elementAt(index).note >
                                                                            50
                                                                        ? Colors
                                                                            .green
                                                                        : l.elementAt(index).note >
                                                                                40
                                                                            ? Colors.green.shade400
                                                                            : l.elementAt(index).note > 20
                                                                                ? Colors.green.shade300
                                                                                : l.elementAt(index).note > 10
                                                                                    ? Colors.orange.shade300
                                                                                    : l.elementAt(index).note > 0
                                                                                        ? Colors.orange
                                                                                        : Colors.red.shade900))
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
                  child: Text(
                      "Au vue de votre profil aucune recommendation n'a pu votre fait"));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
