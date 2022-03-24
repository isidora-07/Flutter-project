import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:map_controller/map_controller.dart';

class Mapa extends StatefulWidget {
  double x;
  double y;

  double izabranaX =0;
  double izabranaY=0;

  Mapa(double _x,double _y){
    this.x=_x;
    this.y=_y;
    this.izabranaX=_x;
    this.izabranaY=_y;
  }

  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  MapController mapController;
  StatefulMapController statefulMapController;
  StreamSubscription<StatefulMapControllerStateChange> sub;

  bool ready = false;
  //Position trenutnaPozicija;
  
  
  @override
  void initState() {
    mapController = MapController();
    /*MapaAPI.dajPoziciju().then((value) {
      setState(() {
        trenutnaPozicija = value;
      });
    });*/
    statefulMapController = StatefulMapController(mapController: mapController);
    statefulMapController.onReady.then((_) => setState(() => ready = true));
    sub = statefulMapController.changeFeed.listen((change) => setState(() {}));
    super.initState();
  }
  
  @override
  void dispose() {
    sub.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Stack(
        children: <Widget>[
         FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: LatLng(widget.x, widget.y),
            zoom: 17.0,
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
            MarkerLayerOptions(
              markers: statefulMapController.markers,
            ),
          ],
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
          child: RaisedButton(
            color: Color(0xFF00BFA6),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
            ),
            onPressed: (){
              widget.izabranaX=mapController.center.latitude;
              widget.izabranaY=mapController.center.longitude;
              print(widget.izabranaX.toString()+" "+widget.izabranaY.toString());
              Navigator.pop(context);
              },
            child: Text("Potvrdi",style: TextStyle(fontSize: 20,color:Colors.white),), 
          ),
        ),
        Container(
          child: Icon(Icons.location_on,size: 35,color: Color(0xFF00BFA6),),
          alignment: Alignment.center,
        ),
        ],
      ),
    );
  }
}