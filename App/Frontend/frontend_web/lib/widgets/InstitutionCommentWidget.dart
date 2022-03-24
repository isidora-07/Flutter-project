import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/comment.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:http/http.dart' as http;
import 'circleImageWidget.dart';


class InstitutionCommentWidget extends StatefulWidget {
  final int postId;
  InstitutionCommentWidget(this.postId);

  @override
  _InstitutionCommentWidgetState createState() => _InstitutionCommentWidgetState(postId);

}

class _InstitutionCommentWidgetState extends State<InstitutionCommentWidget> {
  int postId;

  _InstitutionCommentWidgetState(int id)
  {
    this.postId = id;
  }

  List<Comment> listComments;
  //get comments for specific post id
  _getComments(int postId) {
    APIServices.getComments(TokenSession.getToken, postId).then((res) {
      Iterable list = json.decode(res.body);
      List<Comment> listComms = List<Comment>();
      listComms = list.map((model) => Comment.fromObject(model)).toList();

      if(mounted)
      {
        setState(()
        {
          listComments = listComms;
        });
      }
    });
  }

  @override
  void initState()
  {
    _getComments(this.postId);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return buildCommentList();
  }

  //building comment list
  Widget buildCommentList() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: listComments == null ? 0 : listComments.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 5),
                      child: Row(children: [
                        CircleImage(
                          "http://127.0.0.1:60676//" + listComments[index].photoPath,
                          imageSize: 56.0,
                          whiteMargin: 2.0,
                          imageMargin: 6.0,
                        ),
                        Container(
                          width: 260,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Text(listComments[index].username,
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Expanded(child: SizedBox()),
                              ]),
                              Text(listComments[index].description,
                                  style: TextStyle( fontStyle: FontStyle.italic, fontSize: 15))
                            ],
                          ),
                        ),
                        Expanded(child: SizedBox()),

                      ])
                  ),
                ],
              ),
            ));
      },
    );
  }
}