import 'package:aldjazair/models/test.dart';
import 'package:aldjazair/services/database.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomPage extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Object>> snapshot;

  final List<String> imgList;
  CustomPage(this.snapshot, this.imgList);
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<CustomPage> {
  int current = 0;
  int _selectedIndex = 0;
  bool _isfavorite;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  Future<String> getfav() async {
    print("on intiliase");
    _isfavorite = await DatabaseService().isfavorite(
        widget.snapshot.data.docs[0]["Latitude"],
        widget.snapshot.data.docs[0]["Longitude"]);
    return "";
  }

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      setState(() {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        _selectedIndex = index;
      });
    }

    final List<Widget> _widgetOptions = <Widget>[
      History(widget.snapshot, widget.imgList),
      TestMe(widget.snapshot.data.docs[0]['titre'])
    ];

    return FutureBuilder(
        future: getfav(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            print("is fav:" + _isfavorite.toString());
            return Scaffold(
                key: _scaffoldkey,
                appBar: AppBar(
                  
                  backgroundColor: Colors.black,
                  actions: [
                    IconButton(
                        icon: _isfavorite
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(Icons.favorite_border),
                        onPressed: () async {
                          if (_isfavorite) {
                            await DatabaseService().deleteFav(
                                widget.snapshot.data.docs[0]["Latitude"],
                                widget.snapshot.data.docs[0]["Longitude"]);
                          } else {
                            await DatabaseService().addFav(
                                widget.snapshot.data.docs[0]["Latitude"],
                                widget.snapshot.data.docs[0]["Longitude"],
                                widget.snapshot.data.docs[0]["titre"],
                                widget.snapshot.data.docs[0]
                                    ["shortdescrption"]);
                          }
                          setState(() {
                            _isfavorite = !_isfavorite;
                          });
                        })
                  ],
                  title: Text(widget.snapshot.data.docs[0]['titre']),
                  centerTitle: true,
                ),
                body: _widgetOptions.elementAt(_selectedIndex),
                 
            
                bottomNavigationBar: 
                Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom:BorderSide(color: Colors.white, width: 1))),child:
                BottomNavigationBar(
                  
                  backgroundColor: Colors.black,
                  unselectedItemColor: Colors.grey,
                  selectedItemColor: Colors.white,
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.book), label: 'Histoire'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.chat), label: 'Commentaires'),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                )));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class History extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Object>> snapshot;

  final List<String> imgList;
  History(this.snapshot, this.imgList);
  @override
  State<StatefulWidget> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  int current = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: ListView(children: [
          SizedBox(height: 60),
          CarouselSlider(
            options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                height: 200.0,
                onPageChanged: (index, reason) {
                  this.setState(() {
                    current = index;
                  });
                }),
            items: widget.imgList.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Image.asset(i),
                  );
                },
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.imgList.map((url) {
              int index = widget.imgList.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: current == index ? Colors.black : Colors.grey,
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 40),
          Text(
            'Histoire:',
            style: TextStyle(fontSize: 25),
          ),
          Text(widget.snapshot.data.docs[0]['description']
              .toString()
              .replaceAll('\\n', '\n')),
        ]),
      ),
    );
  }
}
