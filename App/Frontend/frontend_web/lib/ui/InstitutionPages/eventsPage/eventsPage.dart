import 'package:flutter/material.dart';
import 'package:frontend_web/ui/InstitutionPages/eventsPage/eventsPageDesktop.dart';
import 'package:frontend_web/ui/InstitutionPages/eventsPage/eventsPageMobile.dart';
import 'package:frontend_web/ui/InstitutionPages/eventsPage/eventsPageTablet.dart';
import 'package:frontend_web/widgets/mobileDrawer/drawerInstitution.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'eventsPageTablet.dart';


class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
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
          mobile: EventsPageMobile(),
          tablet: EventsPageTablet(),
          desktop: EventsPageDesktop(),
        ),
      ),
    );
  }
}