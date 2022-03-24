import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontend_web/editEventPage.dart';
import 'package:frontend_web/models/event.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/manageEvents/createEvent/createEventPage.dart';
import 'package:frontend_web/ui/adminPages/manageEvents/editEventAdmin.dart';
import 'package:frontend_web/ui/adminPages/manageEvents/viewEvent/viewEventPage.dart';
import 'package:frontend_web/ui/adminPages/manageEvents/viewEvent/viewEventTablet.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';
import 'package:universal_html/html.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ManageEventsPageTablet extends StatefulWidget {
  @override
  ManageEventsPageTabletState createState() => ManageEventsPageTabletState();
}

class ManageEventsPageTabletState extends State<ManageEventsPageTablet>{
  List<Events> events;
  List<Events> finishedEvents;

  _getEvents()
  {
    APIServices.getEvents(TokenSession.getToken, 0).then((res) {
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

  _getFinishedEvents()
  {
    APIServices.getFinishedEvents(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<Events> ev;
      ev = list.map((model) => Events.fromObject(model)).toList();
      if(mounted)
      {
        setState(() {
          finishedEvents = ev;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getEvents();
    _getFinishedEvents();
  }

  Widget buildEventsList(List<Events> listEvents, int ind){
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 30.0),
      itemCount: listEvents == null ? 0 : listEvents.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          margin: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Expanded(child: Column(
                children: <Widget>[
                  titleColumn(listEvents[index].title, listEvents[index].shortDescription),
                  startEndDateRow(listEvents[index]),
                  locationRow(listEvents[index]),
                  buttonsRow(listEvents[index], index, ind),
                 ],
                ),
              ),
          ],),
        );
      }
    );
  }

  Widget titleColumn(String title, String description) {
    return Column(children: <Widget>[
      SizedBox(height: 5.0,),
      Text(title, style: TextStyle(fontWeight: FontWeight.bold),),
      description==null ? Text("") : Text(description),
    ],);
  }

  Widget startEndDateRow(Events event) {
    return Row(children: <Widget>[
      SizedBox(width: 15.0),
      Column(children: <Widget>[
        Text("Počinje: "),
        Text(event.startDate),
      ],),
      Expanded(child: SizedBox(),),
      Column(children: <Widget>[
        Text("Završava se: "),
        Text(event.endDate),
      ],),
      SizedBox(width: 15.0,),
    ],);
  }

  Widget locationRow(Events event) {
    return Row(children: <Widget>[
      SizedBox(width: 20.0,),
      Icon(Icons.location_on),
      Flexible(
            child:Text(event.address),
          ),
    ],);
  }
 
  Widget buttonsRow(Events event, int index, int ind) {
    var str = TokenSession.getToken;
    var jwt = str.split(".");
    var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));

    return Row(children: <Widget>[
      SizedBox(width: 15.0,),
      RaisedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewEventPage(event)),
          );
        },
        color: Color(0xFF00BFA6),
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0),),
        child: Text("Više informacija", style: TextStyle(color: Colors.white,),),
      ),
      Expanded(child: SizedBox()),
      (event.adminId == int.parse(payload["sub"])) ? editButton(event) : SizedBox(),
      RaisedButton(
        child: Text("Obriši", style: TextStyle(color: Colors.white),),
        color: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0),),
        onPressed: () {
          showAlertDialog(context, event.id, index, ind);
        },
      ),
      SizedBox(width: 15.0,),
    ],);
  }

  Widget editButton(event) {
    return RaisedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditEventAdmin(event)),
          );
        },
        color: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0),),
        child: Text("Izmeni", style: TextStyle(color: Colors.white,),),
      );
  }

  showAlertDialog(BuildContext context, int eventId, int index, int ind) {
    final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();
    
    void _doSomething() async {
      APIServices.removeEvent(TokenSession.getToken, eventId).then((res) {
        if(res.statusCode == 200){
          print("Događaj je uspešno obrisan.");
          setState(() {
            if(ind == 1)
                events.removeAt(index);
            else
              finishedEvents.removeAt(index);
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
       color: Color(0xFF00BFA6),
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
        okButton,
        notButton,
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
    return Stack(
      children: <Widget>[
        Container(child: ConstrainedBox(child: TabBarView(children: <Widget>[
          Column(children: <Widget>[
           Row(children: <Widget>[
           Expanded(child: SizedBox(),),
           RaisedButton(onPressed: () {
             Navigator.push(context, 
               MaterialPageRoute(builder: (context) => CreateEventPage()),
              );
            },
            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0)),
            child: Row(children: <Widget>[ Text("Dodaj dogđaj", style: TextStyle(color: Colors.white),), Icon(Icons.add, color: Colors.white,)],),
            color: Color(0xFF00BFA6),
          ),
          ],),
            Flexible(child: buildEventsList(events, 1),),
          ]),
          Column(children: <Widget>[
          Flexible(child: buildEventsList(finishedEvents, 2),),
          ]),
          ],),
          constraints: BoxConstraints(maxWidth: 500),
          ),
          padding: const EdgeInsets.only(left: 100, right: 100, top: 30),
          alignment: Alignment.topCenter,
        ),

        CollapsingNavigationDrawer(),
      ],
    );
  }
}