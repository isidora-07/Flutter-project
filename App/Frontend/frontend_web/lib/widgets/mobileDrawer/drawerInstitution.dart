import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/InstitutionPages/editInstitutionPage/editInstitutionPage.dart';
import 'package:frontend_web/ui/InstitutionPages/eventsPage/eventsPage.dart';
import 'package:frontend_web/ui/InstitutionPages/profilePage/institutionProfilePage.dart';
import 'package:frontend_web/ui/home/homeView.dart';
import 'package:frontend_web/extensions/hoverExtension.dart';

import '../../ui/InstitutionPages/homePage/homePage.dart';

class DrawerInstitution extends StatelessWidget{
  final int selected;
  DrawerInstitution(this.selected);

  _removeToken() async {
    TokenSession.setToken = "";
    insId=null;
  }
  Color greenPastel = Color(0xFF00BFA6);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(children: <Widget>[
          DrawerHeader(
            child: Center(child: Text("MOJ GRAD"),),
          ),
          ListTile(
            leading: Icon(Icons.business),
            title: Text(
              "Institucija",
              style: TextStyle(fontSize: 16, color: (selected == 1) ? greenPastel : Colors.black),
            ),
            onTap: (){
             Navigator.push(context, 
                MaterialPageRoute(builder: (context) => InstitutionProfilePage(insId)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(
              "Početna strana",
              style: TextStyle(fontSize: 16, color: (selected == 2) ? greenPastel : Colors.black),
            ),
            onTap: (){
              String jwt = TokenSession.getToken;
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => HomePageInstitution.fromBase64(jwt)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text(
              "Izmena podataka",
              style: TextStyle(fontSize: 16, color: (selected == 3) ? greenPastel : Colors.black),
            ),
            onTap: (){
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => EditInstitutionPage(insId)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text(
              "Kreiranje događaja",
              style: TextStyle(fontSize: 16, color: (selected == 4) ? greenPastel : Colors.black),
            ),
            onTap: (){
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => EventsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              "Odjavi se",
              style: TextStyle(fontSize: 16, color: (selected == 5) ? greenPastel : Colors.black),
            ),
            onTap: (){
              _removeToken();
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => HomeView()),
              );
            },
          ),
        ],)
      )
    ).showCursorOnHover;
  }
}