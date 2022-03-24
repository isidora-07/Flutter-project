import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_web/models/institution.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/InstitutionPages/profilePage/institutionProfileDesktop.dart';
import 'package:frontend_web/ui/InstitutionPages/profilePage/institutionProfileMobile.dart';
import 'package:frontend_web/widgets/collapsingInsNavigationDrawer.dart';
import 'package:frontend_web/widgets/mobileDrawer/drawerInstitution.dart';
import 'package:responsive_builder/responsive_builder.dart';

Color greenPastel = Color(0xFF00BFA6);

class InstitutionProfilePage extends StatefulWidget {
  
  final int instId;
  InstitutionProfilePage(this.instId);

  @override
  _InstitutionProfilePageState createState() => _InstitutionProfilePageState();
}

class _InstitutionProfilePageState extends State<InstitutionProfilePage> {
  
  int instId;
  Institution institution;

    void initState() {
    super.initState();
    _getInsData(TokenSession.getToken, widget.instId);
  }

  _getInsData(String jwt, int id) async {
    var result = await APIServices.getInstitutionById(jwt, id);
    Map<String, dynamic> jsonUser = jsonDecode(result.body);
    Institution ins = Institution.fromObject(jsonUser);
    setState(() {
      institution = ins;
    });
  }
  @override
  Widget build(BuildContext context) {

    return ResponsiveBuilder(
      builder: (context, sizingInformation) => DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
            ? DrawerInstitution(1)
            : null,
          appBar: sizingInformation.deviceScreenType != DeviceScreenType.Mobile
            ? null
            : AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
            ),
          backgroundColor: Colors.white,
          body: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: (institution != null)
                  ? Row(
            children: <Widget>[
                sizingInformation.deviceScreenType != DeviceScreenType.Mobile 
            ? CollapsingInsNavigationDrawer()
            : SizedBox(),
              Expanded(
                child: ScreenTypeLayout(
                  mobile: InstitutionProfileMobile(institution),
                  desktop: InstitutionProfileDesktop(institution),
                  tablet: InstitutionProfileDesktop(institution),
                ),
              )
            ],
          )
           : Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                    greenPastel),
              ),
            ),)
        ),
      )
    );
  }  

   Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 3));
    setState(() {
      institution = new Institution();
    });
    _getInsData(TokenSession.getToken, widget.instId);
    return null;
  }
}