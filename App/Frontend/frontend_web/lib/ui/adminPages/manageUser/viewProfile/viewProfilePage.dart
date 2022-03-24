import 'package:flutter/material.dart';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/ui/adminPages/manageDonation/viewDonation/viewDonationDesktop.dart';
import 'package:frontend_web/ui/adminPages/manageDonation/viewDonation/viewDonationMobile.dart';
import 'package:frontend_web/ui/adminPages/manageUser/viewProfile/viewProfileDesktop.dart';
import 'package:frontend_web/ui/adminPages/manageUser/viewProfile/viewProfileMobile.dart';
import 'package:frontend_web/widgets/mobileDrawer/drawerAdmin.dart';
import 'package:responsive_builder/responsive_builder.dart';

Color greenPastel = Color(0xFF00BFA6);

class ViewUserProfilePage extends StatefulWidget {
  
  User user;
  ViewUserProfilePage(this.user);

  @override
  _ViewUserProfilePageState createState() => _ViewUserProfilePageState(user);
}

class _ViewUserProfilePageState extends State<ViewUserProfilePage> {
  
  User user;
  _ViewUserProfilePageState(User user1){
    this.user = user1;
  }

  @override
  Widget build(BuildContext context) {

    return ResponsiveBuilder(
      builder: (context, sizingInformation) => DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
            ? DrawerAdmin(4)
            : null,
          appBar: sizingInformation.deviceScreenType != DeviceScreenType.Mobile
            ? null
            : AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
            ),
          backgroundColor: Colors.white,
          body: ScreenTypeLayout(
            mobile: ViewUserProfileMobile(user),
            tablet: ViewUserProfileDesktop(user),
          ),
        ),
      )
    );
  }  
}