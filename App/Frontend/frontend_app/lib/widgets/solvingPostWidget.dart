import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/models/challengeSolving.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/ui/challengeSolvingPage.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/ui/othersProfilePage.dart';
import 'package:frontend/widgets/circleImageWidget.dart';
import 'package:frontend/models/constants.dart';
import '../services/api.services.dart';

class SolvingPostWidget extends StatefulWidget {
  final ChallengeSolving solvingPost;
  final int ownerId;

  SolvingPostWidget(this.solvingPost, this.ownerId);

  @override
  _SolvingPostWidgetState createState() => _SolvingPostWidgetState(solvingPost, ownerId);
}

class _SolvingPostWidgetState extends State<SolvingPostWidget> {
  ChallengeSolving solvingPost;
  int ownerId;
  _SolvingPostWidgetState(ChallengeSolving solvingPost1, int ownerId1) {
    this.solvingPost = solvingPost1;
    this.ownerId = ownerId1;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (solvingPost == null) ? Center() : newPost(); //buildPostList()
  }

  Widget newPost() {
    return Card(
        child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          userInfoRow(),
          imageGallery(),
          SizedBox(height: 10.0),
          description(),
          SizedBox(height: 10.0),
        ]));
  }

  Widget userInfoRow() =>
      Row(
        children: <Widget>[
          InkWell(
              onTap: () {
                if (userId != solvingPost.userId)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OthersProfilePage(solvingPost.userId)),
                  );
              },
              child: CircleImage(
                serverURLPhoto + solvingPost.userPhoto,
                imageSize: 36.0,
                whiteMargin: 2.0,
                imageMargin: 6.0,
              )),
          InkWell(
              onTap: () {
                if (userId != solvingPost.userId)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OthersProfilePage(solvingPost.userId)),
                  );
              },
              child: Text(
                solvingPost.username,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Expanded(child: SizedBox()),
          (solvingPost.selected == 1)
          ?
          Text(
            "REŠENJE",
            style: TextStyle(color:Color(0xFF00BFA6), fontWeight: FontWeight.bold),
          ):
          SizedBox(),
          (ownerId == userId)
          ? PopupMenuButton<String>(
            onSelected: choiceActionSolvingDelete,
            itemBuilder: (BuildContext context) {
              return ConstantsChallengeSolvingDelete.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ): SizedBox(),
          (ownerId != userId && solvingPost.userId == userId)
          ?
          PopupMenuButton<String>(
            onSelected: choiceActionSolvingDelete,
            itemBuilder: (BuildContext context) {
              return ConstantsChallengeDelete.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ): SizedBox(),
        ],
      );

  void choiceActionSolvingDelete(String choice) {
    if (choice == ConstantsChallengeSolvingDelete.IzbrisiResenje) {
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Brisanje rešenja?"),
          actions: <Widget>[
                FlatButton(
              child: Text(
                "Izbriši",
                style:TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
              ),
              onPressed: () {
                APIServices.jwtOrEmpty().then((res) {
                  String jwt;
                  setState(() {
                    jwt = res;
                  });
                  if (res != null) {
                    APIServices.challengeSolvingDelete(jwt, solvingPost.id).then((res){
                      if(res.statusCode == 200){
                        print('Uspešno ste izbrisali rešenje.');
                        setState(() {
                          solvingPost = null;
                        });
                      }
                    });
                    
                  }
                });
                Navigator.of(context).pop();
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
    }else if(choice == ConstantsChallengeSolvingDelete.IzaberiResenje){
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Prihvati rešenje?"),
          actions: <Widget>[
                FlatButton(
              child: Text(
                "Izaberi",
                style:TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
              ),
              onPressed: () {
                APIServices.jwtOrEmpty().then((res) {
                  String jwt;
                  setState(() {
                    jwt = res;
                  });
                  if (res != null) {
                    APIServices.challengeSolving(jwt, solvingPost.id, solvingPost.postId).then((res){
                      if(res.statusCode == 200){
                        print('Uspešno ste izabrali rešenje.');
                        setState(() {
                          solvingPost.selected = 1;
                          solvingPost.postStatusId = 1;
                          isSolved = 1;
                        });
                      }
                    });
                    
                  }
                });
                Navigator.of(context).pop();
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
    }else if(choice == ConstantsChallengeDelete.IzbrisiSvojeResenje){
      showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Brisanje rešenja?"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Izbriši",
                style:TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
              ),
              onPressed: () {
                APIServices.jwtOrEmpty().then((res) {
                  String jwt;
                  setState(() {
                    jwt = res;
                  });
                  if (res != null) {
                    APIServices.challengeSolvingDelete(jwt, solvingPost.id).then((res){
                      if(res.statusCode == 200){
                        print('Uspešno ste izbrisali rešenje.');
                        setState(() {
                          solvingPost = null;
                        });
                      }
                    });
                    
                  }
                });
                Navigator.of(context).pop();
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

  

  Widget imageGallery() => Container(
        constraints: BoxConstraints(
          maxHeight: 300.0, // changed to 400
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
        child: Image(image: NetworkImage(serverURLPhoto + solvingPost.solvingPhoto)),
      );

  Widget description() =>
      Container(
          child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          InkWell(
              onTap: () {
                if (userId != solvingPost.userId)
                  Navigator.push(
                    context,
                    MaterialPageRoute( builder: (context) => OthersProfilePage(solvingPost.userId)),
                  );
              },
              child: Text(solvingPost.username, style: TextStyle(fontWeight: FontWeight.bold))),
          SizedBox(
            width: 10,
          ),
          Flexible(child: Text(solvingPost.description),
          )
        ],
      ));
}