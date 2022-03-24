import 'package:flutter/material.dart';
import 'package:frontend/models/like.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/ui/othersProfilePage.dart';
import 'package:frontend/widgets/circleImageWidget.dart';
import 'dart:convert';

import '../main.dart';

class Top10Page extends StatefulWidget {
  final User user;
  Top10Page(this.user);

  @override
  State<StatefulWidget> createState() {
    return StateTop10(user);
  }
}

class StateTop10 extends State<Top10Page> {
  User user;
  StateTop10(User u) {
    user = u;
  }
  List<User> listUsers;


  _getTop10() async {
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getTop10(jwt, user.cityId).then((res) {
      //umesto 1 stavlja se idPosta
      Iterable list = json.decode(res.body);
      List<User> listU = List<User>();
      listU = list.map((model) => User.fromObject(model)).toList();
      setState(() {
        listUsers = listU;
      });
    });
  }

  void initState() {
    super.initState();
    _getTop10();
  }

  Widget buildList() {
    return ListView.builder(
      itemCount: listUsers == null ? 0 : listUsers.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: (){
            if(userId != listUsers[index].id){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OthersProfilePage(listUsers[index].id)),
                );
            }
          },
          child: Container(
            child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  color: MyApp.ind == 0 && listUsers[index].id == user.id ? Colors.lightGreen[100] : MyApp.ind == 0 ? Colors.white :listUsers[index].id == user.id ? Colors.lightGreen[300] : Colors.grey[600],
                  padding: EdgeInsets.only(top:5, left: 15, right: 15, bottom: 5),
                  margin: EdgeInsets.only(top:5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,               
                    children: [                    
                   Row(children: <Widget>[
                      Text((index+1).toString(), style: TextStyle(color:  MyApp.ind == 0 ? Color(0xFF00BFA6): Colors.white, fontSize: 15, fontWeight: FontWeight.w600),),
                    CircleImage(
                      serverURLPhoto + listUsers[index].photo,
                      imageSize: 52.0,
                      whiteMargin: 2.0,
                      imageMargin: 6.0,
                    ),
                    Container(
                      width: 150,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(listUsers[index].username,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                              listUsers[index].firstName +
                                  " " +
                                  listUsers[index].lastName,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 15))
                        ],

                      ),
                    ),
                    ],),
                    Container(
                   child: index == 0 ? Image.asset("assets/gold-medal.png",width: 40, height: 40,) : index == 1 ? Image.asset("assets/silver-medal.png",width: 40, height: 40,) : index == 2 ? Image.asset("assets/medal3.png",width: 40, height: 40,) : Container(),
                    ),
                  Text((listUsers[index].points+listUsers[index].donatedPoints).toString(), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),),
                  
                  ])),
            ],
          ),
        )),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                  color: Theme.of(context).copyWith().iconTheme.color),
              title: Text('Top 10',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color)),
              backgroundColor: MyApp.ind == 0
                  ? Colors.white
                  : Theme.of(context).copyWith().backgroundColor,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            body: Container(
                  padding: EdgeInsets.only(top: 0),
                  color: MyApp.ind == 0 ? Colors.white : Colors.grey[800],
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment:  MainAxisAlignment.center,
                      children: <Widget>[
                      Image.asset("assets/podium.png",width: 50, height: 50),
                      SizedBox(width: 20,),
                      Text("Najaktivniji korisnici u Vašem gradu", style:  TextStyle(fontSize: 16, fontWeight: FontWeight.w600),)
                    ],),
                    ),
                    Flexible(child: buildList()),
                  ])),
            )
            );
  }
}
