import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/models/comment.dart';
import 'package:frontend/models/constants.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/widgets/circleImageWidget.dart';
import 'dart:convert';

import '../main.dart';
import 'homePage.dart';

class CommentsPage extends StatefulWidget {
  final int postId;
  CommentsPage(this.postId);

  @override
  State<StatefulWidget> createState() {
    return StateComents(postId);
  }
}

class StateComents extends State<CommentsPage> {
  int postId;
  Comment comment;
  StateComents(int id) {
    postId = id;
  }

  List<Comment> listComents;
  _getComms() async {
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getComments(jwt, postId).then((res) {
      //umesto 1 stavlja se idPosta
      Iterable list = json.decode(res.body);
      List<Comment> listComms = List<Comment>();
      listComms = list.map((model) => Comment.fromObject(model)).toList();
      setState(() {
        listComents = listComms;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getComms();
  }

  void choiceActionDelete(String choice) {
    if (choice == ConstantsCommentDelete.ObrisiKomentar) {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text(
              "Brisanje komentara?",
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Izbriši",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color),
                ),
                onPressed: () {
                  APIServices.jwtOrEmpty().then((res) {
                    String jwt;
                    setState(() {
                      jwt = res;
                    });
                    if (res != null) {
                      print("Delete comment" + comment.id.toString());
                      APIServices.deleteComment(jwt, comment.id).then((res) {
                        if (res.statusCode == 200) {
                          setState(() {
                            _getComms();
                          });
                        }
                      });
                    }
                  });
                  _getComms();
                  _getComms();
                  print('Uspešno ste izbrisali objavu.');
                  Navigator.of(context).pop();
                  _getComms();
                  _getComms();
                },
              ),
                FlatButton(
                child: Text(
                  "Otkaži",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2.color),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
    }
  }

  void choiceAction(String choice) {
    if (choice == ConstantsComment.PrijaviKomentar) {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text(
              "Želite da prijavite komentar?",
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
            ),
            actions: <Widget>[
               FlatButton(
                child: Text(
                  "Prijavi",
                  style:TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
                ),
                onPressed: () {
                  APIServices.jwtOrEmpty().then((res) {
                    String jwt;
                    setState(() {
                      jwt = res;
                    });
                    if (res != null) {
                      APIServices.addReportComment(jwt, comment.id, userId)
                          .then((res) {
                        if (res.statusCode == 200) {
                          print('Uspešno ste prijavili komentar.');
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(
                              msg: "Uspešno ste prijavili komentar.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0,
                              timeInSecForIos: 2);
                        } else {
                          print('Već ste prijavili komentar.');
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(
                              msg: "Već ste prijavili komentar.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                              timeInSecForIos: 2);
                        }
                      });
                    }
                  });
                },
              ),
              FlatButton(
                child: Text(
                  "Otkaži",
                  style:TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
    }
  }

  TextEditingController myController = new TextEditingController();
  Widget buildCommentList() {
    return Container(
        color: MyApp.ind == 0 ? Colors.white : Colors.grey[800],
        child: ListView.builder(
          itemCount: listComents == null ? 0 : listComents.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              width : MediaQuery.of(context).size.width - 10,
               child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 5),
                      child: Row(children: [
                        CircleImage(
                          serverURLPhoto + listComents[index].photoPath,
                          imageSize: 35.0,
                          whiteMargin: 2.0,
                          imageMargin: 6.0,
                        ),
                        Container(
                          //OBRISATI AKO NE VALJA
                          color:
                              MyApp.ind == 0 ? Colors.white : Colors.grey[600],
                          width: 240,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Text(listComents[index].username,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Expanded(child: SizedBox()),
                              ]),
                              Text(listComents[index].description,
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15))
                            ],
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Flexible(
                          child:
                              /*IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () {

                        },
                      ),*/
                              (listComents[index].userId != userId)
                                  ? PopupMenuButton<String>(
                                      onSelected: choiceAction,
                                      itemBuilder: (BuildContext context) {
                                        setState(() {
                                          comment = listComents[index];
                                        });
                                        return ConstantsComment.choices
                                            .map((String choice) {
                                          return PopupMenuItem<String>(
                                            value: choice,
                                            child: Text(choice),
                                          );
                                        }).toList();
                                      },
                                    )
                                  : PopupMenuButton<String>(
                                      onSelected: choiceActionDelete,
                                      itemBuilder: (BuildContext context) {
                                        setState(() {
                                          comment = listComents[index];
                                        });
                                        return ConstantsCommentDelete.choices
                                            .map((String choice) {
                                          return PopupMenuItem<String>(
                                            value: choice,
                                            child: Text(choice),
                                          );
                                        }).toList();
                                      },
                                    ),
                        ),
                        SizedBox(width: 5,)
                      ])),
                ],
              ),
            ));
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyApp.ind == 0
            ? Colors.white
            : Theme.of(context).copyWith().backgroundColor,
        iconTheme: IconThemeData(
            color: Theme.of(context).copyWith().iconTheme.color,
            size: Theme.of(context).copyWith().iconTheme.size),
        title: Text('Komentari',
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context, listComents.length);
          },
          child: Icon(Icons.arrow_back,
              color: Theme.of(context).copyWith().iconTheme.color,
              size: Theme.of(context).copyWith().iconTheme.size),
        ),
      ),
      body: Container(
          color: MyApp.ind == 0 ? Colors.white : Colors.grey[600],
          padding: EdgeInsets.only(top: 0),
          child: Column(children: [
            Flexible(child: buildCommentList()),
            Row(
              children: <Widget>[
                SizedBox(width: 10),
                Icon(
                  Icons.account_circle,
                  color: Theme.of(context).copyWith().iconTheme.color,
                  size: 36,
                ),
                Flexible(
                  child: TextFormField(
                    cursorColor: MyApp.ind == 0 ? Colors.black : Colors.white,
                    controller: myController,
                    maxLength: 150,
                    decoration: InputDecoration(
                      hoverColor: Colors.grey,
                      labelText: 'Dodaj komentar...',
                      labelStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1.color,
                          fontStyle: FontStyle.italic),
                      fillColor: Theme.of(context).textTheme.bodyText1.color,
                      contentPadding: const EdgeInsets.all(10.0),
                    ),
                  ),
                ), //COMMENT INPUT
                RaisedButton(
                  //splashColor: Colors.black,
                  elevation: 7,
                  padding: const EdgeInsets.all(10.0),
                  color: Color(0xFF00BFA6),
                  child: Text(
                    'Komentariši',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color),
                  ),
                  //post comment
                  onPressed: () {
                    if (myController.text != "") {
                      APIServices.jwtOrEmpty().then((res) {
                        String jwt;
                        setState(() {
                          jwt = res;
                        });
                        if (res != null) {
                          print(myController.text);
                          APIServices.addComment(
                                  jwt, myController.text, userId, postId)
                              .then((res) {
                            setState(() {
                              _getComms();
                              myController.text = "";
                              FocusScopeNode currentFocus = FocusScope.of(context);
                               if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                               }
                            });
                          });
                        }
                      });
                    }
                    _getComms();
                  },
                ),
                SizedBox(width: 10),
              ],
            )
          ])),
    );
  }
}
