import 'package:flutter/material.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/ui/adminPages/managePost/viewPost/viewPostDesktop.dart';
import 'package:frontend_web/ui/adminPages/managePost/viewPost/viewPostMobile.dart';
import 'package:frontend_web/ui/adminPages/menageAdmin/manageAdminDesktop.dart';
import 'package:frontend_web/ui/adminPages/menageAdmin/manageAdminMobile.dart';
import 'package:frontend_web/widgets/mobileDrawer/drawerAdmin.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:frontend_web/extensions/hoverExtension.dart';

Color greenPastel = Color(0xFF00BFA6);

class ManageAdminPage extends StatefulWidget {
  
  final int id;
  ManageAdminPage(this.id);

  @override
  _ManageAdminPageState createState() => _ManageAdminPageState(id);
}

class _ManageAdminPageState extends State<ManageAdminPage> {
  
   int idA;
  _ManageAdminPageState(int id){
    this.idA = id;
  }

  @override
  Widget build(BuildContext context) {

    return ResponsiveBuilder(
      builder: (context, sizingInformation) => DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
            ? DrawerAdmin(1)
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
            mobile: ManageAdminMobile(idA),
            tablet: ManageAdminDesktop(idA),
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
              Icon(Icons.person, color: Colors.black, size: 15),
              Text(' O MENI ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.people, color: Colors.black, size: 15),
              Text('OSTALI ADMINISTRATORI ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
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
              Text('O MENI', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10),),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('OSTALI ADMINISTRATORI', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,  fontSize: 10),),
            ],
          ),
        ),
      ]
    );
  }
}