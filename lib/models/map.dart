import 'dart:async';
import 'package:aldjazair/models/monument.dart';
import 'package:aldjazair/models/popup.dart';
//import 'package:aldjazair/services/database.dart';
import 'package:aldjazair/zoombuttons_plugin_option.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location/flutter_map_location.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import 'package:latlong/latlong.dart';

class Map extends StatefulWidget {
  final Key key;
  final List<Monument> monuments;
  final List<bool> epoque;
  final bool resto;
  Map(this.key, this.monuments, this.epoque,this.resto);
  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<Map> {
  static const _markerSize = 30.0;
  List<Marker> _markers;
  //List<LatLng> _points;
  List<Monument> _points;
  List<LatLng> polylines;
  double distance;
  String destination;
  int refresh = 360000;
  MapController mapController;

  // ON teste des trucs

  CenterOnLocationUpdate _centerOnLocationUpdate;
  StreamController<double> _centerCurrentLocationStreamController;
  // ON ESSAYE
  final PopupController _popupLayerController = PopupController();

  // ON ESSAYE
  @override
  void initState() {
    super.initState();
    mapController = MapController();
    //mapController.onReady.then((value) => print("Map Controller is ready"));
    _centerOnLocationUpdate = CenterOnLocationUpdate.always;
    _centerCurrentLocationStreamController = StreamController<double>();
  }

  // ON ESSAYE TOUJOURS
  @override
  void dispose() {
    _centerCurrentLocationStreamController.close();
    super.dispose();
  }

  Future<String> test() async {
    /*QuerySnapshot<Object> querySnapshot = await DatabaseService().getData();
    _points = DatabaseService().convert(querySnapshot);*/
    _points = [];
    /*print("------------------------------------------------------");
    print("epoque widget 1 antique:"+widget.epoque[0].toString());
            print("epoque widget 2 medievale:"+widget.epoque[1].toString());
            print("epoque widget 3 contomporaine:"+widget.epoque[2].toString());
            print("epoque widget 4 moderne:"+widget.epoque[3].toString());
    print("------------------------------------------------------");*/
    
    for (int i = 0; i < widget.monuments.length; i++) {
      /* print("epoque widget 1 antique dans la boucle :"+widget.epoque[0].toString());
            print("epoque widget 2 medievale dans la boucle:"+widget.epoque[1].toString());
            print("epoque widget 3 contomporaine dans la boucle:"+widget.epoque[2].toString());
            print("epoque widget 4 moderne dans la boucle:"+widget.epoque[3].toString());
    print("------------------------------------------------------");*/
      if(widget.monuments[i].type=="monu"){
      if (widget.epoque[0] == true) {
        // print("antique vraie");
        if (widget.monuments[i].periode == "antique") {
          // print("antique est vraie donc :"+widget.monuments[i].titre+" ajouté");
          _points.add(widget.monuments[i]);
        }
      }
      if (widget.epoque[1] == true) {
        //print("medievale vraie");
        if (widget.monuments[i].periode == "medievale") {
          //print("medievale est vraie donc :"+widget.monuments[i].titre+" ajouté");
          _points.add(widget.monuments[i]);
        }
      }
      if (widget.epoque[2] == true) {
        if (widget.monuments[i].periode == "contemporaine") {
          // print("contemporaine est vraie donc :"+widget.monuments[i].titre+" ajouté");
          _points.add(widget.monuments[i]);
        }
      }
      if (widget.epoque[3] == true) {
        if (widget.monuments[i].periode == "moderne") {
          //print("moderne est vraie donc :"+widget.monuments[i].titre+" ajouté");
          _points.add(widget.monuments[i]);
        }
      }
    }
    else if(widget.resto==true) {
          _points.add(widget.monuments[i]);

    }
    }
    // _points=widget.monuments;
    //print("------------------------------------------------------");
    setState(() {
      // print("set state");
      _markers = _points
          .map(
            (Monument point) => Marker(
                point: LatLng(point.latitude, point.longitude),
                builder: (_) => Icon(Icons.location_on, size: _markerSize,color: point.type=="monu"? Colors.black:Colors.red),
                width: _markerSize,
                height: _markerSize,
                anchorPos: AnchorPos.align(AnchorAlign.top)),
          )
          .toList();
    });

    return 'Okay';
  }

  void drawpolyline(List<LatLng> line, String desti, double d, int refreash) {
    print(line.length.toString());
    setState(() {
      polylines = line;
      destination = desti;
      distance = d;
      refresh = refresh;
      _centerOnLocationUpdate = CenterOnLocationUpdate.always;
      _centerCurrentLocationStreamController.add(18);
    });
  }

  void essai(double lat, double long) {
    setState(() {
      _centerOnLocationUpdate = CenterOnLocationUpdate.never;
    });
    mapController.move(LatLng(lat, long), 18);
  }

/* TimerBuilder.periodic(Duration(seconds: refresh),
        builder: (context) => */
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: test(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            //print("est ce que probleme avant ?");
            children = [
              Flexible(
                child: FlutterMap(
                  mapController: mapController,
                  children: [
                    LocationMarkerLayerWidget(
                      plugin: LocationMarkerPlugin(
                          centerCurrentLocationStream:
                              _centerCurrentLocationStreamController.stream,
                          //_centerOnLocationUpdate
                          centerOnLocationUpdate: _centerOnLocationUpdate),
                    )
                  ],
                  options: MapOptions(
                    onPositionChanged: (MapPosition position, bool hasGesture) {
                      if (hasGesture) {
                        setState(() => _centerOnLocationUpdate =
                            CenterOnLocationUpdate.never);
                      }
                    },
                    plugins: [
                      PopupMarkerPlugin(),
                      ZoomButtonsPlugin(),
                      LocationPlugin(),
                      TappablePolylineMapPlugin()
                    ],
                    interactiveFlags:
                        InteractiveFlag.all & ~InteractiveFlag.rotate,
                    zoom: 18.0,
                    center: LatLng(0, 0),
                    onTap: (_) => _popupLayerController
                        .hidePopup(), // Hide popup when the map is tapped.
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    TappablePolylineLayerOptions(
                        // Will only render visible polylines, increasing performance
                        polylineCulling: true,
                        pointerDistanceTolerance: 20,
                        polylines: [
                          TaggedPolyline(
                              points: polylines,
                              isDotted: true,
                              color: Colors.blue[300],
                              strokeWidth: 4.0)
                        ],
                        onTap: (TaggedPolyline polyline) async {
                          await showDialog(
                              context: context,
                              builder: (_) => new AlertDialog(
                                      title: Text(destination),
                                      content: Text("Vous etes à " +
                                          distance.round().toString() +
                                          "km de votre distination !"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("D'accord !")),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                polylines = [];
                                                refresh = 360000;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Effacer ce chemin"))
                                      ]));
                        },
                        onMiss: () {
                          print('No polyline was tapped');
                        }),
                    PopupMarkerLayerOptions(
                        markers: _markers,
                        popupSnap: PopupSnap.markerTop,
                        popupController: _popupLayerController,
                        popupBuilder: (BuildContext _, Marker marker) =>
                            ExamplePopup(marker, marker.point, drawpolyline)),
                    ZoomButtonsPluginOption(
                        minZoom: 4,
                        maxZoom: 22,
                        mini: true,
                        padding: 10,
                        alignment: Alignment.bottomRight),
                    LocationOptions(
                        onLocationUpdate: (LatLngData ld) {},
                        onLocationRequested: (LatLngData ld) {
                          if (ld == null) {
                            return;
                          }
                          mapController.move(ld.location, 16.0);
                        },
                        /* onLocationUpdate: (LatLngData ld) {},
                            onLocationRequested: (LatLngData ld) {
                              if (ld == null || ld.location == null) {
                                return;
                              }
                              /* return;
                              }
                              mapController?.move(ld.location, 16.0);*/
                              mapController.onReady.then((result) {
                                print("I AM READY");
                                mapController.move(ld.location, 16);
                              });
                              */

                        buttonBuilder: (BuildContext context,
                            ValueNotifier<LocationServiceStatus> status,
                            Function onPressed) {
                          return Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 14.0, right: 60.0),
                                  child: Container(
                                    height: 38,
                                    width: 38,
                                    child: FloatingActionButton(
                                        backgroundColor: Colors.grey,
                                        child: ValueListenableBuilder<
                                                LocationServiceStatus>(
                                            valueListenable: status,
                                            builder: (BuildContext context,
                                                LocationServiceStatus value,
                                                Widget child) {
                                              switch (value) {
                                                case LocationServiceStatus
                                                    .disabled:
                                                case LocationServiceStatus
                                                    .permissionDenied:
                                                case LocationServiceStatus
                                                    .unsubscribed:
                                                  return const Icon(
                                                    Icons.location_disabled,
                                                    color: Colors.white,
                                                  );
                                                  break;
                                                default:
                                                  return const Icon(
                                                    Icons.my_location,
                                                    color: Colors.white,
                                                  );
                                                  break;
                                              }
                                            }),
                                        onPressed: () {
                                          setState(() =>
                                              _centerOnLocationUpdate =
                                                  CenterOnLocationUpdate
                                                      .always);
                                          _centerCurrentLocationStreamController
                                              .add(18);
                                        }),
                                  )));
                        })
                  ],
                ),
              ),
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        });
  }
}
