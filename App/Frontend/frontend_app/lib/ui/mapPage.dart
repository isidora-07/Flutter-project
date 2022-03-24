import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend/models/city.dart';
import 'package:frontend/models/fullPost.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/ui/splash.page.dart';
import 'package:frontend/widgets/postWidget.dart';
import 'package:latlong/latlong.dart';

import '../main.dart';

class MapPage extends StatefulWidget {
  final double postLatitude;
  final double postLongitude;
  MapPage({
    this.postLatitude = 0,
    this.postLongitude = 0
  });
  @override
  _MapPageState createState() => _MapPageState(postLatitude, postLongitude);
}

class _MapPageState extends State<MapPage> {
  double postLatitude;
  double postLongitude;

  _MapPageState(double postLatitude1, double postLongitude1){
    postLatitude = postLatitude1;
    postLongitude = postLongitude1;
  }

  List<FullPost> listPosts;
  City _city;
  
  _getCity() async {
     var jwt = await APIServices.jwtOrEmpty();
    APIServices.getCityById(jwt,publicUser.cityId).then((res) {
      Map<String, dynamic> list = json.decode(res.body);
      City city = City();
      city = City.fromObject(list);
      setState(() {
        _city = city;
      });
    });
  }

  _getPosts() async {
     var jwt = await APIServices.jwtOrEmpty();
    APIServices.getUnsolvedPosts(jwt).then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> listP = List<FullPost>();
      listP = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listPosts = listP;
        });
      }
    });
  }

  @override
  void initState() {
    _getCity();
    _getPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Marker> markers = [];
    if (listPosts != null)
      for (var i = 0; i < listPosts.length; i++) {
        markers.add(
          new Marker(
            point: new LatLng(listPosts[i].latitude, listPosts[i].longitude),
            builder: (ctx) => new Container(
                child: IconButton(
              icon: Icon(Icons.location_on),
              iconSize: 40.0,
              color: Colors.red,
              onPressed: () {
                showBottomSheet(
                  context: ctx,
                  builder: (ctx) {
                    return Container(
                      constraints: BoxConstraints(
                        maxHeight: 500.0, // changed to 400
                        minHeight: 200.0, // changed to 200
                        maxWidth: double.infinity,
                        minWidth: double.infinity,
                      ),
                      child: PostWidget(listPosts[i]),
                    );
                  },
                );
              },
            )),
          ),
        );
      }

    return Scaffold(
      appBar: (postLatitude != 0 && postLongitude != 0)?
      AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).copyWith().iconTheme.color),
        backgroundColor: MyApp.ind == 0 ? Colors.white :  Theme.of(context).copyWith().backgroundColor) : null,
      body: (_city != null)?FlutterMap(
        options: new MapOptions(
          center: (postLatitude == 0 && postLongitude == 0)? new LatLng(_city.latitude, _city.longitude) : new LatLng(postLatitude, postLongitude),
          zoom: (postLatitude == 0 && postLongitude == 0)? 14.5 : 16,
        ),
        layers: [
          new TileLayerOptions(
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/lavops/ck8m295d701du1iqid1ejoqxu/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibGF2b3BzIiwiYSI6ImNrOG0yNm05ZDA4ZDcza3F6OWZpZ3pmbHUifQ.FBDBK21WD6Oa4V_5oz5iJQ",
              additionalOptions: {
                'accessToken':
                    'pk.eyJ1IjoibGF2b3BzIiwiYSI6ImNrOG0yNm05ZDA4ZDcza3F6OWZpZ3pmbHUifQ.FBDBK21WD6Oa4V_5oz5iJQ',
                'id': 'mapbox.mapbox-streets-v7'
              }),
          new MarkerLayerOptions(markers: markers),
        ],
      ):Center(),
    );
  }
}
