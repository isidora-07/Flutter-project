import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend/main.dart';
import 'package:frontend/models/city.dart';
import 'package:frontend/models/postType.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/services/images.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/widgets/novaMapaProba.dart';
import 'package:frontend/widgets/uploadScreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
//import 'package:nominatim_location_picker/nominatim_location_picker.dart';
import 'package:path/path.dart';

class CameraOne extends StatefulWidget {
  @override
  _CameraOneState createState() => _CameraOneState();
}

class _CameraOneState extends State<CameraOne>{
  
  
  PostType postType;
  List<PostType> _postType;
  
  File imageFile;
  var description = TextEditingController();
  String pogresanText = '';
  String loadingText = "";

  var first;
  double latitude1 = 0;
  double longitude2 = 0;
  String addres = '';
  LatLng location;
  bool isDisable = false;
  Geolocator get geolocator => Geolocator()..forceAndroidLocationManager;

  _getPostType() async {
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getPostType(jwt).then((res) {
      Iterable list = json.decode(res.body);
      List<PostType> postTypes = new List<PostType>();
      postTypes = list.map((model) => PostType.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          _postType = postTypes;
        });
      }
    });
  }

  _openGalery() async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if(picture != null)
      print("Kompresovana " + picture.lengthSync().toString());
    this.setState(() {
      imageFile = picture;
    });
  }

  _getUserLocation() async {
    try {
      List<Placemark> p =
          await geolocator.placemarkFromCoordinates(latitude1, longitude2);
      Placemark place = p[0];
      setState(() {
        addres =
            "${place.locality},${place.thoroughfare}${place.subThoroughfare},${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  // Function for opening a gallery
  _openCamera() async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if(picture != null)
      print("Kompresovana " + picture.lengthSync().toString());
    this.setState(() {
      imageFile = picture;
    });
  }

  // Funciton to get current location
  currentLocationFunction() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return;
      }
    }

    _locationData = await location.getLocation();

    setState(() {
      latitude1 = _locationData.latitude;
      longitude2 = _locationData.longitude;
      isDisable = true;
    });
    first = _getUserLocation();
  }

  bool notNull(Object o) => o != null;

  @override
  void initState() {
    super.initState();
    _getPostType();
    currentLocationFunction();
  }

  @override
  Widget build(BuildContext context) {

   final loader = Center(
      child: Text(
    '$loadingText',
    style: TextStyle(color: Color(0xFF00BFA6)),
    ));

    final _dropDown = Row(
      children: <Widget>[
        Align(
            alignment: Alignment.topLeft,
            child: Text("Kategorija: ",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyText1.color))),
        _postType != null
            ? DropdownButton<PostType>(
                hint: Text("Izaberi", style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
                value: postType,
                onChanged: (PostType value) {
                  setState(() {
                    postType = value;
                  });
                },
                items: _postType.map((PostType option) {
                  return DropdownMenuItem<PostType>(
                    value: option,
                    child: Text(option.typeName),
                  );
                }).toList(),
              )
            : DropdownButton<String>(
                hint: Text("Izaberi"),
                onChanged: null,
                items: null,
              ),
      ],
    );

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
              color: Theme.of(context).copyWith().iconTheme.color), // icon
          Text(
            "Kamera",
            style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
          ), // text
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
              size: 30,
              color: Theme.of(context).copyWith().iconTheme.color), // icon
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

    Future getLocationWithNominatim() async {
      Map result = await showDialog(
          context: context,
          builder: (BuildContext ctx) {
            /*return NominatimLocationPicker(
              searchHint: 'Pretraži',
              awaitingForLocation: "Čeka se lokacija.",
              customMapLayer: new TileLayerOptions(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/lavops/ck8m295d701du1iqid1ejoqxu/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibGF2b3BzIiwiYSI6ImNrOG0yNm05ZDA4ZDcza3F6OWZpZ3pmbHUifQ.FBDBK21WD6Oa4V_5oz5iJQ",
                additionalOptions: {
                  'accessToken':
                      'pk.eyJ1IjoibGF2b3BzIiwiYSI6ImNrOG0yNm05ZDA4ZDcza3F6OWZpZ3pmbHUifQ.FBDBK21WD6Oa4V_5oz5iJQ',
                  'id': 'mapbox.mapbox-streets-v7'
                }),
            );*/
          });
      if (result != null) {
        setState(() => location = result['latlng']);
        setState(() {
          latitude1 = location.latitude;
          longitude2 = location.longitude;
          _getUserLocation();
        });
      } else {
        return;
      }
    }

    // button for choosing location
    final chooseLocation = RaisedButton.icon(
      label: Flexible(
        child: Text('Izaberi lokaciju', style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
      ),
      onPressed: () {
        if(isDisable == false) currentLocationFunction();
        else{
          Mapa mapa;
        if(mapa == null){
          mapa = (latitude1 != null && longitude2 != null) ? Mapa(latitude1, longitude2) : Mapa(0, 0);
          latitude1 = mapa.izabranaX;
          longitude2 = mapa.izabranaY;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => mapa)).then((value){
              setState(() {
                latitude1 = mapa.izabranaX;
                longitude2 = mapa.izabranaY;
                _getUserLocation();
              });
            });
        }
      },
      icon: Icon(Icons.location_on,),
      color: Color(0xFF00BFA6),
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(50),
      ),
    );

    // row with location's buttons
    final locationRow = Row(
      children: <Widget>[
        Expanded(
          child: Container(color: Colors.white),
          flex: 1,
        ),
        Expanded(
          child: chooseLocation,
          flex: 5,
        ),
        Expanded(
          child: Container(color: Colors.white),
          flex: 1,
        ),
      ],
    );

    // Description of assigment or praise
    final opis = TextField(
     cursorColor: MyApp.ind == 0 ? Colors.black : Colors.white,
      controller: description,
      maxLength: 150,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        hintText: 'Opis ',
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
      label: Flexible(
        child: Text('Objavi', style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
      ),
      onPressed: () {
        

        APIServices.jwtOrEmpty().then((res) {
          String jwt;
          setState(() {
            jwt = res;
          });

          if (imageFile == null || addres == null  || postType == null) {
            setState(() {
              pogresanText = "Potrebno je uneti sliku, tip problema i lokaciju.";
            });
            throw Exception('Greskaaaa');
          }
          if (res != null && imageFile != null && addres != null && postType != null) {
            var name = addres.split(",");
             setState(() {
                  loadingText="Podaci se obrađuju...";
                });
            APIServices.getCityFromName(jwt, name[0].trim()).then((res) {
                setState(() {
                  loadingText = "";
                });
              if(res.statusCode == 200)
              {
                 Map<String, dynamic> jsonCity = jsonDecode(res.body);
                City cityFromBackend = City.fromObject(jsonCity);
                imageUpload(imageFile);
                 APIServices.addPost(
                jwt,
                userId,
                postType.id,
                description.text,
                "Upload//Post//" + basename(imageFile.path),
                null,
                2,
                latitude1,
                longitude2,
                addres, cityFromBackend.id);
            APIServices.jwtOrEmpty().then((res) {
              String jwt;
              setState(() {
                jwt = res;
              });
              if (res != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UploadScreen(jwt)),
                );
              }
            });
              }
              else
              {
                setState(() {
                  pogresanText = "Aplikacija nije dostupna u Vašem gradu. ";
                  loadingText = "";
                });
              }
            });
       
          }
        });
      },
      icon: Icon(Icons.nature_people),
      color: Color(0xFF00BFA6),
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
        backgroundColor: MyApp.ind == 0 ? Colors.white : Theme.of(context).copyWith().backgroundColor,
        iconTheme: IconThemeData(
            color: Theme.of(context).copyWith().iconTheme.color,
            size: Theme.of(context).copyWith().iconTheme.size),
      ),
      body: Center(
        child:ListView(
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
          _dropDown,
          SizedBox(
            height: 20.0,
          ),
          locationRow,
          latitude1 != 0 && longitude2 != 0
              ? Align(alignment: Alignment.topCenter, child: Text(addres))
              : null,
          SizedBox(
            height: 20.0,
          ),
          opis,
          SizedBox(
            height: 15.0,
          ),
          loader,
          SizedBox(
            height: 5.0,
          ),
          submitObjavu,
          wrongData
        ].where(notNull).toList(),
      ),
      )
    );
  }
  
}