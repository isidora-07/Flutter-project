import 'package:flutter/material.dart';
import 'package:frontend_web/widgets/centeredView/centeredView.dart';
import 'package:frontend_web/widgets/homeNavigationBar/navigationBar.dart';
import 'package:frontend_web/widgets/projectDetails/projectDetails.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        endDrawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
            ? HomeNavigationDrawer(0)
            : null,
        appBar: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
            ? AppBar(
              leading: new Container(),
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              title: InkWell(
                child: SizedBox(
                  width: 150,
                  child: Image.asset('assets/mojGrad2.png'),
                ),
                onTap: (){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeView()
                    )
                  );
                },
              ),
            )
            : null,
        backgroundColor: Colors.white,
        body: CenteredView(
          child: Column(
            children: <Widget>[
              (sizingInformation.deviceScreenType != DeviceScreenType.Mobile) ? HomeNavigationBar(0) : SizedBox(),
              Expanded(
                child: ScreenTypeLayout(
                  mobile: HomeViewMobile(),
                  desktop: HomeViewDesktop(),
                  tablet: HomeViewMobile(),
                ),
              )
            ],
          ),
        )
      )
    );
  }
}

class HomeViewMobile extends StatelessWidget{
 
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ProjectDetails(),
            SizedBox(height: 100,),
            Image.asset('assets/undraw4.png')
          ],
        )
      ],
    );
  }
}

class HomeViewDesktop extends StatelessWidget{
 
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      shrinkWrap: true,
      children: <Widget>[ 
        Row(children: <Widget>[
          ProjectDetails(),
          Expanded(
            child: Center(
              child: Image.asset('assets/undraw4.png'),
            ),
          )
        ],)
      ]
    );
  }
}