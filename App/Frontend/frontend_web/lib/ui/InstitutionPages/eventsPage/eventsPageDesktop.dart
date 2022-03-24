import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/event.dart';
import 'package:frontend_web/models/institution.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/InstitutionPages/eventsPage/addNewEvent.dart';
import 'package:frontend_web/ui/InstitutionPages/eventsPage/viewEventIns/viewEventIns.dart';
import 'package:frontend_web/ui/InstitutionPages/eventsPage/viewEventIns/viewEventInsDesktop.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/homePage.dart';
import 'package:frontend_web/widgets/collapsingInsNavigationDrawer.dart';
import 'package:frontend_web/extensions/hoverExtension.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../../editEventPage.dart';
import '../homePage/homePage.dart';

Color greenPastel = Color(0xFF00BFA6);

class EventsPageDesktop extends StatefulWidget {
  @override
  _EventsPageDesktopState createState() => _EventsPageDesktopState();

}

class _EventsPageDesktopState extends State<EventsPageDesktop> {
  List<Events> events;

  _getEvents()
  {
    APIServices.getEventsByCity(TokenSession.getToken, insId, 1).then((res) {
      Iterable list = json.decode(res.body);
      List<Events> ev;
      ev = list.map((model) => Events.fromObject(model)).toList();
      if(mounted)
      {
        setState(() {
          events = ev;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getEvents();
  }

  Widget buildEventsList(List<Events> listEvents) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 30.0),
      itemCount: listEvents == null ? 0 : listEvents.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          margin: EdgeInsets.all(10.0),
          child: Row( children: <Widget>[
            Expanded(child: Column(children: <Widget>[
              titleColumn(listEvents[index].title, listEvents[index].shortDescription),
              startEndDateRow(listEvents[index]),
              locationRow(listEvents[index]),
              buttonsRow(listEvents[index], index),
            ],)),
          ],
          ),
        );
      }
    );
  }
  
  Widget titleColumn(String title, String description) {
    return Column(children: <Widget>[
      SizedBox(height: 5.0,),
      Text(title, style: TextStyle(fontWeight: FontWeight.bold),),
      description == null ? Text("") : Text(description),
    ],);
  }

  Widget startEndDateRow(Events event) {
    return Row(children: <Widget>[
      SizedBox(width: 15.0,),
      Column(children: [
        Text("Počinje:"),
        Text(event.startDate)
      ],),
      Expanded(child: SizedBox()),
      Column(children: [
        Text("Završava se:"),
        Text(event.endDate)
      ],),
      SizedBox(width: 15.0,),
    ],);
  }

  Widget locationRow(Events event) {
    return Row(
      mainAxisAlignment:  MainAxisAlignment.start,
      children: <Widget>[
      SizedBox(width: 10.0,),
      Icon(Icons.location_on),
      Flexible(
            child:Text(event.address),
          ),
    ],);
  }

  Widget buttonsRow(Events event, index) {
    return Row(children: <Widget>[
      SizedBox(width: 15.0,),
      RaisedButton(
        onPressed: ()async {
          print("");
          int result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewEventIns(event)),
          );

          print("Vracam koji isGoing:" + result.toString());

          setState(() {
              if(event.institutionId!=insId && result != null)
                  event.isGoing = result;
            });
        },
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0),),
        child: Text("Više informacija", style: TextStyle(color: Colors.white,),),
        color: greenPastel,
      ).showCursorOnHover,
      Expanded(child: SizedBox()),
      event.institutionId==insId ? deleteEditButtons(event, index) : (event.isGoing == 1 ? cancelButton(event, index) : joinButton(event, index)),
      SizedBox(width: 15.0,),
    ],);
  }

  Widget deleteEditButtons(Events event, index) {
    return Row(children: <Widget>[
      RaisedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditEventPage(event)),
          );
        },
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0)),
        child: Text("Izmeni", style: TextStyle(color: Colors.white),),
        color: Colors.blueAccent,
      ).showCursorOnHover,
      SizedBox(width: 10.0,),
      RaisedButton(
        onPressed: () {
          showAlertDialog(context, event.id, index);
        },
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0)),
        child: Text("Obriši", style: TextStyle(color: Colors.white),),
        color: Colors.red,
      ).showCursorOnHover,
    ],);
  }

  Widget joinButton(Events event, int index) {
    return RaisedButton(
      onPressed: () {
        APIServices.joinEvent(TokenSession.getToken, event.id, insId).then((res) {
          if(res.statusCode == 200) {
            setState(() {
              events[index].isGoing = 1;
            });
          }
        });
      },
      child: Text("Pridruži se", style: TextStyle(color: Colors.white),),
      shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0)),
      color: Colors.blue,
    ).showCursorOnHover;
  }

  Widget cancelButton(Events event, int index) {
    return RaisedButton(
      child: Text("Otkaži", style: TextStyle(color: Colors.white)),
      shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0)),
      onPressed: () {
        APIServices.leaveEvent(TokenSession.getToken, event.id, insId).then((res) {
          if(res.statusCode == 200) {
            setState(() {
              events[index].isGoing = 0;
            });
          }
        });
      },
      color: Colors.red,
    ).showCursorOnHover;
  }

  showAlertDialog(BuildContext context, int eventId, int index) {

    final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();
    
    void _doSomething() async {
      APIServices.removeEvent(TokenSession.getToken, eventId).then((res) {
          if(res.statusCode == 200){
            print("Događaj je uspešno obrisan.");
            setState(() {
              events.removeAt(index);
            });
          }
        });
      Timer(Duration(seconds: 1), () {
          _btnController.success();
          Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        child: ConstrainedBox(child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(child: SizedBox(),),
              RaisedButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateEventPageIns()), 
                  );
                },
                child: Row(children: <Widget>[ 
                  Text("Dodaj događaj", style: TextStyle(color: Colors.white,),),
                  Icon(Icons.add, color: Colors.white,),
                ],),
                color: greenPastel,
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0),),
              ).showCursorOnHover,
            ],),
            Flexible(child: buildEventsList(events),),
          ],
        ),
        constraints: BoxConstraints(maxWidth: 600),
        ),
        padding: EdgeInsets.only(left: 100, right: 100, top: 30),
        alignment: Alignment.topCenter,
      ),
      CollapsingInsNavigationDrawer(),
    ],);
  }
}