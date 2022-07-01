import 'dart:math';

import 'package:aldjazair/models/customcomment.dart';
import 'package:aldjazair/models/monument.dart';

import 'package:aldjazair/services/auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import "package:latlong/latlong.dart";
import 'package:location/location.dart';

import '../models/customcomment.dart';

class DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> _collectionRef =
      FirebaseFirestore.instance.collection('PointGPS');

  CollectionReference<Map<String, dynamic>> _usersCollection =
      FirebaseFirestore.instance.collection('Users');

  Future<QuerySnapshot> getData() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();
    return querySnapshot;
  }

  List<LatLng> convert(QuerySnapshot querySnapshot) {
    List<LatLng> l = [];
    querySnapshot.docs.forEach((element) {
      LatLng c = LatLng(element["Latitude"], element["Longitude"]);
      l.add(c);
    });
    return l;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<List<Monument>> convertMonument(QuerySnapshot querySnapshot) async {
    var location = new Location();
    LocationData userlocation = await location.getLocation();
    List<Monument> l = [];
    querySnapshot.docs.forEach((element) {
      //print(element["Latitude"]);
      double d;
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((element['Latitude'] - userlocation.latitude) * p) / 2 +
          c(userlocation.latitude * p) *
              c(element["Latitude"] * p) *
              (1 - c((element["Longitude"] - userlocation.longitude) * p)) /
              2;
      d = 12742 * asin(sqrt(a));
      print("ici");
      Monument m = Monument(
          element["Latitude"], element["Longitude"], element['titre'],
          element["type"],
          distance: d.round(),
          note: element["note"],
          periode: element["periode"],
          categorie: element["categorie"],
          shortdescription: element["shortdescrption"]);
      l.add(m);
      print("la");
    });
    return l;
  }

  // ignore: missing_return
  Future<List<Monument>> convertFav() async {
    print("appelle de la fct");
    List<Monument> l = [];
    QuerySnapshot favoris = await _usersCollection
        .doc(AuthService().uidUser())
        .collection('Favorite')
        .get();
    print("favoris lenght:" + favoris.docs.length.toString());
    favoris.docs.forEach((element) {
      print("creation d'un monument");
      Monument m = Monument(
          element['latitude'], element['longitude'], element['titre'],element['type'],
          shortdescription: element['shortdecrption']);
      print("ajout du monument");
      l.add(m);
      print("monument ajouté");
    });
    print("on retourne l");
    return l;
  }

  Future<List<CustomComment>> convertComment(
      QuerySnapshot querySnapshot) async {
    List<CustomComment> l = [];

    List<String> listlike = [];

    List<String> dislike = [];

    await _usersCollection
        .doc(AuthService().uidUser())
        .collection('CommentairesLike')
        .get()
        .then((value) => value.docs.forEach((element) {
              listlike.add(element['uid']);
            }));

    await _usersCollection
        .doc(AuthService().uidUser())
        .collection('CommentairesdisLike')
        .get()
        .then((value) => value.docs.forEach((element) {
              dislike.add(element['uid']);
            }));

    querySnapshot.docs.forEach((element) async {
      CustomComment c = CustomComment(
          element['nom'],
          element['prenom'],
          element["comment"],
          listlike.contains(element.id) ? true : false,
          dislike.contains(element.id) ? true : false,
          element.id,
          element['nbrlike'],
          element['nbrdislike'],
          element["lien"]);
      l.add(c);
    });
    return l;
  }

  Future updateLike(String uid, bool b, int nbrlike, String titre) async {
    if (b) {
      await _usersCollection
          .doc(AuthService().uidUser())
          .collection('CommentairesLike')
          .doc(uid)
          .set({'uid': uid});
      await _collectionRef
          .doc(titre)
          .collection("Commentaires")
          .doc(uid)
          .update({'nbrlike': nbrlike + 1});
    } else {
      await _collectionRef
          .doc(titre)
          .collection("Commentaires")
          .doc(uid)
          .update({'nbrlike': nbrlike - 1});
      await _usersCollection
          .doc(AuthService().uidUser())
          .collection('CommentairesLike')
          .doc(uid)
          .delete();
    }
  }

  Future updateDislike(String uid, bool b, int nbrdislike, String titre) async {
    if (b) {
      await _usersCollection
          .doc(AuthService().uidUser())
          .collection('CommentairesdisLike')
          .doc(uid)
          .set({'uid': uid});
      await _collectionRef
          .doc(titre)
          .collection("Commentaires")
          .doc(uid)
          .update({'nbrdislike': nbrdislike + 1});
    } else {
      await _usersCollection
          .doc(AuthService().uidUser())
          .collection('CommentairesdisLike')
          .doc(uid)
          .delete();
      await _collectionRef
          .doc(titre)
          .collection("Commentaires")
          .doc(uid)
          .update({'nbrdislike': nbrdislike - 1});
    }
  }

  Future<QuerySnapshot> getComments(String titre) async {
    return _collectionRef.doc(titre).collection("Commentaires").get();
  }

  Future comment(String titre, String comment,String lien) async {
    String name;
    String prenom;
    name = await _usersCollection
        .doc(AuthService().uidUser())
        .get()
        .then((value) => value.data()['nom']);
    prenom= await _usersCollection
        .doc(AuthService().uidUser())
        .get()
        .then((value) => value.data()['prenom']);
    await _collectionRef.doc(titre).collection("Commentaires").add({
      "comment": comment,
      "dislike": false,
      "liked": false,
      "nom": name,
      "prenom": prenom,
      "nbrlike": 0,
      "nbrdislike": 0,
      "lien": lien
    });
    print("comment ajouté");
  }

  Future visited(double lat, double long) async {
    QuerySnapshot query = await getMonument(LatLng(lat, long));
    List<LatLng> monument = convert(query);
    QuerySnapshot check = await _usersCollection
        .doc(AuthService().uidUser())
        .collection("Visited")
        .where("latitude", isEqualTo: monument.elementAt(0).latitude)
        .get();
    if (check.docs.length == 0) {
      await _usersCollection
          .doc(AuthService().uidUser())
          .collection("Visited")
          .add({
        "latitude": monument.elementAt(0).latitude,
        "longitude": monument.elementAt(0).longitude
      });
    } else {
      print("existe déja");
    }
  }

  Future<QuerySnapshot> getMonument(LatLng latLng) async {
    QuerySnapshot query = await _collectionRef
        .where("Latitude", isEqualTo: latLng.latitude)
        .where("Longitude", isEqualTo: latLng.longitude)
        .get();

    return query;
  }

  Future deleteFav(double lat, double long) async {
    QuerySnapshot query = await _usersCollection
        .doc(AuthService().uidUser())
        .collection("Favorite")
        .where("latitude", isEqualTo: lat)
        .get();
    String id = query.docs[0].id;
    _usersCollection
        .doc(AuthService().uidUser())
        .collection("Favorite")
        .doc(id)
        .delete();
  }

  Future addFav(
      double lat, double long, String titre, String shortdescription) async {
    QuerySnapshot query = await getMonument(LatLng(lat, long));
    List<Monument> l = await convertMonument(query);
    _usersCollection.doc(AuthService().uidUser()).collection("Favorite").add({
      "latitude": l.elementAt(0).latitude,
      "longitude": l.elementAt(0).longitude,
      "titre": l.elementAt(0).titre,
      "shortdecrption": l.elementAt(0).shortdescription,
      "type": "monu"
    });
  }

  Future updateNote(double lat, double long, int note) async {
    QuerySnapshot query = await getMonument(LatLng(lat, long));
    String id = query.docs[0].id;
    _collectionRef.doc(id).update({'note': note});
  }

  Future<List<Monument>> convertFavandVisited(QuerySnapshot visited) async {
    List<Monument> l = [];
    var location = new Location();
    LocationData userlocation = await location.getLocation();
    visited.docs.forEach((element) async {
      double d = calculateDistance(userlocation.latitude,
          userlocation.longitude, element["latitude"], element["longitude"]);

      QuerySnapshot query =
          await getMonument(LatLng(element["latitude"], element["longitude"]));
      query.docs.forEach((element) {
        Monument m = Monument(
            element["Latitude"], element["Longitude"], element['titre'],element['type'],
            distance: d.round(),
            note: element["note"],
            periode: element["periode"],
            categorie: element["categorie"],
            shortdescription: element["shortdescrption"]);

        l.add(m);
      });
    });
    return l;
  }

  int similarite(Monument m1, Monument m2) {
    print("similarite");
    int note = 0;
    double distance =
        calculateDistance(m1.latitude, m1.longitude, m2.latitude, m2.longitude);
    if (distance < 1) {
      // moins de 1 km
      note = 20;
    } else {
      if (distance < 3) {
        //moins de 3km
        note = 10;
      }
    }
    if (m1.categorie == m2.categorie) {
      note = note + 40;
    }
    if (m1.periode == m2.periode) {
      note = note + 40;
    }
    return note;
  }

  Future<bool> isfavorite(double lat, double long) async {
    QuerySnapshot query = await _usersCollection
        .doc(AuthService().uidUser())
        .collection("Favorite")
        .where("latitude", isEqualTo: lat)
        .get();
    if (query.docs.length == 0) {
      print("return false");
      return false;
    } else {
      print("return true");
      return true;
    }
  }

  /*fav.docs.forEach((element) async {
      QuerySnapshot m=await getMonument(LatLng(element['latitude'],element['longitude']));
      l=await convertMonument(m);
      print("element titre:"+l.elementAt(0).titre);
      favoris.add(l.elementAt(0));
    });*/

  Future<List<Monument>> getVisitedAndFav() async {
    // On recupere les monuments visité
    List<Monument> favoris;
    List<Monument> visit;
    QuerySnapshot visited = await _usersCollection
        .doc(AuthService().uidUser())
        .collection("Visited")
        .get();
    // On recupere les monuments en favoris
    QuerySnapshot fav = await _usersCollection
        .doc(AuthService().uidUser())
        .collection("Favorite")
        .get();
    // on les convertit en liste
    print("Visited lenght before conversion:" + visited.docs.length.toString());
    print("fav lenght before conversion:" + fav.docs.length.toString());
    if (fav.docs.length == 0) {
      favoris = [];
    } else {
      favoris = await convertFavandVisited(fav);
    }
    print("favoris lenght:" + favoris.length.toString());
    if (visited.docs.length == 0) {
      visit = [];
    } else {
      visit = await convertFavandVisited(visited);
    }

    QuerySnapshot monument = await getData();
    List<Monument> monuments = await convertMonument(monument);
    for (int i=0;i<monuments.length;i++){
      if(monuments[i].type=="resto"){
        monuments.removeAt(i);
      }
    }
    print("favoris lenght2:" + favoris.length.toString());
    // on les fusionnes;
    if (favoris.isEmpty) {
      print("fav is empty");
      if (visit.isEmpty) {
        monuments.sort((a,b)=> b.note.compareTo(a.note));
        List<Monument> finale = [];
        // a changer quand plus de monument pour prendre 5
        for (int i = 0; i < 5; i++) {
        
          //monuments[i].setNote(null);
          finale.add(monuments[i]);
        }
        return finale;
      } else {
        print("fav is empty but not visit");
        favoris = visit;
      }
    } else {
      if (visit.isNotEmpty) {
        print("fav not empty and visit not");
        favoris.addAll(visit);
      } else {
        print("fav not empty and visit is");
      }
    }
    // On recupe l'ensemble des monuments
    // supprime les elements en commun
    List<Monument> m = [];
    for (int i = 0; i < monuments.length; i++) {
      bool trv = false;
      int j = 0;
      while (j < favoris.length && !trv) {
        if (monuments[i].titre == favoris[j].titre) {
          trv = true;
        }
        j++;
      }
      if (!trv) {
        m.add(monuments[i]);
      }
    }
    monuments = m;
    if (monuments.length == 0) {
      return [];
    }

    // on initialise a 0
    List<int> notes = List<int>.filled(monuments.length, 0, growable: true);
    /*for (int i = 0; i < notes.length; i++) {
      notes[i] = 0;
    }*/
    // on calcule la somme des similarites
    for (int i = 0; i < favoris.length; i++) {
      for (int j = 0; j < monuments.length; j++) {
        int temp = similarite(monuments[j], favoris[i]);
        notes[j] += temp;
      }
    }
    print("avant la division par :" + notes.length.toString());
    print("1er monument:" + monuments[0].titre + " " + notes[0].toString());
    print("2nd monument:" + monuments[1].titre + " " + notes[1].toString());
    print("3em monument:" + monuments[2].titre + " " + notes[2].toString());  
    // on divise par le nombre de monument en favoris
    for (int i = 0; i < favoris.length; i++) {
      notes[i] = (notes[i] / favoris.length).round();
    }
    /*print("apres la division par :"+notes.length.toString());
    print("1er:"+monuments[0].titre+" "+notes[0].toString());
    print("2nd:"+monuments[1].titre+" "+notes[1].toString());
    */
    // on prends les 5 premiers
    print("monument lenght:" + monuments.length.toString());

    List<int> t = List<int>.filled(3, null);
    for (int j = 0; j < 3; j++) {
      int max = 0;
      int pos = 0;
      for (int i = 0; i < notes.length; i++) {
        if (notes[i] >= max && !(t.contains(i))) {
          max = notes[i];
          pos = i;
          t[j] = pos;
        }
      }
    }
    // on a dans t la position des 5 premiers

    print("le monument avec le plus gros score est:" +
        monuments[t[0]].titre +
        " avec un score de:" +
        notes[t[0]].toString());
    print("le monument avec le plus gros score est:" +
        monuments[t[1]].titre +
        " avec un score de:" +
        notes[t[2]].toString());
    List<Monument> finale = [];
    // mettre la taille a la place
    for (int i = 0; i < 3; i++) {
      int pos = t[i];
      finale.add(monuments[pos]);
      finale[i].setNote(notes[pos]);
    }
    print("1er note:" +
        finale[0].note.toString() +
        " et c'est:" +
        finale[0].titre);
    print("fin");
    return finale;
  }

  Future updataUserData(String uid, String email,String nom,String prenom) async {
    return await _usersCollection
        .doc(uid)
        .set({'uid': uid, 'email': email, 'nom': nom, 'prenom':prenom});
  }
}
