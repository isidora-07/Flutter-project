import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_web/models/report.dart';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewManageUser.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';
import 'package:frontend_web/widgets/mobileDrawer/drawerAdmin.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:frontend_web/extensions/hoverExtension.dart';

Color greenPastel = Color(0xFF00BFA6);

class ReportedUserPage extends StatefulWidget {

  final int id;

  ReportedUserPage(this.id);


  @override
  _ReportedUserPageState createState() => _ReportedUserPageState(id);
}

class _ReportedUserPageState extends State<ReportedUserPage> {
  
   int id;

  _ReportedUserPageState(int id){
    this.id = id;
  }

  @override
  Widget build(BuildContext context) {
     return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        drawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
          ? DrawerAdmin(4)
          : null,
        appBar: sizingInformation.deviceScreenType != DeviceScreenType.Mobile
          ? null
          : AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
        backgroundColor: Colors.white,
        body: Row(
            children: <Widget>[
              Expanded(
                child: ScreenTypeLayout(
                  mobile:ReportedUserMobilePage(id),
                  desktop: ReportedUserDesktopPage(id),
                  tablet: ReportedUserDesktopPage(id),
                ),
              )
            ],
          ),
        )
    );
}

}


class ReportedUserMobilePage extends StatefulWidget{
  final int id;

  ReportedUserMobilePage(this.id);
  @override
  _ReportedUserMobilePageState createState() => new _ReportedUserMobilePageState();
}

class _ReportedUserMobilePageState extends State<ReportedUserMobilePage>{
    List<Report> listReports;

  _getReportedUser(int id) {
    APIServices.getReportedUser(TokenSession.getToken,id).then((res) {
      Iterable list = json.decode(res.body);
      List<Report> listR = List<Report>();
      listR = list.map((model) => Report.fromObject(model)).toList();
      if (mounted) {
        setState( () {
          listReports = listR;
        });
      }
    });
  }
   void initState() {
    super.initState();
    _getReportedUser(widget.id);
  }

   Widget buildReportsList() {
    //_getReportedUser(widget.id);
    return ListView.builder(
      itemCount: listReports == null ? 0 : listReports.length,
      itemBuilder: (BuildContext context, int index) {
        return Center(child: Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [               
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(listReports[index].username,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Text(
                                  listReports[index].firstName +
                                      " " +
                                      listReports[index].lastName,
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,fontSize: 11 ))
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(width: 20),
                       
                            Text(
                                listReports[index].reportTypeName,
                                style: TextStyle(color: Colors.grey),
                              ),
							            Text(
                              listReports[index].time.toString(),
                              style: TextStyle(color: Colors.grey),
                            ),
							
                          ],
                        ),
                      ])),
                ],
              ),
            )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CenteredViewManageUser(
        child: 
          Column(children: [
            RaisedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  color: greenPastel,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: greenPastel)
                  ),
                  child: Text("Vrati se nazad", style: TextStyle(color: Colors.white),),
                ),
            Text("Spisak žalbi", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), ),
            Flexible(child: buildReportsList() ),
          ]),
    
      );
  }
}

class ReportedUserDesktopPage extends StatefulWidget{
  final int id;

  ReportedUserDesktopPage( this.id);
  @override
  _ReportedUserDesktopPageState createState() => new _ReportedUserDesktopPageState();
}

class _ReportedUserDesktopPageState extends State<ReportedUserDesktopPage>{
    List<Report> listReports;

  _getReportedUser(int id) {
    APIServices.getReportedUser(TokenSession.getToken,id).then((res) {
      Iterable list = json.decode(res.body);
      List<Report> listR = List<Report>();
      listR = list.map((model) => Report.fromObject(model)).toList();
      if (mounted) {
        setState( () {
          listReports = listR;
        });
      }
    });
  }
   void initState() {
    super.initState();
    _getReportedUser(widget.id);
  }

    Widget buildReportsList() {
    //_getReportedUser(widget.id);
    return ListView.builder(
      itemCount: listReports == null ? 0 : listReports.length,
      itemBuilder: (BuildContext context, int index) {
        return Center(child: Container(
          width: 800,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [               
                        Container(
                          width: 180,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(listReports[index].username,
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                  listReports[index].firstName +
                                      " " +
                                      listReports[index].lastName,
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic, fontSize: 15))
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(width: 20),
                       
                            Text(
                              'Datum prijave',
                              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                            ),
							            Text(
                              listReports[index].time.toString(),
                              style: TextStyle(color: Colors.grey),
                            ),
							
                          ],
                        ),
                  SizedBox(width: 30),
                        Container(
                          width:200,
                        child:Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Razlog prijave',
                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                              ),),
                            Align(
                              alignment:Alignment.center,
                              child:Text(
                                listReports[index].reportTypeName,
                                style: TextStyle(color: Colors.grey),
                              ),),
                          ],
                        ),),
                      ])),
                ],
              ),
            )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CenteredViewManageUser(
          child: 
            Column(children: [
               RaisedButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  color: greenPastel,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: greenPastel)
                  ),
                  child: Text("Vrati se nazad", style: TextStyle(color: Colors.white),),
                ).showCursorOnHover,
              Text("Spisak žalbi", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), ),
              Flexible(
                  child: buildReportsList()),
            ]),
        ),
        CollapsingNavigationDrawer()
      ],
    );
  }
}


