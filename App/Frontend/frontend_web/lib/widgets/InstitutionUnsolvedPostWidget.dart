import 'package:flutter/material.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/InstitutionPages/solvePage/solvePage.dart';
import 'package:frontend_web/widgets/InstitutionCommentWidget.dart';
import 'package:frontend_web/widgets/circleImageWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:frontend_web/extensions/hoverExtension.dart';

Color greenPastel = Color(0xFF00BFA6);

class InstitutionUnsolvedPostWidget extends StatefulWidget {
  final FullPost posts;
  final int id;

  InstitutionUnsolvedPostWidget({Key key, this.posts, this.id});

  @override
  _InstitutionUnsolvedPostWidgetState createState() => _InstitutionUnsolvedPostWidgetState(posts);
}

class _InstitutionUnsolvedPostWidgetState extends State<InstitutionUnsolvedPostWidget> {
  FullPost post;


  _InstitutionUnsolvedPostWidgetState(FullPost post1) {
    this.post = post1;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (post == null) ? Center() : unsolvedPost(); //buildPostList()
  }

  showCommentsDialog(BuildContext context, int id) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Zatvori", style: TextStyle(color: greenPastel),),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      actions: [
        InstitutionCommentWidget(id),
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  Widget unsolvedPost() {
    return Card(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              userInfoRow(post.username,
                  post.typeName, post.userPhoto, post.postId, widget.id),
              imageGallery(post.photoPath),
              SizedBox(height: 2.0),
              actionsButtons(
                  post.statusId,
                  post.postId,
                  post.likeNum,
                  post.dislikeNum,
                  post.commNum,
              ),
              description(
                  post.username, post.description, post.address),
              SizedBox(height: 6.0),

            ]
        )
    );
  }

  Widget userInfoRow(String username, String category, String userPhoto, int postId, int instId) => Row(
    children: <Widget>[
      CircleImage(
        userPhotoURL + userPhoto,
        imageSize: 36.0,
        whiteMargin: 2.0,
        imageMargin: 6.0,
      ),
      Text(
        username,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Expanded(child: SizedBox()),
      Text(category),
      SizedBox(width: 15,),
      FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(11.0),
            side: BorderSide(color: Colors.redAccent)),
        color: Colors.redAccent,
        child: Text(
          "Reši",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InstitutionSolvePage(postId: postId, id: instId)),
          );
        },
      )
    ],
  );

  Widget imageGallery(String image) => Container(
    constraints: BoxConstraints(
      maxHeight: 400.0, // changed to 400
      minHeight: 200.0, // changed to 200
      maxWidth: double.infinity,
      minWidth: double.infinity,
    ),
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(
          color: Colors.grey[200],
          width: 1.0,
        ),
      ),
    ),
    child: Image(image: NetworkImage(userPhotoURL + image)),
  );

  Widget actionsButtons(
      int statusId, int postId, int likeNum, int dislikeNum, int commNum) =>
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Actions buttons/icons
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(MdiIcons.thumbUpOutline, color: greenPastel),
                onPressed: () {
                  APIServices.addLike(TokenSession.getToken,postId, 1, 2);
                },
              ),
              GestureDetector(
                onTap: () {},
                child: Text(likeNum.toString()),
              ),
              IconButton(
                icon: Icon(MdiIcons.thumbDownOutline, color: Colors.red),
                onPressed: () {
                  APIServices.addLike(TokenSession.getToken,postId, 1, 1);
                },
              ),
              GestureDetector(
                onTap: () {},
                child: Text(dislikeNum.toString()),
              ),
              IconButton(
                icon: Icon(Icons.chat_bubble_outline, color: greenPastel),
                onPressed: () {
                  showCommentsDialog(context, postId);
                },
              ).showCursorOnHover,
              Text(commNum.toString()),
              Expanded(child: SizedBox()),
              SizedBox(width: 10.0), // For padding
            ],
          ),
        ],
      );


  Widget description(String username, String description, String address) => Container(
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(description + " \n\nLokacija: " + address),
          )
        ],
      ));
}
