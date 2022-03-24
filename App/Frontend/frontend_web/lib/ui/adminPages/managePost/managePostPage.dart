import 'package:flutter/material.dart';
import 'package:frontend_web/ui/adminPages/managePost/managePostDesktop.dart';
import 'package:frontend_web/ui/adminPages/managePost/managePostMobile.dart';
import 'package:frontend_web/widgets/mobileDrawer/drawerAdmin.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:frontend_web/extensions/hoverExtension.dart';

Color greenPastel = Color(0xFF00BFA6);

class ManagePostPage extends StatefulWidget {
  @override
  _ManagePostPageState createState() => _ManagePostPageState();
}

class _ManagePostPageState extends State<ManagePostPage> {
  @override
  Widget build(BuildContext context) {

    return ResponsiveBuilder(
      builder: (context, sizingInformation) => DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
            ? DrawerAdmin(3)
            : null,
          appBar: sizingInformation.deviceScreenType != DeviceScreenType.Mobile
            ? PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Container(
                  height: 100.0,
                  child: tabsDesktop(),
                ),
              )
            : AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              bottom: tabsMobile(),
            ),
          backgroundColor: Colors.white,
          body: ScreenTypeLayout(
            mobile: ManagePostMobile(),
            tablet: ManagePostDesktop(),
          ),
        ),
      )
    );
  }

  Widget tabsDesktop() {
    return TabBar(
      labelColor: greenPastel,
      indicatorColor: greenPastel,
      tabs: <Widget>[
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(MdiIcons.homeSearchOutline, color: Colors.black, size: 20),
              Text(' SVE OBJAVE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.done_all, color: Colors.black, size: 20),
              Text(' REŠENE OBJAVE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.close, color: Colors.black, size: 20),
              Text(' NEREŠENE OBJAVE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
            ],
          ),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('SVE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13.0),),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('REŠENO', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13.0),),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('NEREŠENO', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13.0,),),
            ],
          ),
        ),
      ]
    );
  }
}