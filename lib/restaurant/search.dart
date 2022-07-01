import 'package:aldjazair/restaurant/decouvrir.dart';
import 'package:aldjazair/restaurant/restaurant.dart';
import 'package:flutter/material.dart';
//import 'package:aldjazair/bd_rest.dart';

class RestSearchDelegate extends SearchDelegate {
  List<Restaurant> restaurant;
  RestSearchDelegate(this.restaurant);
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
    List<Restaurant> rest = [];
    print(restaurant.length.toString());
    for (int i = 0; i < restaurant.length; i++) {
      rest.add(restaurant[i]);
    }

    final suggestionList = query.isEmpty
        ? rest
        : restaurant
            .where((element) => element.name.startsWith(query))
            .toList();
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
              leading: Icon(Icons.restaurant_menu),
            ),
        itemCount: suggestionList.length);
  }
}
