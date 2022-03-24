import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:frontend/models/notification.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/ui/challengeSolvingPage.dart';
import 'package:frontend/ui/splash.page.dart';
import 'package:frontend/widgets/circleImageWidget.dart';

import '../main.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPage createState() => _NotificationPage();
}

class _NotificationPage extends State<NotificationPage> {
  List<NotificationModel> listN;

  _getNot() async {
    if (publicUser != null) {
      var jwt = await APIServices.jwtOrEmpty();
      APIServices.getNotificationForUser(jwt, publicUser.cityId).then((res) {
        Iterable list = json.decode(res.body);
        List<NotificationModel> listP = List<NotificationModel>();
        listP =
            list.map((model) => NotificationModel.fromObject(model)).toList();
        if (mounted) {
          setState(() {
            listN = listP;
          });
        }
      });
    }
  }

  void initState() {
    super.initState();
    _getNot();
  }


    Widget buildNotificationList() {
    return ListView.builder(
      itemCount: listN == null ? 0 : listN.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          width : MediaQuery.of(context).size.width - 10,
            child: Center(
          child: Column(
           
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  color: MyApp.ind == 0 ? Colors.white : Colors.grey[600],
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    listN[index].typeNotification != 2 ?
                    CircleImage(
                      serverURLPhoto + listN[index].userPhoto,
                      imageSize: 30.0,
                      whiteMargin: 2.0,
                      imageMargin: 6.0,
                    ): 
                    Container(
                      child: Image.asset("assets/seo-and-web.png",width: 40, height: 40,)
                    )
                    ,
                    Container(
                      width: 220,
                      padding: EdgeInsets.all(10),
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          listN[index].typeNotification == 1 ?
                         Flexible(child: Text("Korisnik " + listN[index].username + " je postavio predlog rešenja za Vaš problem "))
                         : listN[index].typeNotification == 2 ?
                         Flexible(child: Text("Čestitamo! Vaše rešenje je odabrano kao pobedničko. Dobili ste 10 poena"))
                         : listN[index].typeNotification == 4 ?
                         Flexible(child: Text("Korisnik " + listN[index].username + " je pozitivno reagovao na Vašu objavu"))
                         : listN[index].typeNotification == 3 ?
                         Flexible(child: Text("Korisnik " + listN[index].username + " je negativno reagovao na Vašu objavu"))
                         : 
                         Flexible(child: Text("Korisnik " + listN[index].username + " je komentarisao Vašu objavu")),
                        ],
                      ),
                      SizedBox(height: 3,),
                      Text(listN[index].createdAtString , style: TextStyle(fontStyle: FontStyle.italic),)])
                    ),
                  Container(
                  width: 70,
                  height: 45,
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      shape: BoxShape.rectangle,
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(serverURLPhoto + listN[index].photoPath),
                  )),
            )
                  ])),
            ],
          ),
        ));
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: Theme.of(context).copyWith().iconTheme.color),
        title: Text('Obaveštenja',
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
        backgroundColor: MyApp.ind == 0
            ? Colors.white
            : Theme.of(context).copyWith().backgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(
              context,
            );
          },
          child: Icon(Icons.arrow_back,
              color: Theme.of(context).copyWith().iconTheme.color,
              size: Theme.of(context).copyWith().iconTheme.size),
        ),
      ),
      body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: (listN != null)
              ? Center(
                  child: Container(
                  padding: EdgeInsets.only(top: 0),
                  color: MyApp.ind == 0 ? Colors.white : Colors.grey[800],
                  child: Column(children: [
                    Flexible(child: buildNotificationList()),
                  ])),)
              : Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Color(0xFF00BFA6)),
                  ),
                )),
    );
  }

    Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 3));
    setState(() {
      listN = [];
    });
    _getNot();
    return null;
  }
}

