import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/challangeSolving.dart';
import 'package:frontend_web/models/comment.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewPost.dart';
import 'package:frontend_web/widgets/circleImageWidget.dart';
import 'package:frontend_web/widgets/collapsingInsNavigationDrawer.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';
import 'package:frontend_web/widgets/post/singlePostInsWidget.dart';
import 'package:frontend_web/widgets/post/singlePostWidget.dart';

import 'package:frontend_web/extensions/hoverExtension.dart';

Color greenPastel = Color(0xFF00BFA6);

class ViewPostInsDesktop extends StatefulWidget {

  final FullPost post;
  ViewPostInsDesktop(this.post);

  @override
  _ViewPostDesktopState createState() => _ViewPostDesktopState(post);
}

class _ViewPostDesktopState extends State<ViewPostInsDesktop> {
  FullPost post;
  List<Comment> listComents;
  List<ChallengeSolving> listSolutions;

  _ViewPostDesktopState(FullPost post1){
    this.post = post1;
  }

  _getComms() async {
    APIServices.getComments(TokenSession.getToken, post.postId).then((res) {
      Iterable list = json.decode(res.body);
      List<Comment> listComms = List<Comment>();
      listComms = list.map((model) => Comment.fromObject(model)).toList();
      setState(() {
        listComents = listComms;
      });
    });
  }

  _getSolutions() async {
    APIServices.getChallengeSolving(TokenSession.getToken, post.postId, 0).then((res) {
      Iterable list = json.decode(res.body);
      List<ChallengeSolving> listSol = List<ChallengeSolving>();
      listSol = list.map((model) => ChallengeSolving.fromObject(model)).toList();
      setState(() {
        listSolutions = listSol;
      });
    });
  }

  @override
  initState() {
    super.initState();
    _getComms();
    _getSolutions();
  }

  @override
  Widget build(BuildContext context) {
    
    return Stack(children: <Widget>[
      CenteredViewPost(
          child: TabBarView(
            children: <Widget>[
            Column(children: <Widget>[
              backButton(),
              ListView(children: [SinglePostInsWidget(post)],),
            ],),
            Column(children: <Widget>[
              backButton(),
              Flexible(child: makeCommentsList(listComents)),
            ],),
            Column(children: <Widget>[
              backButton(),
              Flexible(child: makeSolvedPostList(listSolutions)),
            ],),
          ]
          ),
      ),
      CollapsingInsNavigationDrawer(),
      ]
    );
  }

  Widget backButton(){
    return RaisedButton(
      onPressed: (){
        Navigator.pop(context);
      },
      color: greenPastel,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
        side: BorderSide(color: greenPastel)
      ),
      child: Text("Vrati se nazad", style: TextStyle(color: Colors.white),),
    ).showCursorOnHover;
  }

  Widget makeCommentsList(List<Comment> listComments){
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 30.0),
      itemCount: listComments == null ? 0 : listComments.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Row(children: <Widget>[
            CircleImage(
              userPhotoURL + listComents[index].photoPath,
              imageSize: 56.0,
              whiteMargin: 2.0,
              imageMargin: 6.0,
            ),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(listComents[index].username,
                      style:
                          TextStyle(fontWeight: FontWeight.bold)),
                ]),
                Text(listComents[index].description,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 15)
                    )
                
              ],
            )),
            SizedBox(width: 10,)
          ],),
        );
      }
    );
  }

  Widget makeSolvedPostList(List<ChallengeSolving> listSolutions){
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 30.0),
      itemCount: listSolutions == null ? 0 : listSolutions.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Row(children: <Widget>[
            Container(
              constraints: BoxConstraints(
                maxHeight: 300.0, // changed to 400
                minHeight: 100.0, // changed to 200
                maxWidth: 300,
                minWidth: 300,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey[200],
                    width: 1.0,
                  ),
                ),
              ),
              child: Image(image: NetworkImage(userPhotoURL + listSolutions[index].solvingPhoto)),
            ),
            Expanded(child: Container(
              constraints: BoxConstraints(
                maxHeight: 180,
                minHeight: 100,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleImage(
                        userPhotoURL + listSolutions[index].userPhoto,
                        imageSize: 36.0,
                        whiteMargin: 2.0,
                        imageMargin: 6.0,
                      ),
                      Text(
                        (listSolutions[index].username.length > 15) ? listSolutions[index].username.substring(0,15).replaceRange(13,15, "...") : listSolutions[index].username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: SizedBox()),
                      (listSolutions[index].selected == 1)
                      ?
                      Text(
                        "REŠENJE",
                        style: TextStyle(color: greenPastel, fontWeight: FontWeight.bold),
                      ):
                      SizedBox(),
                      SizedBox(width: 10,)
                    ],
                  ),
                  Expanded(child:SizedBox()),
                  Row(children: <Widget>[
                    SizedBox(width: 10,),
                    Flexible(
                    child: Text(post.description),
                  ),
                  ],),
                  Expanded(child:SizedBox()),
                ],
              )
            )),
          ],)
        );
      }
    );
  }
}