

import 'package:aldjazair/models/comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/database.dart';
import 'customcomment.dart';

// ignore: must_be_immutable
class TestMe extends StatefulWidget {
  final dynamic titre;
  TestMe(this.titre);
  QuerySnapshot querySnapshot;
  @override
  _TestMeState createState() => _TestMeState();
}

class _TestMeState extends State<TestMe> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  List<CustomComment> filedata = [];

  Future<List<CustomComment>> function() async {
    print("appele");
    widget.querySnapshot = await DatabaseService().getComments(widget.titre);
    filedata = await DatabaseService().convertComment(widget.querySnapshot);
    return filedata;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: function(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print("build comment");
          if (snapshot.hasData) {
            return Container(
                child: filedata.isEmpty
                    ? CommentBox(
                      // a changer
                      userImage: "assets/user.jpg",
                      child:Container(child:Center(child:Text("Aucun commentaire pour le moment!"))),
                       labelText: 'Write a comment...',
                        errorText: 'Comment cannot be blank',
                        withBorder: false,
                        sendButtonMethod: () {
                          if (formKey.currentState.validate()) {
                           DatabaseService().comment(widget.titre,commentController.text,"assets/user.jpg");
                            setState(() {
                             /* // ignore: unused_local_variable
                              var value = {
                                'name': 'New User',
                                'pic':
                                    'https://lh3.googleusercontent.com/a-/AOh14GjRHcaendrf6gU5fPIVd8GIl1OgblrMMvGUoCBj4g=s400',
                                'message': commentController.text
                              };*/
                            });
                            commentController.clear();
                            FocusScope.of(context).unfocus();
                          } else {
                            print("Not validated");
                          }
                        },
                        formKey: formKey,
                        commentController: commentController,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        sendWidget: Icon(Icons.send_sharp,
                            size: 30, color: Colors.white),
                  
                    )
                    : CommentBox(// a changer
                        userImage:
                           "assets/user.jpg",
                        child: Center(
                          child: ListView(
                            children: [
                              for (var i = 0; i < filedata.length; i++)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      2.0, 8.0, 2.0, 0.0),
                                  child: ListTile(
                                    leading: GestureDetector(
                                      onTap: () async {
                                        // Display the image in large form.
                                        print("Comment Clicked");
                                      },
                                      child: Container(
                                        height: 50.0,
                                        width: 50.0,
                                        decoration: new BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: new BorderRadius.all(
                                                Radius.circular(50))),
                                        child: CircleAvatar(
                                            radius: 50,
                                            // a changer
                                            backgroundImage: AssetImage(filedata[i].lienImage)),
                                      ),
                                    ),
                                    title: Text(
                                      filedata[i].prenom+" "+filedata[i].nom
                                      ,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(filedata[i].getmessage()),
                                          Row(
                                            children: [
                                              IconButton(
                                                  icon: Icon(
                                                      Icons
                                                          .thumb_up_alt_outlined,
                                                      color:
                                                          filedata[i].getliked()
                                                              ? Colors.green
                                                              : Colors.black),
                                                  onPressed: () async {
                                                    if (filedata[i]
                                                                .getliked() ==
                                                            false &&
                                                        filedata[i]
                                                                .getdislike() ==
                                                            false) {
                                                      await DatabaseService()
                                                          .updateLike(
                                                              filedata[i].commentid,
                                                              true,
                                                              filedata[i].nbrlike,
                                                              widget.titre
                                                              );
                                                      setState(() {});
                                                    } else if (filedata[i]
                                                            .getliked() ==
                                                        true) {
                                                      await DatabaseService()
                                                          .updateLike(
                                                              filedata[i].commentid,
                                                              false,
                                                               filedata[i].nbrlike,
                                                              widget.titre
                                                              );

                                                      setState(() {});
                                                    }
                                                  }),
                                                  Text(filedata[i].nbrlike.toString(),style: TextStyle(
                                                    color: filedata[i].nbrlike == 0 ? Colors.black: Colors.green)
                                                  ),
                                              IconButton(
                                                  icon: Icon(
                                                      Icons
                                                          .thumb_down_alt_outlined,
                                                      color: filedata[i]
                                                              .getdislike()
                                                          ? Colors.red
                                                          : Colors.black),
                                                  onPressed: () async {
                                                    if (filedata[i]
                                                                .getdislike() ==
                                                            false &&
                                                        filedata[i]
                                                                .getliked() ==
                                                            false) {
                                                      await DatabaseService()
                                                          .updateDislike(
                                                             filedata[i].commentid,
                                                              true,
                                                              filedata[i].nbrdislike,
                                                              widget.titre
                                                              );
                                                      setState(() {});
                                                    } else if (filedata[i]
                                                            .getdislike() ==
                                                        true) {
                                                      await DatabaseService()
                                                          .updateDislike(
                                                            filedata[i].commentid,
                                                              false,
                                                              filedata[i].nbrdislike,
                                                              widget.titre
                                                              );
                                                      setState(() {});
                                                    }
                                                  }),
                                                  Text(filedata[i].nbrdislike.toString(),style: TextStyle(
                                                    color: filedata[i].nbrdislike == 0 ? Colors.black: Colors.red)
                                                  ),
                                            ],
                                          )
                                        ]),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        labelText: 'Write a comment...',
                        errorText: 'Comment cannot be blank',
                        withBorder: false,
                        sendButtonMethod: () async {
                          await DatabaseService().comment(widget.titre,commentController.text,"assets/user.jpg");
                            setState(() {
                            });
                            commentController.clear();
                            FocusScope.of(context).unfocus();
                          /* if (formKey.currentState.validate()){
                           await DatabaseService().comment(widget.titre,commentController.text);
                            setState(() {
                            });
                            commentController.clear();
                            FocusScope.of(context).unfocus();
                          } else {
                            print("Not validated");
                          }*/
                        },
                        formKey: formKey,
                        commentController: commentController,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        sendWidget: Icon(Icons.send_sharp,
                            size: 30, color: Colors.white),
                      ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
