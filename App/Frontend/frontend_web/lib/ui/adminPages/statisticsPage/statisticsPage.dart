import 'package:flutter/material.dart';
import 'package:frontend_web/ui/adminPages/statisticsPage/statisticsDesktop.dart';
import 'package:frontend_web/ui/adminPages/statisticsPage/statisticsMobile.dart';
import 'package:frontend_web/ui/adminPages/statisticsPage/statisticsTablet.dart';
import 'package:frontend_web/widgets/mobileDrawer/drawerAdmin.dart';
import 'package:responsive_builder/responsive_builder.dart';

Color greenPastel = Color(0xFF00BFA6);

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        drawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile
            ? DrawerAdmin(2)
            : null,
        appBar: sizingInformation.deviceScreenType != DeviceScreenType.Mobile
            ? null
            : AppBar(
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(color: Colors.black),
              ),
        backgroundColor: Colors.white,
        body: ScreenTypeLayout(
          mobile: StatisticsMobile(),
          tablet: StatisticsTablet(),
          desktop: StatisticsDesktop(),
        ),
      ),
    );
  }
}
