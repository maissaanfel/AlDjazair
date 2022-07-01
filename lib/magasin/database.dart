import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aldjazair/magasin/magasin.dart';

class DatabaseMService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> _collectionRef =
      FirebaseFirestore.instance.collection('Magasin');

  Future<QuerySnapshot> getData() async {
    QuerySnapshot querySnapshot = await _collectionRef.get();
    return querySnapshot;
  }

  List<Magasin> convert(QuerySnapshot querySnapshot) {
    List<Magasin> m = [];

    querySnapshot.docs.forEach((element) {
      Magasin a = Magasin(element["id"], element["nom"], element['description'],
          element['url'], element['note']);
      m.add(a);
    });

    return m;
  }

  Future<QuerySnapshot> getMagasin() {
    Future query = _collectionRef.get();
    return query;
  }

  //systeme de recommandation
  //on prends ceux avec la note la plus élevé 5 >>>> 0:

  Future<List<Magasin>> getNoteFav() async {
    List<Magasin> magasin;
    List<int> t = List<int>.filled(3, null);
    List<Magasin> finale = [];
    // ignore: unused_local_variable
    QuerySnapshot query = await DatabaseMService().getMagasin();
    magasin = DatabaseMService().convert(query);

    print("fin1");
    for (int i = 0; i < magasin.length; i++) {
      for (int j = 0; j < 3; j++) {
        int max = 5;
        int pos = 0;
        if (magasin[i].note == max && !(t.contains(i))) {
          max = magasin[i].note;
          pos = i;
          t[j] = pos;
        }
      }
    }
    print("fin2");
    print("le restaurant avec le plus gros score est:" + magasin[t[0]].name);
    finale.add(magasin[t[0]]);
    /*for (int i = 0; i < magasin.length; i++) {
      for (int j = 0; j < 3; j++) {
        int max = 4;
        int pos = 0;
        if (magasin[i].note == max && !(t.contains(i))) {
          max = magasin[i].note;
          pos = i;
          t[j] = pos;
        }
      }
    }
    print(
        "le restaurant avec le 2eme plus gros score est:" + magasin[t[0]].name);
    finale.add(magasin[t[0]]);*/
    for (int i = 0; i < magasin.length; i++) {
      for (int j = 0; j < 3; j++) {
        int max = 3;
        int pos = 0;
        if (magasin[i].note == max && !(t.contains(i))) {
          max = magasin[i].note;
          pos = i;
          t[j] = pos;
        }
      }
    }
    print(
        "le restaurant avec le 3eme plus gros score est:" + magasin[t[0]].name);
    finale.add(magasin[t[0]]);
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
