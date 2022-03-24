import 'package:flutter/material.dart';
import 'package:frontend_web/models/donation.dart';
import 'package:frontend_web/ui/adminPages/manageDonation/viewDonation/viewDonationDesktop.dart';
import 'package:frontend_web/ui/adminPages/manageDonation/viewDonation/viewDonationMobile.dart';
import 'package:frontend_web/widgets/mobileDrawer/drawerAdmin.dart';
import 'package:responsive_builder/responsive_builder.dart';

Color greenPastel = Color(0xFF00BFA6);

class ViewDonationPage extends StatefulWidget {
  
  final Donation donation;
  ViewDonationPage(this.donation);

  @override
  _ViewDonationPageState createState() => _ViewDonationPageState(donation);
}

class _ViewDonationPageState extends State<ViewDonationPage> {
  
  Donation donation;
  _ViewDonationPageState(Donation donation1){
    this.donation = donation1;
  }

  @override
  Widget build(BuildContext context) {

    return ResponsiveBuilder(
      builder: (context, sizingInformation) => DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
            ? DrawerAdmin(7)
            : null,
          appBar: sizingInformation.deviceScreenType != DeviceScreenType.Mobile
            ? null
            : AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
            ),
          backgroundColor: Colors.white,
          body: ScreenTypeLayout(
            mobile: ViewDonationMobile(donation),
            tablet: ViewDonationDesktop(donation),
          ),
        ),
      )
    );
  }  
}