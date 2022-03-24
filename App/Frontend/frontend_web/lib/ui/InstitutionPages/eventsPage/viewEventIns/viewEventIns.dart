import 'package:flutter/material.dart';
import 'package:frontend_web/ui/InstitutionPages/eventsPage/eventsPageDesktop.dart';
import 'package:frontend_web/ui/InstitutionPages/eventsPage/eventsPageMobile.dart';
import 'package:frontend_web/ui/InstitutionPages/eventsPage/eventsPageTablet.dart';
import 'package:frontend_web/widgets/mobileDrawer/drawerInstitution.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../models/event.dart';
import 'viewEventInsDesktop.dart';
import 'viewEventInsMobile.dart';
import 'viewEventInsTablet.dart';


class ViewEventIns extends StatefulWidget {
  Events event;
  ViewEventIns(this.event);
  @override
  _ViewEventInsState createState() => _ViewEventInsState(event);
}

class _ViewEventInsState extends State<ViewEventIns> {
  Events event;
  _ViewEventInsState(Events event1){
    this.event = event1;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        drawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile ? DrawerInstitution(4) : null,
        appBar: sizingInformation.deviceScreenType != DeviceScreenType.Mobile ? null : 
        AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        body: ScreenTypeLayout(
          mobile: ViewEventInsMobile(event),
          tablet: ViewEventInsTablet(event),
          desktop: ViewEventInsDesktop(event),
        ),
      ),
    );
  }
}