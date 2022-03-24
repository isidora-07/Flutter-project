import 'package:flutter/material.dart';
import 'package:frontend_web/ui/adminPages/manageUser/manageUserDesktop.dart';
import 'package:frontend_web/ui/adminPages/manageUser/manageUserMobile.dart';
import 'package:frontend_web/ui/adminPages/manageUser/manageUserTablet.dart';
import 'package:frontend_web/widgets/mobileDrawer/drawerAdmin.dart';
import 'package:responsive_builder/responsive_builder.dart';

//import 'package:frontend_web/extensions/hoverExtension.dart';

Color greenPastel = Color(0xFF00BFA6);

class ManageUserPage extends StatefulWidget {
  @override
  _ManageUserPageState createState() => _ManageUserPageState();
}

class _ManageUserPageState extends State<ManageUserPage> {
  @override
  Widget build(BuildContext context) {

    return ResponsiveBuilder(
      builder: (context, sizingInformation) => DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
            ? DrawerAdmin(4)
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
              bottom: tabs(),
            ),
          backgroundColor: Colors.white,
          body: ScreenTypeLayout(
            mobile: ManageUserMobile(),
            tablet: ManageUserTablet(),
            desktop: ManageUserDesktop(),
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
          child: Text('SVI KORISNICI', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
        ),
        Tab(
          child: Text('PRIJAVLJENI KORISNICI', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
        ),
      ]
    );
  }
}