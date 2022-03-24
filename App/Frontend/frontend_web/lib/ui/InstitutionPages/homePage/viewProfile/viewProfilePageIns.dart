import 'package:flutter/material.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/viewProfile/viewProfileDesktopIns.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/viewProfile/viewProfileMobileIns.dart';
import 'package:frontend_web/widgets/mobileDrawer/drawerInstitution.dart';
import 'package:responsive_builder/responsive_builder.dart';

Color greenPastel = Color(0xFF00BFA6);

class ViewUserProfilePageIns extends StatefulWidget {
  
  final int userId;
  ViewUserProfilePageIns(this.userId);

  @override
  _ViewUserProfilePageInsState createState() => _ViewUserProfilePageInsState(userId);
}

class _ViewUserProfilePageInsState extends State<ViewUserProfilePageIns> {
  
  int userId;
  _ViewUserProfilePageInsState(int userId1){
    this.userId = userId1;
  }

  @override
  Widget build(BuildContext context) {

    return ResponsiveBuilder(
      builder: (context, sizingInformation) => DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
            ? DrawerInstitution(2)
            : null,
          appBar: sizingInformation.deviceScreenType != DeviceScreenType.Mobile
            ? null
            : AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
            ),
          backgroundColor: Colors.white,
          body: ScreenTypeLayout(
            mobile: ViewUserProfileMobileIns(userId),
            tablet: ViewUserProfileDesktopIns(userId),
          ),
        ),
      )
    );
  }  
}