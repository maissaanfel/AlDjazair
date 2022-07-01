import 'package:aldjazair/magasin/decouvrir.dart';
import 'package:aldjazair/magasin/magasin.dart';
import 'package:flutter/material.dart';
//import 'package:aldjazair/bd_rest.dart';

class RestSearchDelegate extends SearchDelegate {
  List<Magasin> magasin;
  RestSearchDelegate(this.magasin);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Magasin> rest = [];
    print(magasin.length.toString());
    for (int i = 0; i < magasin.length; i++) {
      rest.add(magasin[i]);
    }

    final suggestionList = query.isEmpty
        ? rest
        : magasin.where((element) => element.name.startsWith(query)).toList();
    return ListView.builder(
        itemBuilder: (context, index) => ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Decouvrir(
                        suggestionList[index],
                      ),
                    ));
              },
              title: RichText(
                text: TextSpan(
                    text: suggestionList[index].name.substring(0, query.length),
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    children: [
                      TextSpan(
                          text: suggestionList[index]
                              .name
                              .substring(query.length),
                          style: TextStyle(color: Colors.grey))
                    ]),
              ),
              leading: Icon(Icons.shopping_bag),
            ),
        itemCount: suggestionList.length);
  }
}
