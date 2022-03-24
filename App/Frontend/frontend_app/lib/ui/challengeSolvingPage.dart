import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/models/challengeSolving.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/ui/ChallengeSolvingCameraPage.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/ui/institutionProfile.dart';
import 'package:frontend/ui/othersProfilePage.dart';
import 'package:frontend/ui/splash.page.dart';
import 'package:frontend/widgets/circleImageWidget.dart';
import 'package:frontend/models/constants.dart';
import '../services/api.services.dart';
//import 'package:frontend/widgets/solvingPostWidget.dart';

import '../main.dart';

int isSolved = 0;

class ChallengeSolvingPage extends StatefulWidget {
  final int postId;
  final int ownerId;
  final int solved;
  ChallengeSolvingPage(this.postId, this.ownerId, this.solved);
  @override
  _ChallengeSolvingPageState createState() => _ChallengeSolvingPageState(postId, ownerId, solved);
}

class _ChallengeSolvingPageState extends State<ChallengeSolvingPage> {
  int postId;
  int ownerId;
  int solved;
  String textForSolving = "REŠI";
  List<ChallengeSolving> listChallengeSolving;

  final GlobalKey<_SolvingPostWidgetState> _key = GlobalKey();

  _ChallengeSolvingPageState(int postId1, int ownerId1, int solved1) {
    this.postId = postId1;
    this.ownerId = ownerId1;
    this.solved = solved1;
  }

  void _setIsSolved(){
    setState(() {
      if(this.solved == 2)
        isSolved = 0;
      else
        isSolved = 1;
    });
  }
  

  _getChallengeSolving() async {
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getChallengeSolving(jwt, postId, userId).then((res) {
      if(res.statusCode == 200)
        print("RADI MI DOBRO");
      Iterable list = json.decode(res.body);
      List<ChallengeSolving> listP = List<ChallengeSolving>();
      listP = list.map((model) => ChallengeSolving.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listChallengeSolving = listP;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getChallengeSolving();
    _setIsSolved();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: MyApp.ind == 0 ? Colors.white :  Theme.of(context).copyWith().backgroundColor,
          iconTheme: IconThemeData(color: Theme.of(context).copyWith().iconTheme.color),
          actions: <Widget>[
            (isSolved == 0)?
            IconButton(
              icon: Text(
                "REŠI",
                style: TextStyle(color: Color(0xFF00BFA6), fontWeight: FontWeight.bold)
              ),
              onPressed: (){
                _goToCameraPage();
              },
            ):
            Align(
              alignment: Alignment.center,
              child: Text(
                "REŠENO",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 10.0,)
          ],
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, isSolved);
            },
            child: Icon(Icons.arrow_back,
                color: Theme.of(context).copyWith().iconTheme.color,
                size: Theme.of(context).copyWith().iconTheme.size),
          ),
        ),
        body: (listChallengeSolving != null && listChallengeSolving != [] && listChallengeSolving.length != 0) ? 
        ListView.builder(
          padding: EdgeInsets.only(bottom: 30.0),
          itemCount: listChallengeSolving == null ? 0 : listChallengeSolving.length,
          itemBuilder: (BuildContext context, int index) {
            return SolvingPostWidget(listChallengeSolving[index], ownerId, key: RIKeys.riKey1, function: _setIsSolved,);
          }
        )
        : Center(child: Text("Trenutno nema ponuđenih rešenja\npritisnite \"REŠI\" u gornjem desnom uglu")),
    );
  }

  _goToCameraPage() async{
    int result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChallengeSolvingCameraPage(postId, ownerId)),
    );
    
    _getChallengeSolving();
    _getChallengeSolving();
  }
}

class SolvingPostWidget extends StatefulWidget {
  final ChallengeSolving solvingPost;
  final int ownerId;
  final Function() function;

  SolvingPostWidget(this.solvingPost, this.ownerId, {Key key, this.function}) : super(key: key);

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
                if (solvingPost.userId != null && userId != solvingPost.userId)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OthersProfilePage(solvingPost.userId)),
                  );
                else if (solvingPost.institutionId != null)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InstitutionProfile(solvingPost.institutionId)),
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
                if (solvingPost.userId != null && userId != solvingPost.userId)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OthersProfilePage(solvingPost.userId)),
                  );
                else if (solvingPost.institutionId != null)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InstitutionProfile(solvingPost.institutionId)),
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
                        widget.function();
                        setState(() {
                          solvingPost.selected = 1;
                          solvingPost.postStatusId = 1;
                          isSolved = 1;
                          if (publicUser.id == solvingPost.userId){
                            publicUser.points += 10;
                          }
                        });
                       // if(publicUser.id != solvingPost.userId)
                          //sendNotification("Rešenje", "Vaše rešenje je odabrano kao pobedničko",1, solvingPost.userId);
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
                if (solvingPost.userId != null && userId != solvingPost.userId)
                  Navigator.push(
                    context,
                    MaterialPageRoute( builder: (context) => OthersProfilePage(solvingPost.userId)),
                  );
                  else if (solvingPost.institutionId != null)
                  Navigator.push(
                    context,
                    MaterialPageRoute( builder: (context) => InstitutionProfile(solvingPost.institutionId)),
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

class RIKeys {
  static final riKey1 = const Key('__RIKEY1__');
  
}