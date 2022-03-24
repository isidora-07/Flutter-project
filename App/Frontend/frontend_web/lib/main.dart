import 'dart:convert';
import 'package:frontend_web/ui/home/homeView.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/homePage.dart';

import 'ui/InstitutionPages/homePage/homePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  Future<String> get jwtOrEmpty async {
    var jwt = TokenSession.getToken;
    if(jwt == null) return "";
    return jwt;
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moj Grad',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FutureBuilder(
        future: jwtOrEmpty,            
        builder: (context, snapshot) {
          if(!snapshot.hasData) return CircularProgressIndicator();
          if(snapshot.data != "") {
            var str = snapshot.data;
            var jwt = str.split(".");

            if(jwt.length !=3) {
              return HomeView();//LoginSponsorPage();
            } else {
              var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
              if(DateTime.fromMillisecondsSinceEpoch(payload["exp"]*1000).isAfter(DateTime.now())) {
                int type = int.parse(payload["nameid"]);
                if(type == 1)
                  return HomePage(str, payload);
                else
                  return HomePageInstitution(str,payload);
              } else {
                return HomeView();//LoginSponsorPage();
              }
            }
          } else {
            return HomeView();//LoginSponsorPage();
          }
        }
      ),
    );
  }
}