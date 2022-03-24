import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/event.dart';
import 'package:frontend_web/models/institution.dart';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/extensions/hoverExtension.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/InstitutionPages/eventsPage/eventsPage.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/homePage.dart';
import 'package:frontend_web/widgets/collapsingInsNavigationDrawer.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../../../editEventPage.dart';

Color greenPastel = Color(0xFF00BFA6);

class ViewEventInsDesktop extends StatefulWidget {
  final Events event;
  ViewEventInsDesktop(this.event);

  @override
  _ViewEventInsDesktopState createState() => _ViewEventInsDesktopState(event);
}

class _ViewEventInsDesktopState extends State<ViewEventInsDesktop> {
  List<User> usersForEvent;
  List<Institution> institutionsForEvent;
  Events event;

  _ViewEventInsDesktopState(Events event){
    this.event = event;
  }

  _listUsersForEvent() async{
    APIServices.getUsersForEvent(TokenSession.getToken, event.id).then((res) {
      Iterable list = json.decode(res.body);
      List<User> users;
      users = list.map((model) => User.fromObject(model)).toList();
      if(mounted)
      {
        setState(() {
          usersForEvent = users;
        });
      }
    });
  }

  _listInstitutionsForEvent() async{
    APIServices.getInstitutionsForEvent(TokenSession.getToken, event.id).then((res) {
      Iterable list = json.decode(res.body);
      List<Institution> institutions;
      institutions = list.map((model) => Institution.fromObject(model)).toList();
      if(mounted)
      {
        setState(() {
          institutionsForEvent = institutions;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _listUsersForEvent();
    _listInstitutionsForEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 30.0),
            alignment: Alignment.topCenter,
            child: ConstrainedBox(child: Column(children: <Widget>[
              buttonsRow(event),
              titleColumn(event.title, event.description),
              SizedBox(height: 10.0,),
              startEndDateRow(event),
              SizedBox(height: 8.0,),
              locationRow(event),
              SizedBox(height: 12.0),
              (usersForEvent==null || usersForEvent.length==0) ? Text("Nema prijavljenih korisnika za ovaj događaj.", style: TextStyle(fontSize: 18.0),) : Text("Broj prijavljenih korisnika: " + usersForEvent.length.toString(), style: TextStyle(fontSize: 18.0),),
              usersForEvent!=null ? listUsers() : SizedBox(),
              (institutionsForEvent==null || institutionsForEvent.length==0) ? Text("Nema prijavljenih institucija za ovaj događaj.", style: TextStyle(fontSize: 18.0),) : Text("Broj prijavljenih institucija: " + institutionsForEvent.length.toString(), style: TextStyle(fontSize: 18.0),),
              institutionsForEvent!=null ? listInstitutions() : SizedBox(),
            ],),
            constraints: BoxConstraints(maxWidth: 800),
            ),
          ),
          CollapsingInsNavigationDrawer(),
        ],
      ),
      );
  }
  
Widget titleColumn(String title, String description) {
    return Column(children: <Widget>[
      SizedBox(height: 20.0,),
      Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),),
      description==null ? Text("") : Text(description, style: TextStyle(fontSize: 22.0),),
    ],);
  }

  Widget startEndDateRow(Events event) {
    return Row(children: <Widget>[
      SizedBox(width: 15.0),
      Column(children: [
        Text("Počinje:", style: TextStyle(fontSize: 18.0),),
        Text(event.startDate, style: TextStyle(fontSize: 18.0),)
      ],),
      Expanded(child: SizedBox()),
      Column(children: [
        Text("Završava se:", style: TextStyle(fontSize: 18.0),),
        Text(event.endDate, style: TextStyle(fontSize: 18.0),)
      ],),
      SizedBox(width: 15.0,),
    ],);
  }

  Widget locationRow(Events event) {
    return Row(children: <Widget>[
      SizedBox(width: 10.0,),
      Icon(Icons.location_on),
      Flexible(child: Text(event.address, style: TextStyle(fontSize: 18.0),),),
    ],);
  }

  Widget buttonsRow(Events event) {
    return Row(children: <Widget>[
      SizedBox(width: 15.0,),
      RaisedButton(
        child: Text("Vrati se nazad", style: TextStyle(color: Colors.white),),
        color: greenPastel,
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0)),
          onPressed: (){
            Navigator.pop(context, event.isGoing);
          }).showCursorOnHover,
      Expanded(child: SizedBox()),
      event.institutionId==insId 
        ? Row(children: <Widget>[
          editButton(event),
          SizedBox(width: 10.0,),
          deleteButton(event),
        ],)
        : event.isGoing == 1 ? cancelButton() : joinButton(),
    ]);
  }

  Widget editButton(event) {
    return RaisedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditEventPage(event)),
          );
        },
        color: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0),),
        child: Text("Izmeni", style: TextStyle(color: Colors.white,),),
      ).showCursorOnHover;
  }

  Widget deleteButton(Events event) {
    return RaisedButton(
        child: Text("Obriši", style: TextStyle(color: Colors.white),),
        color: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0),),
        onPressed: () {
          showAlertDialog(event.id);
        },
      ).showCursorOnHover;
  }

  Widget joinButton() {
    return RaisedButton(
      onPressed: () {
        APIServices.joinEvent(TokenSession.getToken, event.id, insId).then((res) {
          if(res.statusCode == 200) {
            setState(() {
              event.isGoing = 1;
              _listInstitutionsForEvent();
            });
          }
        });
      },
      child: Text("Pridruži se", style: TextStyle(color: Colors.white),),
      shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0)),
      color: Colors.blue,
    ).showCursorOnHover;
  }

  Widget cancelButton() {
    return RaisedButton(
      child: Text("Otkaži", style: TextStyle(color: Colors.white)),
      shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0)),
      onPressed: () {
        APIServices.leaveEvent(TokenSession.getToken, event.id, insId).then((res) {
          if(res.statusCode == 200) {
            setState(() {
              event.isGoing = 0;
              _listInstitutionsForEvent();
            });
          }
        });
      },
      color: Colors.red,
    ).showCursorOnHover;
  }

  showAlertDialog(int eventId) {
    
    final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();
    
    void _doSomething() async {
      APIServices.removeEvent(TokenSession.getToken, eventId).then((res) {
          if(res.statusCode == 200){
            print("Događaj je uspešno obrisan.");
          }
        });
      Timer(Duration(seconds: 1), () {
          _btnController.success();
          Navigator.pushReplacement(context, 
            MaterialPageRoute(builder: (context) => EventsPage()),
          );
      });
    }
    
    Widget okButton = RoundedLoadingButton(
      child: Text("Obriši", style: TextStyle(color: Colors.white),),
      controller: _btnController,
      color: Colors.red,
      width: 60,
      height: 40,
      onPressed: _doSomething,
    );

    Widget notButton = RoundedLoadingButton(
       color:greenPastel,
       width: 60,
       height: 40,
       child: Text("Otkaži", style: TextStyle(color: Colors.white),),
      onPressed: () {
        Navigator.pop(context);
        },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Brisanje događaja"),
      content: Text("Da li ste sigurni da želite da obrišete događaj?"),
      actions: [
        okButton.showCursorOnHover,
        notButton.showCursorOnHover,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget listUsers() {
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        direction: Axis.horizontal,
        children: usersForEvent.map((User user) => InputChip(
          avatar: CircleAvatar(
            child: Container(
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                fit: BoxFit.fill,
                image: new NetworkImage(userPhotoURL + user.photo),),),
              ),
            ),
            label: Text(user.firstName + " " + user.lastName),
            onPressed: () {},
          )).toList(),
        )
      );
  }
  
  Widget listInstitutions() {
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        direction: Axis.horizontal,
        children: institutionsForEvent.map((Institution institution) => InputChip(
          avatar: CircleAvatar(
            child: Container(
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                fit: BoxFit.fill,
                image: new NetworkImage(userPhotoURL + institution.photoPath.toString()))),
              ),
            ),
            label: Text(institution.name.toString()),
            onPressed: () {},
          )).toList(),
        )
      );
  }

  bool isJoined() {
    var l = institutionsForEvent==null ? 0 : institutionsForEvent.length;
    for (var i = 0; i < l; i++) {
      if(institutionsForEvent[i]!=null && institutionsForEvent[i].id==insId)
        return true;
    }
    return false;
  }
}