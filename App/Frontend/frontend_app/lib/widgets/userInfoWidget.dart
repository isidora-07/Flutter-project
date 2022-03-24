import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/api.services.dart';

import '../main.dart';

class UserInfoWidget extends StatefulWidget {
  final User user; //profilePage User or others User's profile
  UserInfoWidget(this.user);

  @override
  _UserInfoWidgetState createState() => _UserInfoWidgetState(user);
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  User user;
  int userKind;
  
  _UserInfoWidgetState(User user1) {
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
              color: Theme.of(context).textTheme.bodyText1.color,
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
        color: MyApp.ind == 0 ? Colors.white :  Theme.of(context).copyWith().backgroundColor,
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
                          color: Theme.of(context).textTheme.bodyText1.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Lokacija: ' + user.cityName,
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color),
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
                          color: Theme.of(context).textTheme.bodyText1.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text("${user.postsNum}",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color,
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
                            color: Theme.of(context).textTheme.bodyText1.color,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Text(points.toString(),
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color,
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
                            color: Theme.of(context).textTheme.bodyText1.color,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Text("${user.level}",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color,
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
                image: NetworkImage(serverURLPhoto + user.photo),
              ),
            ),
          )
        ],
      );
}
