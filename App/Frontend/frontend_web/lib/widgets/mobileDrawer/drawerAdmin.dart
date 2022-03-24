import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/manageDonation/manageDonationPage.dart';
import 'package:frontend_web/ui/adminPages/manageEvents/manageEventsPage.dart';
import 'package:frontend_web/ui/adminPages/manageInstitution/manageInstitutionPage.dart';
import 'package:frontend_web/ui/adminPages/managePost/managePostPage.dart';
import 'package:frontend_web/ui/adminPages/manageUser/manageUserPage.dart';
import 'package:frontend_web/ui/adminPages/menageAdmin/manageAdminPage.dart';
import 'package:frontend_web/ui/adminPages/registerAdminPage/registerAdminPage.dart';
import 'package:frontend_web/ui/home/homeView.dart';
import 'package:frontend_web/ui/homePage.dart';

Color greenPastel = Color(0xFF00BFA6);

class DrawerAdmin extends StatelessWidget{
  final int selected;
  DrawerAdmin(this.selected);

  _removeToken() async {
    TokenSession.setToken = "";
  }

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
              "Administrator",
              style: TextStyle(fontSize: 16, color: (selected == 1) ? greenPastel : Colors.black),
            ),
            onTap: (){
             Navigator.push(context, 
                MaterialPageRoute(builder: (context) => ManageAdminPage(globalAdminId)),
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
                MaterialPageRoute(builder: (context) => HomePage.fromBase64(jwt)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.rate_review),
            title: Text(
              "Upravljanje objavama",
              style: TextStyle(fontSize: 16, color: (selected == 3) ? greenPastel : Colors.black),
            ),
            onTap: (){
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => ManagePostPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.supervised_user_circle),
            title: Text(
              "Upravljanje korsinicima",
              style: TextStyle(fontSize: 16, color: (selected == 4) ? greenPastel : Colors.black),
            ),
            onTap: (){
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => ManageUserPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.business),
            title: Text(
              "Upravljanje institucijama",
              style: TextStyle(fontSize: 16, color: (selected == 5) ? greenPastel : Colors.black),
            ),
            onTap: (){
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => ManageInstitutionPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text(
              "Upravljanje događajima",
              style: TextStyle(fontSize: 16, color: (selected == 6) ? greenPastel : Colors.black),
            ),
            onTap: (){
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => ManageEventsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.monetization_on),
            title: Text(
              "Upravljanje donacijama",
              style: TextStyle(fontSize: 16, color: (selected == 7) ? greenPastel : Colors.black),
            ),
            onTap: (){
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => ManageDonationPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text(
              "Dodavanje administratora",
              style: TextStyle(fontSize: 16, color: (selected == 8) ? greenPastel : Colors.black),
            ),
            onTap: (){
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => RegisterAdminPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              "Odjavi se",
              style: TextStyle(fontSize: 16, color: (selected == 9) ? greenPastel : Colors.black),
            ),
            onTap: () {
              _removeToken();
              Navigator.push(context, 
                MaterialPageRoute(builder: (context) => HomeView()),
              );
            },
          ),
        ],)
      )
    );
  }
}