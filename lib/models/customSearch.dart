
import 'package:aldjazair/models/monument.dart';

import 'package:flutter/material.dart';



class CustomSearchDelegate extends SearchDelegate {
  Function update;
  List<Monument> monument;
  
  CustomSearchDelegate(this.monument,this.update);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: (){
        query="";
      })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
  return IconButton(
      icon: AnimatedIcon(icon:AnimatedIcons.menu_arrow,progress: transitionAnimation),
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

    List<Monument> favmonument=[];
    print("nbr de monument dans buildsug"+monument.length.toString());
    for(int i=0;i<monument.length;i++){
      favmonument.add(monument[i]);
    }
    
    final suggestionList = query.isEmpty ? favmonument:monument.where((element) => element.titre.startsWith(query)).toList();
    return ListView.builder(itemBuilder: (context,index)=>ListTile(
      onTap: ()
      {
        print('i');
        update(suggestionList[index].latitude,suggestionList[index].longitude);
        print("ii");
        close(context,null);
      },
      title: RichText(text: TextSpan(
        text: suggestionList[index].titre.substring(0,query.length),
        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),
        children: [
          TextSpan(text:suggestionList[index].titre.substring(query.length),style: TextStyle(color:Colors.grey))
        ]
        
      ),
    ),
    leading: Icon(suggestionList[index].type=="monu"? Icons.place_outlined: Icons.restaurant_menu),
    trailing: Text(suggestionList[index].distance.toString()+" km"),
    ),
    itemCount: suggestionList.length);
  }
}