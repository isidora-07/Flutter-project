import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/ui/splash.page.dart';
import 'package:frontend/widgets/uploadScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/services/images.dart';
import 'dart:io';
import 'package:frontend/services/api.services.dart';
import 'package:path/path.dart';

import '../main.dart';

class ChallengeSolvingCameraPage extends StatefulWidget {
  final int postId;
  final int ownerId;

  ChallengeSolvingCameraPage(this.postId, this.ownerId);

  @override
  _ChallengeSolvingCameraPageState createState() =>
      _ChallengeSolvingCameraPageState(postId, ownerId);
}

class _ChallengeSolvingCameraPageState
    extends State<ChallengeSolvingCameraPage> {
  int postId;
  int ownerId;

  _ChallengeSolvingCameraPageState(int postId1, int ownerId1) {
    this.postId = postId1;
    this.ownerId = ownerId1;
  }

  var description = TextEditingController();
  String pogresanText = "";
  File imageFile;
  var first;
  var id = 0;

  @override
  void initState() {
    super.initState();
  }

  // Function for opening a camera
  _openGalery() async {
    var picture = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    if(picture != null)
      print("Kompresovana " + picture.lengthSync().toString());
    this.setState(() {
      imageFile = picture;
    });
  }

  // Function for opening a gallery
  _openCamera() async {
    var picture = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    if(picture != null)
      print("Kompresovana " + picture.lengthSync().toString());
    this.setState(() {
      imageFile = picture;
    });
  }

  bool notNull(Object o) => o != null;
  @override
  Widget build(BuildContext context) {
    // Pick image from your camera live
    final cameraPhone = MaterialButton(
      onPressed: () {
        _openCamera();
      },
      color: Color(0xFF00BFA6),
      textColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.camera_alt,
              size: 30,
              color: Theme.of(context).textTheme.bodyText1.color), // icon
          Text(
            "Kamera",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      shape: CircleBorder(),
    );

    // Pick image from your gallery
    final cameraGalery = MaterialButton(
      onPressed: () {
        _openGalery();
      },
      color: Color(0xFF00BFA6),
      textColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.add_photo_alternate,
              size: 30, color: Theme.of(context).textTheme.bodyText1.color), // icon
          Text(
            "Galerija",
            style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
          ), // text
        ],
      ),
      padding: EdgeInsets.all(16),
      shape: CircleBorder(),
    );

    // Row with camera buttons
    final izaberiKameru = Row(
      children: <Widget>[
        Expanded(
          child: cameraPhone,
          flex: 10,
        ),
        Expanded(
          child: Container(color: Colors.white),
          flex: 1,
        ),
        Expanded(
          child: cameraGalery,
          flex: 10,
        ),
      ],
    );

    // Description of assigment or praise
    final opis = TextField(
      inputFormatters:[
      LengthLimitingTextInputFormatter(100),
      ],
      cursorColor: MyApp.ind == 0 ? Colors.black : Colors.white,
      controller: description,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        hintText: 'Opis rešenja',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 2, color: Color(0xFF00BFA6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1, color: Color(0xFF00BFA6)),
        ),
      ),
    );

    // Submit it
    final submitObjavu = RaisedButton.icon(
      color: Color(0xFF00BFA6),
      label: Flexible(
        child: Text('Objavi'),
      ),
      onPressed: () async{
        imageUpload(imageFile);

        APIServices.jwtOrEmpty().then((res) {
          String jwt;
          setState(() {
            jwt = res;
          });

          if (imageFile == null) {
            setState(() {
              pogresanText = "Izaberite fotografiju.";
            });
            throw Exception('Greška');
          }
          if (res != null && imageFile != null) {
            APIServices.insertSolution(jwt, userId, postId, description.text,
                    "Upload//Post//" + basename(imageFile.path), 0)
                .then((res) async {
              if (res.statusCode == 200) {
                print("Uspešno ste objavili rešenje.");
                print(res.body);
               // if(ownerId != publicUser.id)
                //  sendNotification("Rešenje", "Predloženo je rešenje za Vaš problem",1, ownerId);
                
                int nmm = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UploadScreenSolver()),
                );
                if(nmm == 1)
                  Navigator.pop(context);
              }
            });
          }
        });
      },
      icon: Icon(Icons.nature_people),
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(50),
      ),
    );

    final wrongData = Center(
        child: Text(
      '$pogresanText',
      style: TextStyle(color: Colors.red),
    ));

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: MyApp.ind == 0 ? Colors.white :  Theme.of(context).copyWith().backgroundColor,
        iconTheme: IconThemeData(
            color: Theme.of(context).copyWith().iconTheme.color,
            size: Theme.of(context).copyWith().iconTheme.size),
      ),
      body: Center(
          child: Container(
        width: 400,
        child: ListView(
          shrinkWrap: true,
          padding:
              EdgeInsets.only(left: 15.0, right: 15.0, top: 0.0, bottom: 24.0),
          children: <Widget>[
            izaberiKameru,
            SizedBox(height: 30),
            imageFile != null
                ? Image.file(
                    imageFile,
                    width: 300,
                    height: 300,
                  )
                : null,
            SizedBox(
              height: 20.0,
            ),
            opis,
            SizedBox(
              height: 20.0,
            ),
            submitObjavu,
            wrongData
          ].where(notNull).toList(),
        ),
      )),
    );
  }
}
