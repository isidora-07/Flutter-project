import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/ui/login.dart';

import '../main.dart';

 User publicUser;
 
class SplashPage extends StatefulWidget {
  final String jwt;
  final int id;
  SplashPage(this.jwt, this.id);
  @override
  _SplashPageState createState() => new _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // This function needs to be done again once we implement login & register
  // It will check if we have logged user in our session/memory
  // If we have user in memory we will redirect to Homescreen
  // If not it will be reddirected to Login Page


    _getUser() async {
    var res = await APIServices.getUser(widget.jwt, widget.id);
    print(res.body);
    Map<String, dynamic> jsonUser = jsonDecode(res.body);
    User user = User.fromObject(jsonUser);
    if(user != null )
    {
      setState(() {
       publicUser= user;
      });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage.fromBase64(widget.jwt)),
        );
    }
    else
    {
      Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LoginPage()));
    }
    
  }

  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      if (widget.jwt == "") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        _getUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {  
    // Image element with our logo
    // If we get new logo we will just change it here
    final logo = Hero(
      tag: 'hero',
      child: Center(
        child: Image.asset('assets/mojGradPastelna.png', width: 300),
      ),
    );

    final fromAnts = Align(
        alignment: Alignment.bottomCenter,
        child: Image.asset('assets/fromAnts1.png', width: 150));

    return Scaffold(
        backgroundColor: MyApp.ind == 0 ? Colors.white :  Theme.of(context).copyWith().backgroundColor,
        body: Center(
            child: Container(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(color: MyApp.ind == 0 ? Colors.white :  Theme.of(context).copyWith().backgroundColor),
                flex: 1,
              ),
              Expanded(
                child: logo,
                flex: 3,
              ),
              Expanded(
                child: fromAnts,
                flex: 1,
              ),
            ],
          ),
        )));
  }
}
