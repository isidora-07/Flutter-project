import 'package:flutter/material.dart';
import 'package:frontend_web/ui/adminPages/manageDonation/manageDonationDesktop.dart';
import 'package:frontend_web/ui/adminPages/manageDonation/manageDonationMobile.dart';
import 'package:frontend_web/ui/adminPages/manageDonation/manageDonationTablet.dart';
import 'package:frontend_web/widgets/mobileDrawer/drawerAdmin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:frontend_web/extensions/hoverExtension.dart';

Color greenPastel = Color(0xFF00BFA6);

class ManageDonationPage extends StatefulWidget {
  @override
  _ManageDonationPageState createState() => _ManageDonationPageState();
}

class _ManageDonationPageState extends State<ManageDonationPage> {
  @override
  Widget build(BuildContext context) {

    return ResponsiveBuilder(
      builder: (context, sizingInformation) => DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
            ? DrawerAdmin(7)
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
            mobile: ManageDonationMobile(),
            tablet: ManageDonationTablet(),
            desktop: ManageDonationDesktop(),
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
              Icon(Icons.all_inclusive, color: Colors.black, size: 20),
              Flexible(child: Text(' TRENUTNE DONACIJE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.done_all, color: Colors.black, size: 20),
              Flexible(child: Text(' ZAVRŠENE DONACIJE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
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
              Flexible(child: Text('TRENUTNE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(child: Text('ZAVRŠENE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
            ],
          ),
        ),
      ]
    );
  }
}