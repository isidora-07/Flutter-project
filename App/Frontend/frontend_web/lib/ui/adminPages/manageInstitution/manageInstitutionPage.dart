import 'package:flutter/material.dart';
import 'package:frontend_web/ui/adminPages/manageInstitution/manageInstitutionDesktop.dart';
import 'package:frontend_web/ui/adminPages/manageInstitution/manageInstitutionMobile.dart';
import 'package:frontend_web/ui/adminPages/manageInstitution/manageInstitutionTablet.dart';
import 'package:frontend_web/widgets/mobileDrawer/drawerAdmin.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:frontend_web/extensions/hoverExtension.dart';

Color greenPastel = Color(0xFF00BFA6);

class ManageInstitutionPage extends StatefulWidget {
  @override
  _ManageInstitutionPageState createState() => _ManageInstitutionPageState();
}

class _ManageInstitutionPageState extends State<ManageInstitutionPage> {
  @override
  Widget build(BuildContext context) {

    return ResponsiveBuilder(
      builder: (context, sizingInformation) => DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
            ? DrawerAdmin(5)
            : null,
          appBar: sizingInformation.deviceScreenType != DeviceScreenType.Mobile
            ? PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Container(
                  height: 100.0,
                  child: tabs(),
                ),
              )
            : AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              bottom: tabsMobile(),
            ),
          backgroundColor: Colors.white,
          body: ScreenTypeLayout(
            mobile: ManageInstitutionMobile(),
            tablet: ManageInstitutionTablet(),
            desktop: ManageInstitutionDesktop(),
          ),
        ),
      )
    );
  }

  Widget tabs() {
    return TabBar(
      labelColor: greenPastel,
      indicatorColor: greenPastel,
      tabs: <Widget>[
        Tab(
          child: Text('SVE INSTITUCIJE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
        ),
        Tab(
          child: Text('ZAHTEVI ZA REGISTRACIJU', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ),
      ]
    ).showCursorOnHover;
  }

  Widget tabsMobile() {
    return TabBar(
      labelColor: greenPastel,
      indicatorColor: greenPastel,
      tabs: <Widget>[
        Tab(
          child: Text('SVE INSTITUCIJE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
        ),
        Tab(
          child: Text('ZAHTEVI ZA REGISTRACIJU', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ),
      ]
    );
  }
}