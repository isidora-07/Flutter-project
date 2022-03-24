import 'package:flutter/material.dart';
import 'package:frontend_web/ui/home/homeView.dart';
import 'package:frontend_web/widgets/centeredView/centeredView.dart';
import 'package:frontend_web/widgets/homeNavigationBar/navigationBar.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AboutUs extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        endDrawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile
            ? HomeNavigationDrawer(2)
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
              (sizingInformation.deviceScreenType == DeviceScreenType.Mobile ) ? SizedBox(): HomeNavigationBar(2) ,
              Expanded(
                child: ScreenTypeLayout(
                  mobile: AboutUsMobile(),
                  desktop: AboutUsDesktop(),
                  tablet: AboutUsMobile(),
                ),
              )
            ],
          ),
        )
      )
    );
  }
}

class AboutUsMobile extends StatelessWidget{
 
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
            Image.asset('assets/undraw3.png'),
            AboutUsWidget(),
          ],
        )
      ],
    );
  }
}

class AboutUsDesktop extends StatelessWidget{
 
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      shrinkWrap: true,
      children: <Widget>[ 
        Column(children: <Widget>[
           Center(
              child: Image.asset('assets/undraw3.png',width: 600, height: 400, ),
            ),
          AboutUsWidget(),
        ],)
      ]
    );
  }
}

class AboutUsWidget extends StatelessWidget{
 
  @override
  Widget build(BuildContext context) {
     return  ResponsiveBuilder(
      builder: (context, sizingInformation){
        var textAligment = sizingInformation.deviceScreenType == DeviceScreenType.Desktop
          ? TextAlign.left
          : TextAlign.center;
        double titleSize = sizingInformation.deviceScreenType == DeviceScreenType.Mobile
          ? 30
          : 50;
        double descSize = sizingInformation.deviceScreenType == DeviceScreenType.Mobile
          ? 16
          : 21;  


        return Container(
          width: 800,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "MOJ GRAD",
                style: TextStyle(fontWeight: FontWeight.w800, height: 0.9, fontSize: titleSize,),
                textAlign: textAligment,
              ),
              SizedBox(height: 50,),
              Text(
                "Jedan od najvećih problema sa kojima se današnje društvo suočava je zagađenje životne sredine.Odatle proizlazi ideja da se napravi aplikacija koja bi na zanimljiv i lak način pomogla korisnicima u rešavanju trenutnih ekoloških problema u svojoj okolini.\nSama web aplikacija je namenjena svim zainteresovanim ekološkim društvima, institucijama i ostalim grupama.\nOsnovna misija je rešavanje izazove koje su korisnici prijavili ili oragnizovanje okupljanja u cilju motivacije ostalih korisnika.\n",
                style: TextStyle(fontSize: descSize, height: 1.7),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        );
      }
    );
  }
}