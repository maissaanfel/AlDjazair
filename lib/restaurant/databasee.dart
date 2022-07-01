import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aldjazair/restaurant/restaurant.dart';

class DatabaseRService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> _collectionRef =
      FirebaseFirestore.instance.collection('Restaurant');

  Future<QuerySnapshot> getData() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();
    return querySnapshot;
  }

  List<Restaurant> convert(QuerySnapshot querySnapshot) {
    List<Restaurant> r = [];

    querySnapshot.docs.forEach((element) {
      Restaurant s = Restaurant(
          element["id"],
          element["nom"],
          element["soustitre"],
          element["url"],
          element['description'],
          element['note']);
      r.add(s);
    });

    return r;
  }

  Future<QuerySnapshot> getRestaurant() {
    Future query = _collectionRef.get();
    return query;
  }

  //systeme de recommandation
  //on prends ceux avec la note la plus élevé 5 >>>> 0:

  Future<List<Restaurant>> getNoteFav() async {
    List<Restaurant> restaurents;
    List<int> t = List<int>.filled(3, null);
    List<Restaurant> finale = [];
    // ignore: unused_local_variable
    QuerySnapshot query = await DatabaseRService().getRestaurant();
    restaurents = DatabaseRService().convert(query);

    print("fin1");
    for (int i = 0; i < restaurents.length; i++) {
      for (int j = 0; j < 3; j++) {
        int max = 5;
        int pos = 0;
        if (restaurents[i].note == max && !(t.contains(i))) {
          max = restaurents[i].note;
          pos = i;
          t[j] = pos;
        }
      }
    }
    print("fin2");
    print(
        "le restaurant avec le plus gros score est:" + restaurents[t[0]].name);
    finale.add(restaurents[t[0]]);
    for (int i = 0; i < restaurents.length; i++) {
      for (int j = 0; j < 3; j++) {
        int max = 4;
        int pos = 0;
        if (restaurents[i].note == max && !(t.contains(i))) {
          max = restaurents[i].note;
          pos = i;
          t[j] = pos;
        }
      }
    }
    print("le restaurant avec le 2eme plus gros score est:" +
        restaurents[t[0]].name);
    finale.add(restaurents[t[0]]);
    /*for (int i = 0; i < restaurents.length; i++) {
      for (int j = 0; j < 3; j++) {
        int max = 3;
        int pos = 0;
        if (restaurents[i].note == max && !(t.contains(i))) {
          max = restaurents[i].note;
          pos = i;
          t[j] = pos;
        }
      }
    }
    print("le restaurant avec le 3eme plus gros score est:" +
        restaurents[t[0]].name);
    finale.add(restaurents[t[0]]);*/
    // on a dans t la position des 3 premiers
    //List<Restaurant> finale = [];
    // mettre la taille a la place
    print("fin3");
    /*for (int i = 0; i < 3; i++) {
      //int pos = t[i];
      print("fin4");
      finale.add(restaurents[t[i]]);
    }
    print("fin5");*/
    return finale;
  }
}
