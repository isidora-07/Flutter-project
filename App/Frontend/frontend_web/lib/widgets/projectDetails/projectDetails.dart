import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ProjectDetails extends StatelessWidget{
 
  @override
  Widget build(BuildContext context) {
    return  ResponsiveBuilder(
      builder: (context, sizingInformation){
        var textAligment = sizingInformation.deviceScreenType == DeviceScreenType.Desktop
          ? TextAlign.left
          : TextAlign.center;
        double titleSize = sizingInformation.deviceScreenType == DeviceScreenType.Mobile
          ? 30
          : 80;
        double descSize = sizingInformation.deviceScreenType == DeviceScreenType.Mobile
          ? 16
          : 21;  

        return Container(
          width: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "MOJ GRAD",
                style: TextStyle(fontWeight: FontWeight.w800, height: 0.9, fontSize: titleSize),
                textAlign: textAligment,
              ),
              SizedBox(height: 50,),
              Text(
                "Zajedno možemo da menjamo naš grad i učinimo ga boljim mestom za život!",
                style: TextStyle(fontSize: descSize, height: 1.7),
                textAlign: textAligment,
              ),
            ],
          ),
        );
      }
    );
  }
}