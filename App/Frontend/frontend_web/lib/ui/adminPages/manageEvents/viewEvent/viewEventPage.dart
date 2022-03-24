import 'package:flutter/material.dart';
import 'package:frontend_web/ui/adminPages/manageEvents/viewEvent/viewEventDesktop.dart';
import 'package:frontend_web/ui/adminPages/manageEvents/viewEvent/viewEventMobile.dart';
import 'package:frontend_web/ui/adminPages/manageEvents/viewEvent/viewEventTablet.dart';
import 'package:frontend_web/widgets/mobileDrawer/drawerAdmin.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../models/event.dart';


class ViewEventPage extends StatefulWidget {
  Events event;
  ViewEventPage(this.event);
  @override
  _ViewEventPageState createState() => _ViewEventPageState(event);
}

class _ViewEventPageState extends State<ViewEventPage> {
  Events event;
  _ViewEventPageState(Events event1){
    this.event = event1;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        drawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile ? DrawerAdmin(6) : null,
        appBar: sizingInformation.deviceScreenType != DeviceScreenType.Mobile ? null : 
        AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        body: ScreenTypeLayout(
          mobile: ViewEventMobile(event),
          tablet: ViewEventTablet(event),
          desktop: ViewEventDesktop(event),
        ),
      ),
    );
  }
}