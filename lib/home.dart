import 'dart:async';
import 'dart:io';

import 'dart:math';

import 'package:aldjazair/models/listfav.dart';
import 'package:aldjazair/models/listrecommend.dart';
import 'package:aldjazair/models/monument.dart';
import 'package:aldjazair/restaurant/resthome.dart';
//import 'package:aldjazair/restaurant/para.dart';
import 'package:aldjazair/magasin/magasinhome.dart';
import 'package:aldjazair/services/auth.dart';
import 'package:aldjazair/services/database.dart';
import 'package:aldjazair/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aldjazair/models/customSearch.dart';

import 'package:flutter/material.dart';

import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:latlong/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:aldjazair/models/map.dart';

GlobalKey<MapPageState> globalKey = GlobalKey();
List<LatLng> currentcluster = [];
LatLng pendinglocation;

Timer timer;
int t = 0;
final picker = ImagePicker();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    listepoque = List<bool>.filled(4, true);
    _value = true;
    //initialisation();
    super.initState();
    // Faut mettre une minutes
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => cluster());
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // TEMPORAIRE JUSTE POUR LA PRESENTATION
  Future<void> cluster() async {
    int value = 0;
    print("CLUSTER EST APPELLE");
    t++;
    //print("value de t:"+t.toString());
    var location = new Location();
    LocationData userlocation = await location.getLocation();

    if (calculateDistance(userlocation.latitude, userlocation.longitude,
            currentcluster[0].latitude, currentcluster[0].longitude) <
        0.1) {
      currentcluster.add(LatLng(userlocation.latitude, userlocation.longitude));
      //print("ajout au cluster");
      pendinglocation = null;
    }
    if (t == 13) {
      print("t est arrivée à 2");
      bool trouv = false;
      int i = 0;
      // traitement voir si cluster pret d'un monument
      while (!trouv && i < monuments.length) {
        i++;
        if (calculateDistance(
                currentcluster[0].latitude,
                currentcluster[0].longitude,
                monuments[i].latitude,
                monuments[i].longitude) <
            0.5) {
          trouv = true;
          //print("Monuments visité trouvé");
          // On conclut que le monument a été visité
          DatabaseService()
              .visited(monuments[i].latitude, monuments[i].longitude);
          await showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                    title: Text("Vous avez visité " +
                        monuments[i].titre +
                        " recemment"),
                    content: Container(
                      height: 65,
                      child: Column(
                        children: [
                          Text("Voulez vous noter ce monument ?"),
                          RatingBar.builder(
                            initialRating: 0,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              value = rating.ceil();
                            },
                          )
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Non merci!")),
                      TextButton(
                          onPressed: () {
                            if (value != 0) {
                              DatabaseService().updateNote(
                                  monuments[i].latitude,
                                  monuments[i].longitude,
                                  value);
                              Navigator.of(context).pop();
                            } else {}
                          },
                          child: Text("c'est fait !")),
                    ],
                  ));
        }
      }
    }
  }

  /*Future<void> cluster() async {
    t++;

    var location = new Location();
    LocationData userlocation = await location.getLocation();

    if (calculateDistance(userlocation.latitude, userlocation.longitude,
            currentcluster[0].latitude, currentcluster[0].longitude) <
        0.1) {
      currentcluster.add(LatLng(userlocation.latitude, userlocation.longitude));
      pendinglocation = null;
    } else {
      if (pendinglocation != null) {
        if (t > 5) {
          bool trouv;
          int i = 0;
          // traitement voir si cluster pret d'un monument
          while (!trouv && i < monuments.length) {
            if (calculateDistance(
                    currentcluster[0].latitude,
                    currentcluster[0].longitude,
                    monuments[i].latitude,
                    monuments[i].longitude) <
                0.5) {
              i++;
              trouv = true;
              // On conclut que le monument a été visité
              DatabaseService()
                  .visited(monuments[i].latitude, monuments[i].longitude);
              await showDialog(
                  context: context,
                  builder: (_) => new AlertDialog(
                        title: Text("Vous avez visité " +
                            monuments[i].titre +
                            " recemment"),
                        content: Column(
                          children: [
                            Text("Voulez vous noter ce monument ?"),
                            RatingBar.builder(
                              initialRating: 3,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            )
                          ],
                        ),
                      ));
            }
          }
        }
        currentcluster = [];
        currentcluster.add(pendinglocation);
        pendinglocation = null;
        t = 0;
        if (calculateDistance(userlocation.latitude, userlocation.longitude,
                currentcluster[0].latitude, currentcluster[0].longitude) <
            0.1) {
          currentcluster
              .add(LatLng(userlocation.latitude, userlocation.longitude));
          pendinglocation = null;
        } else {
          pendinglocation =
              LatLng(userlocation.latitude, userlocation.longitude);
        }
      } else {
        pendinglocation = LatLng(userlocation.latitude, userlocation.longitude);
      }
    }
  }*/
  // ON ESSAYE

  void updatelocation(double lat, double long) {
    globalKey.currentState.essai(lat, long);
  }

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  File _image;
  PopupSnap popupSnap;
  String dropdownValue;
  String periode;
  bool _value;
  bool resto = true;
  int _selectedIndex = 0;
  List<bool> listepoque;
  bool appbar = true;
  List<Monument> monuments;
  //int _selectedIndex=0;
  List<Widget> _widgetOptions;
  /*List<Widget> _widgetOptions = <Widget>[
    Map(globalKey,monuments),
    Text("Restaurants"),
    Container(
        child: MaterialButton(
            onPressed: () => AuthService().signOut(), child: Text("Log out"))),
  ];*/

  Future<List<Monument>> chargerMonument() async {
    var location = new Location();
    LocationData userlocation = await location.getLocation();
    print(userlocation.latitude.toString());
    currentcluster.add(LatLng(userlocation.latitude, userlocation.longitude));
    print("pos ajouté");

    //print("monuments:" + monuments.toString());

    QuerySnapshot<Object> querySnapshot = await DatabaseService().getData();
    //print("get data");
    monuments = await DatabaseService().convertMonument(querySnapshot);
    //print("fini de charger les mnonuments");
    return monuments;
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index != 0) {
        appbar = false;
      } else {
        if(index==3){
          AuthService().signOut();
        }
        appbar = true;
      }

      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: chargerMonument(),
        builder: (context, snaphot) {
          if (snaphot.hasData) {
            /// A ENLEVE SA DEP
            _widgetOptions = <Widget>[
              Map(globalKey, monuments, listepoque, resto),
              Resthome(),
              MagasinHome(),
              //Parametre(),
              MyHomePage(),
            ];

            return SafeArea(
                child: Scaffold(
              appBar: appbar
                  ? AppBar(
                      shape: Border(
                          top: BorderSide(color: Colors.white, width: 0.5)),
                      backgroundColor: Colors.black,
                      title: Text("Al Djazair",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Patrick')),
                      centerTitle: true,
                      actions: [
                        IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              showSearch(
                                  context: context,
                                  delegate: CustomSearchDelegate(
                                      monuments, updatelocation));
                            }),
                      ],
                    )
                  : null,
              drawer: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child: Drawer(
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          height: 50,
                          color: Colors.black,
                          child: TabBar(
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.grey,
                              tabs: [
                                Tab(text: "Recommendations"),
                                Tab(text: "Favoris"),
                                Tab(text: "Options")
                              ]),
                        ),
                        Expanded(
                            child: Container(
                                child: TabBarView(children: [
                          Container(child: ListRecomend()),
                          Container(child: ListFav()),
                          Container(
                                child: Column(
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "Choissez les periodes historiques qui vous interessent:"),
                                  ),
                                  Column(children: [
                                    CheckboxListTile(
                                        title: Text("Antique"),
                                        value: listepoque[0],
                                        onChanged: (value) {
                                          setState(() {
                                            listepoque[0] = value;
                                          });
                                        }),
                                    CheckboxListTile(
                                        title: Text("Médiévale"),
                                        value: listepoque[1],
                                        onChanged: (value) {
                                          setState(() {
                                            listepoque[1] = value;
                                          });
                                        }),
                                    CheckboxListTile(
                                        title: Text("Contemporaine"),
                                        value: listepoque[2],
                                        onChanged: (value) {
                                          setState(() {
                                            listepoque[2] = value;
                                          });
                                        }),
                                    CheckboxListTile(
                                        title: Text("Moderne"),
                                        value: listepoque[3],
                                        onChanged: (value) {
                                          setState(() {
                                            listepoque[3] = value;
                                          });
                                        }),
                                    SwitchListTile(
                                        title: Text("Afficher les monunuments"),
                                        value: _value,
                                        onChanged: (bool value) {
                                          for (int i = 0; i < 4; i++) {
                                            listepoque[i] = value;
                                          }
                                          setState(() {
                                            _value = value;
                                          });
                                        }),
                                    SwitchListTile(
                                        title: Text("Afficher les restos"),
                                        value: resto,
                                        onChanged: (bool value) {
                                          setState(() {
                                            resto = value;
                                          });
                                        }),
                                    Center(
                                        child: MaterialButton(
                                            color: Colors.grey[100],
                                            child: Text(
                                                "Proposer votre position comme monument!"),
                                            onPressed: () async {
                                              await showDialog(
                                                context: context,
                                                builder: (context) {
                                                
                                                  return StatefulBuilder(builder:
                                                      (context, setState) {
                                                    return SingleChildScrollView(
                                                      child: AlertDialog(
                                                            title: Text(
                                                                "Proposer votre position comme monument !"),
                                                            content: SingleChildScrollView(
                                                              child: Column(
                                                                  
                                                                    children: [
                                                                      
                                                                          TextFormField(
                                                                              onChanged:
                                                                                  (value) {},
                                                                              decoration: InputDecoration(
                                                                                  labelText:
                                                                                      'Nom du Monument',
                                                                                  enabledBorder: OutlineInputBorder(
                                                                                      borderSide: BorderSide(
                                                                                          color: Colors.grey[
                                                                                              400])),
                                                                                  border: OutlineInputBorder(
                                                                                      borderSide:
                                                                                          BorderSide(
                                                                                              color: Colors.grey[400])
                                                                                              )
                                                                                              )
                                                                                              ),
                                                                      SizedBox(
                                                                        height: 10.0,
                                                                      ),
                                                                        TextField(
                                                                            keyboardType:
                                                                                TextInputType
                                                                                    .multiline,
                                                                            maxLines: null,
                                                                            decoration: InputDecoration(
                                                                                labelText:
                                                                                    'Description...',
                                                                                enabledBorder: OutlineInputBorder(
                                                                                    borderSide: BorderSide(
                                                                                        color: Colors.grey[
                                                                                            400])),
                                                                                border: OutlineInputBorder(
                                                                                    borderSide:
                                                                                        BorderSide(
                                                                                            color: Colors.grey[400]))
                                                                      )),
                                                                      Row(
                                                                        children: [
                                                                          Text("Periode:"),
                                                                          SizedBox(
                                                                            width: 65,
                                                                          ),
                                                                          DropdownButton(
                                                                            value: periode,
                                                                            icon: const Icon(
                                                                                Icons
                                                                                    .arrow_downward),
                                                                            iconSize: 24,
                                                                            elevation: 16,
                                                                            onChanged: (String
                                                                                newValue) {
                                                                              setState(() {
                                                                                periode =
                                                                                    newValue;
                                                                              });
                                                                            },
                                                                            items: <String>[
                                                                              'Antique',
                                                                              'Medievale',
                                                                              'Contemporaine',
                                                                              'Moderne'
                                                                            ].map<
                                                                                DropdownMenuItem<
                                                                                    String>>((String
                                                                                value) {
                                                                              return DropdownMenuItem<
                                                                                  String>(
                                                                                value:
                                                                                    value,
                                                                                child: Text(
                                                                                    value),
                                                                              );
                                                                            }).toList(),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                              "Categorie:"),
                                                                          SizedBox(
                                                                            width: 60,
                                                                          ),
                                                                          DropdownButton(
                                                                            value:
                                                                                dropdownValue,
                                                                            icon: const Icon(
                                                                                Icons
                                                                                    .arrow_downward),
                                                                            iconSize: 24,
                                                                            elevation: 16,
                                                                            onChanged: (String
                                                                                newValue) {
                                                                              setState(() {
                                                                                dropdownValue =
                                                                                    newValue;
                                                                              });
                                                                            },
                                                                            items: <String>[
                                                                              'Ruines',
                                                                              'Palais',
                                                                              'Jardin',
                                                                              'Mosquée',
                                                                              'Musée',
                                                                              'foret',
                                                                            ].map<
                                                                                DropdownMenuItem<
                                                                                    String>>((String
                                                                                value) {
                                                                              return DropdownMenuItem<
                                                                                  String>(
                                                                                value:
                                                                                    value,
                                                                                child: Text(
                                                                                    value),
                                                                              );
                                                                            }).toList(),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      MaterialButton(
                                                                          child: Text(
                                                                              "add image"),
                                                                          onPressed:
                                                                              () async {
                                                                            PickedFile
                                                                                imageFile =
                                                                                await picker
                                                                                    .getImage(
                                                                                        source:
                                                                                            ImageSource.gallery);

                                                                            setState(() {

                                                                              _image = File(
                                                                                  imageFile
                                                                                      .path);
                                                                            });
                                                                          }),
                                                                      Container(
                                                                        child: _image ==
                                                                                null
                                                                            ? Text(
                                                                                "pas d'image")
                                                                            : Image(image:FileImage(
                                                                                    _image)),
                                                                      )
                                                                    ],
                                                                  
                                                                ),
                                                            ),
                                                            
                                                            actions: [
                                                              TextButton(
                                                                  onPressed: () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      Text("Envoyez"))
                                                            ]),
                                                    );
                                                    
                                                  });
                                                },
                                              );
                                            })),
                                  ]),
                                ])),
                          
                        ])))
                      ],
                    ),
                  ),
                ),
              ),
              key: _scaffoldKey,
              body: _widgetOptions.elementAt(_selectedIndex),
              //body: Map(key: globalKey),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(color: Colors.white, width: 0.5))),
                child: BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.map),
                        label: 'Carte',
                        backgroundColor: Colors.black),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.restaurant_menu),
                        label: 'Restaurants',
                        backgroundColor: Colors.black),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.shopping_bag),
                        label: 'Magasin',
                        backgroundColor: Colors.black),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.logout),
                        label: 'Deconnexion',
                        backgroundColor: Colors.black)
                  ],
                  currentIndex: _selectedIndex,
                  //selectedItemColor: Colors.blueGrey,
                  onTap: _onItemTapped,
                ),
              ),
            ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
