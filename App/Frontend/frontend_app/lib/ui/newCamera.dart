import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/widgets/cameraOne.dart';
import 'package:frontend/widgets/cameraThree.dart';
import 'package:frontend/widgets/cameraTwo.dart';
import 'package:path/path.dart';

class NewCameraPage extends StatefulWidget {
  @override
  _NewCameraPageState createState() => _NewCameraPageState();
}

class _NewCameraPageState extends State<NewCameraPage>{
  
  @override
  Widget build(BuildContext context) {

    final camera1 = InkWell(
      child: Card(
        child: Container(
          decoration: BoxDecoration(

          ),
          constraints: BoxConstraints(
            minHeight: 200,
            maxHeight: 200
          ),
          child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.add_a_photo, size: 30,),
              Text("Prijavi problem")
            ],
          ),),
        ),
      ),
      onTap: (){
        print("Camera 1");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CameraOne()),
        );
      },
    );

    final camera2 =InkWell(
      child: Card(
        child: Container(
          decoration: BoxDecoration(

          ),
          constraints: BoxConstraints(
            minHeight: 200,
            maxHeight: 200
          ),
          child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.photo_library, size: 30,),
              Text("Reši problem")
            ],
          ),),
        ),
      ),
      onTap: (){
        print("Camera 2");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CameraTwo()),
        );
      },
    );

    final camera3 =InkWell(
      child: Card(
        child: Container(
          decoration: BoxDecoration(
            
          ),
          constraints: BoxConstraints(
            minHeight: 100,
            maxHeight: 100
          ),
          child: Center(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.nature_people, size: 30,),
              Text("Lepša strana grada")
            ],
          ),),
        ),
      ),
      onTap: (){
        print("Camera 3");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CameraThree()),
        );
      },
    );

    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(child:camera1),
              Expanded(child:camera2)
            ],),
            camera3
          ],
        ),
      ),
    );
  }
}


