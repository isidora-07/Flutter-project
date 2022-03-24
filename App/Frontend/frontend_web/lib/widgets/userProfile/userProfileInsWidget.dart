import 'package:flutter/material.dart';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/services/api.services.dart';

import 'package:frontend_web/extensions/hoverExtension.dart';

Color greenPastel = Color(0xFF00BFA6);

class UserInfoInsWidget extends StatefulWidget {
  final User user; //profilePage User or others User's profile
  UserInfoInsWidget(this.user);

  @override
  _UserInfoInsWidgetState createState() => _UserInfoInsWidgetState(user);
}

class _UserInfoInsWidgetState extends State<UserInfoInsWidget> {
  User user;
  int userKind;

  _UserInfoInsWidgetState(User user1) {
    this.user = user1;
  }
  int points;
  String text1="Poeni";
  @override
  void initState() {
    super.initState();
    setState(() {
      points = user.points;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget stats(String statName, int statCount) {
      return Column(
        children: <Widget>[
          Text(
            statCount.toString(),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          Text(statName, style: TextStyle(color: Colors.black)),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.black26,
            width: 1.0,
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[
                RaisedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  color: greenPastel,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: greenPastel)
                  ),
                  child: Text("Vrati se nazad", style: TextStyle(color: Colors.white),),
                ).showCursorOnHover,
                Expanded(child: SizedBox(),),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: <Widget>[
                userImageWithPlus(),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        user.firstName + ' ' + user.lastName,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Lokacija: ' + user.cityName,
                        style: TextStyle(
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            //Name
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Objave",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text("${user.postsNum}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Expanded(
                    child: SizedBox(
                  width: 2,
                )),
                InkWell(
                 child:   Column(
                  children: <Widget>[
                    Text(text1,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Text(points.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold))
                  ],
                ),
                   onTap: () {
                     if(text1 == "Poeni")
                    {
                      setState(() {
                       text1 = "Donirani";
                      points = user.donatedPoints;
                      }); 
                    }
                    else
                    {
                      setState(() {
                       text1 = "Poeni";
                      points = user.points;
                      });
                    }
                   },
                ),
                Expanded(
                    child: SizedBox(
                  width: 2,
                )),
                Column(
                  children: <Widget>[
                    Text("Nivo",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Text("${user.level}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold))
                  ],
                )
              ],
            ),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                stats('Objave', user.postsNum, ),
                stats('Poeni', user.points),
                stats('Nivo', user.level),
              ],
            ),*/
            SizedBox(height: 4.0),
            // For padding
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget userImageWithPlus() => Stack(
        children: <Widget>[
          Container(
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(userPhotoURL + user.photo),
              ),
            ),
          )
        ],
      );
}
