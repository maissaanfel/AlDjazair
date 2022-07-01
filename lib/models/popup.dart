import 'dart:async';
import 'dart:math';

import 'package:aldjazair/models/stardisplay.dart';
import 'package:aldjazair/services/database.dart';
import 'package:aldjazair/services/networking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import "package:latlong/latlong.dart";
import 'package:aldjazair/models/page.dart';

import 'package:location/location.dart';

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}

class ExamplePopup extends StatefulWidget {
  final Function onFlatButtonPressed;
  final Marker marker;
  final LatLng latlog;
  ExamplePopup(this.marker, this.latlog, this.onFlatButtonPressed);

  @override
  State<StatefulWidget> createState() => _ExamplePopupState();
}

class _ExamplePopupState extends State<ExamplePopup> {
  String titre;
  String description;
  String soustitre;
  String shortdescription;
  String lien;

  AsyncSnapshot<QuerySnapshot<Object>> snapshotpopup;

  Future<QuerySnapshot> test() async {
    Future<QuerySnapshot> querySnapshot =
        DatabaseService().getMonument(widget.latlog);
    return querySnapshot;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: test(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            snapshotpopup = snapshot;
            titre = snapshot.data.docs[0]['titre'];
            List<String> imgList = [
              "assets/Images/" + titre + "1.jpg",
              "assets/Images/" + titre + "2.jpg",
              "assets/Images/" + titre + "3.jpg",
            ];
            return Container(
              color: Colors.white,
              child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                        "assets/Images/" +
                            snapshot.data.docs[0]['titre'] +
                            "1.jpg",
                        height: 60,
                        width: 100,
                      ),
                    ),
                    Container(
                      //color: Colors.white,
                      child: _cardDescription(
                          context,
                          snapshot.data.docs[0]['titre'],
                          snapshot.data.docs[0]['shortdescrption'],
                          snapshot.data.docs[0]['note'],
                          imgList),
                    ),
                  ])),
            );
          } else
            return CircularProgressIndicator();
        });
  }

  Route _createRoute(List<String> imgList) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          CustomPage(snapshotpopup, imgList),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Widget _cardDescription(BuildContext context, dynamic titre,
      dynamic shortdescription, dynamic note, List<String> imgList) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              alignment: Alignment.bottomRight,
              child: IconTheme(
                data: IconThemeData(
                  color: Colors.amber,
                  size: 15,
                ),
                child: StarDisplay(value: note),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 3)),
            Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Text(
                //titre
                titre,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 5)),
            Text(
              shortdescription,
              style: TextStyle(fontSize: 10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(_createRoute(imgList));
                  },
                  child: Text("En savoir plus", style: TextStyle(fontSize: 10)),
                  shape: RoundedRectangleBorder(),
                ),
                MaterialButton(
                  onPressed: () async {
                    try {
                      var location = new Location();
                      LocationData userlocation = await location.getLocation();
                      NetworkHelper network = NetworkHelper(
                          startLat: userlocation.latitude,
                          startLng: userlocation.longitude,
                          endLat: widget.latlog.latitude,
                          endLng: widget.latlog.longitude);

                      double distance = calculateDistance(
                          userlocation.latitude,
                          userlocation.longitude,
                          widget.latlog.latitude,
                          widget.latlog.longitude);
                      print("distance:" + distance.toString());
                      // getData() returns a json Decoded data
                      var data = await network.getData();
                      LineString ls = LineString(
                          data['features'][0]['geometry']['coordinates']);
                      List<LatLng> polyPoints = [];

                      for (int i = 0; i < ls.lineString.length; i++) {
                        polyPoints.add(
                            LatLng(ls.lineString[i][1], ls.lineString[i][0]));
                      }
                      widget.onFlatButtonPressed(
                          polyPoints, titre, distance, 10);
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text("S'y rendre", style: TextStyle(fontSize: 10)),
                  shape: RoundedRectangleBorder(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
