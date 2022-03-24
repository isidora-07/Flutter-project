import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/ui/home/homeView.dart';
import 'package:frontend_web/widgets/centeredView/centeredView.dart';
import 'package:frontend_web/widgets/homeNavigationBar/navigationBar.dart';
import 'package:responsive_builder/responsive_builder.dart';

Color greenPastel = Color(0xFF00BFA6);

class ContactPage extends StatefulWidget{
  @override
  _ContactPageState createState() => new _ContactPageState();
}

class _ContactPageState extends State<ContactPage>{
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        endDrawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
            ? HomeNavigationDrawer(3)
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
              (sizingInformation.deviceScreenType != DeviceScreenType.Mobile) ? HomeNavigationBar(3) : SizedBox(),
              Expanded(
                child: ScreenTypeLayout(
                  mobile: ContactMobilePage(),
                  desktop: ContactDesktopPage(),
                  tablet: ContactMobilePage(),
                ),
              )
            ],
          ),
        )
      )
    );
  }
  
}

class ContactMobilePage extends StatefulWidget{
  @override
  _ContactMobilePageState createState() => new _ContactMobilePageState();
}

class _ContactMobilePageState extends State<ContactMobilePage>{
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50,),
            Image.asset('assets/undraw6.png'),
            ContactPageWidget(),
          ],
        )
      ],
    );
  }
}

class ContactDesktopPage extends StatefulWidget{
  @override
  _ContactDesktopPageState createState() => new _ContactDesktopPageState();
}

class _ContactDesktopPageState extends State<ContactDesktopPage>{
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[ 
        Row(children: <Widget>[
          Expanded(
            child: Center(
              child: Image.asset('assets/undraw6.png'),
            ),
          ),
          ContactPageWidget(),
        ],)
      ]
    );
  }
}

class ContactPageWidget extends StatefulWidget{
  @override
  _ContactPageWidgetState createState() => new _ContactPageWidgetState();
}

class _ContactPageWidgetState extends State<ContactPageWidget>{
 

  @override
  Widget build(BuildContext context) {
     return  ResponsiveBuilder(
      builder: (context, sizingInformation){
        var textAligment = sizingInformation.deviceScreenType == DeviceScreenType.Desktop
          ? TextAlign.left
          : TextAlign.center;
        double titleSize = sizingInformation.deviceScreenType == DeviceScreenType.Mobile
          ? 15
          : 30;
        double descSize = sizingInformation.deviceScreenType == DeviceScreenType.Mobile
          ? 14
          : 19;  


        return Container(
          width: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Želimo da čujemo i Vaše mišljenje",
                style: TextStyle(fontWeight: FontWeight.w800, height: 0.9, fontSize: titleSize,),
                textAlign: textAligment,
              ),
              SizedBox(height: 50,),
              Container(
                child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[
                     Text("Ukoliko želite da postanete sponzor ili imate bilo kakvih pitanja i sugestija možete nas kontaktirati putem mail-a.",style: TextStyle(fontSize: descSize, height: 1.7),),
                     SizedBox(height: 10,),
                     //Text("Telefon", style: TextStyle(fontWeight: FontWeight.bold, fontSize: descSize),),
                     //Text("064 100565",style: TextStyle(fontSize: descSize, height: 1.7),),
                    // Text("Odakle god da zovete, poziv se naplaćuje po standardnoj tarifi.", style: TextStyle(fontStyle: FontStyle.italic, fontSize: descSize),),
                   //  Text("Ponedeljak - Petak\n10:00 – 15:00",style: TextStyle(fontSize: descSize, height: 1.7),),
                    SizedBox(height: 20,),
                     Text("Mail", style: TextStyle(fontWeight: FontWeight.bold, fontSize: descSize),),
                     Text("mojgrad.info@gmail.com",style: TextStyle(fontSize: descSize, height: 1.7),),
                   ],
                ),
              )
            ],
          ),
        );
      }
    );
  }
}