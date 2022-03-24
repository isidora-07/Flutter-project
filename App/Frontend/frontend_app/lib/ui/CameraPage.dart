import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend/models/city.dart';
import 'package:frontend/models/postType.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/services/images.dart';
import 'dart:io';
import 'package:frontend/services/api.services.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
// import 'package:nominatim_location_picker/nominatim_location_picker.dart';
import 'package:path/path.dart';

import '../main.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  User user;
  int postTypeId;
  var description = TextEditingController();
  int statusId;
  int _vrstaObjave = 1;
  int _problemResava = 1;
  List<PostType> _postType;
  PostType postType;
  File imageFile;
  double latitude1 = 0;
  double longitude2 = 0;
  var first;
  String addres = '';
  String pogresanText = '';
  var id = 0;
  List<City> _city;
  City city;
  LatLng location;
  Geolocator get geolocator => Geolocator()..forceAndroidLocationManager;

  _getUser() async {
    var jwt = await APIServices.jwtOrEmpty();
    var res = await APIServices.getUser(jwt, userId);
    Map<String, dynamic> jsonUser = jsonDecode(res.body);
    User user1 = User.fromObject(jsonUser);
    setState(() {
      user = user1;
    });
  }

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

  //function that adds cities to list
  _getCity() async {
    APIServices.getCity().then((res) {
      Iterable list = json.decode(res.body);
      List<City> cities = new List<City>();
      cities = list.map((model) => City.fromObject(model)).toList();
      setState(() {
        _city = cities;
      });
    });
  }


  @override
  void initState() {
    super.initState();
    _getUser();
    _getPostType();
    _getCity();
  }

  // Function for opening a camera
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
    });
    first = _getUserLocation();
  }

  bool notNull(Object o) => o != null;
  @override
  Widget build(BuildContext context) {
    // Chosing what post type should be

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

    final vrstaObjave = Row(
      children: <Widget>[
        Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Vrsta objave: ",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyText1.color),
            )),
        Text("Problem", style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
        Flexible(
          child: Radio(
            value: 1,
            groupValue: _vrstaObjave,
            onChanged: (int value) {
              setState(() {
                _vrstaObjave = value;
              });
            },
            focusColor: Color(0xFF00BFA6),
            activeColor: Color(0xFF00BFA6),
          ),
        ),
        Text("Pohvala", style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
        Flexible(
          child: Radio(
            value: 2,
            groupValue: _vrstaObjave,
            onChanged: (int value) {
              setState(() {
                _vrstaObjave = value;
              });
            },
            focusColor: Color(0xFF00BFA6),
            activeColor: Color(0xFF00BFA6),
          ),
        ),
      ],
    );

    // Chosing who will do that assigment
    final problemResava = Row(
      children: <Widget>[
        Align(
            alignment: Alignment.topLeft,
            child: Text("Problem rešava: ",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyText1.color))),
        Text("Rešiću sam", style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
        Flexible(
          child: Radio(
            value: 1,
            groupValue: _problemResava,
            onChanged: (int value) {
              setState(() {
                _problemResava = value;
              });
            },
            focusColor: Color(0xFF00BFA6),
            activeColor: Color(0xFF00BFA6),
          ),
        ),
        Text("Neko drugi", style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
        Flexible(
          child: Radio(
            value: 2,
            groupValue: _problemResava,
            onChanged: (int value) {
              setState(() {
                _problemResava = value;
              });
            },
            focusColor: Color(0xFF00BFA6),
            activeColor: Color(0xFF00BFA6),
          ),
        ),
      ],
    );

    // Chosing type of assigment
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

    final _dropDownCity = Row(
      children: <Widget>[
        Align(
            alignment: Alignment.topLeft,
            child: Text("Grad: ",
                style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyText1.color))),
        _city != null
            ? DropdownButton<City>(
                hint: Text("Izaberi", style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
                value: city,
                onChanged: (City value) {
                  setState(() {
                    city = value;
                  });
                },
                items: _city.map((City option) {
                  return DropdownMenuItem<City>(
                    value: option,
                    child: Text(option.name),
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

    // button for current location
    final currentLocation = RaisedButton.icon(
      label: Flexible(
        child: Text('Trenutna lokacija', style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
      ),
      onPressed: () {
        currentLocationFunction();
        _getUserLocation();
      },
      icon: Icon(Icons.my_location, size: 20),
      color: Color(0xFF00BFA6),
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(50),
      ),
    );

    // button for choosing location
    final chooseLocation = RaisedButton.icon(
      label: Flexible(
        child: Text('Izaberi lokaciju', style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
      ),
      onPressed: () async{
        await getLocationWithNominatim();
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
          child: currentLocation,
          flex: 10,
        ),
        Expanded(
          child: Container(color: Colors.white),
          flex: 1,
        ),
        Expanded(
          child: chooseLocation,
          flex: 10,
        ),
      ],
    );

    // Description of assigment or praise
    final opis = TextField(
      cursorColor: MyApp.ind == 0 ? Colors.black : Colors.white,
      controller: description,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        hintText: (_vrstaObjave == 1) ? 'Opis problema' : 'Opis pohvale',
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
        imageUpload(imageFile);

        APIServices.jwtOrEmpty().then((res) {
          String jwt;
          setState(() {
            jwt = res;
          });
          if (_problemResava == 1)
            statusId = 1;
          else
            statusId = 2;

          if (_vrstaObjave == 2) //pohvala
            postTypeId = 1;
          else if (postType != null)
            postTypeId = postType.id;
          else if(_vrstaObjave != 2)
            pogresanText = "Popunite obavezna polja: tip objave, grad i lokaciju.";

          if (imageFile == null || addres == null) {
            setState(() {
              pogresanText = "Popunite obavezna polja: tip posta i lokaciju.";
            });
            throw Exception('Greška');
          }
          if (res != null && imageFile != null && addres != null && city!= null) {
            APIServices.addPost(
                jwt,
                user.id,
                postTypeId,
                description.text,
                "Upload//Post//" + basename(imageFile.path),
                null,
                statusId,
                latitude1,
                longitude2,
                addres, city.id);
            APIServices.jwtOrEmpty().then((res) {
              String jwt;
              setState(() {
                jwt = res;
              });
              if (res != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage.fromBase64(jwt.toString())),
                );
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

    return Center(
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
          vrstaObjave,
          _vrstaObjave == 1
              ? Column(children: <Widget>[problemResava, _dropDown])
              : null,
          _dropDownCity,
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
            height: 20.0,
          ),
          submitObjavu,
          wrongData
        ].where(notNull).toList(),
      ),
    ));
  }
}
