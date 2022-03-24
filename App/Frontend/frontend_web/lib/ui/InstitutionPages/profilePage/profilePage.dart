import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../models/fullPost.dart';
import '../../../models/institution.dart';
import '../../../services/api.services.dart';
import '../../../services/token.session.dart';
import '../../../widgets/circleImageWidget.dart';
import '../../../widgets/collapsingInsNavigationDrawer.dart';
import '../../../widgets/post/insRowPost/insRowPostDesktop.dart';

Color greenPastel = Color(0xFF00BFA6);

class ProfilePage extends StatefulWidget {

  final int insId;
  ProfilePage({Key key, this.insId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int id;
  Institution institution;
  List<FullPost> listPosts;
  int pn; // postsNumber

  @override
  initState() {
    super.initState();
    id  = widget.insId;
    _getIns(id);
    _getPostsSolvedByIns(id);
  }


  _getIns(int id) async {
    var res = await APIServices.getInstitutionById(TokenSession.getToken, id);
    Map<String, dynamic> jsonInst = jsonDecode(res.body);
    Institution inst = Institution.fromObject(jsonInst);
    setState(() {
      institution = inst;
    });
  }

  _getPostsSolvedByIns(int id) async {
    var res =  await APIServices.getPostsSolvedByInstitution(TokenSession.getToken, id).then((res) {
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



  Widget currentInstitution(){
    return Container(
        color:Colors.white,
        padding: EdgeInsets.all(10),
        // margin: EdgeInsets.only(top: 5),
        width:500,
        height:520,
        child:
        ListView(
            children: <Widget>[
              SizedBox(height:10),
              Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(5),
                  //margin: EdgeInsets.only(top: 5),
                  child: Column(children: [
                    CircleImage(
                      userPhotoURL + institution.photoPath,
                      imageSize: 100.0,
                      whiteMargin: 2.0,
                      imageMargin: 6.0,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                  ]
                  )
              ),
              ListTile(
                leading: Icon(Icons.person,  color: greenPastel),
                title: Text('Naziv institucije'),
                subtitle: Text(institution.name),
              ),
              ListTile(
                leading: Icon(Icons.description,  color: greenPastel),
                title: Text('Opis delatnosti institucije'),
                subtitle: Text(institution.description),
              ),
              ListTile(
                leading: Icon(Icons.location_city,  color: greenPastel),
                title: Text('Sedište'),
                subtitle: Text(institution.cityName),
              ),
              ListTile(
                leading: Icon(Icons.confirmation_number,  color: greenPastel),
                title: Text('Broj rešenih objava'),
                subtitle: Text(institution.postsNum.toString()),
              ),
            ]
        )
    );
  }






  Widget tabs() {
    return TabBar(
      //onTap
        labelColor: greenPastel,
        indicatorColor: greenPastel,
        unselectedLabelColor: Colors.black,
        tabs: <Widget>[
          Tab(
            child: Text("PROFIL INSTITUCIJE",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Tab(
            child: Text("REŠENE OBJAVE",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ]);
  }





  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottom: tabs(),
        ),
        body: Stack(
          children: <Widget>[
            TabBarView(children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 10),
                  color: Colors.grey[100],
                  child: Column(children: [
                    Flexible(
                        child:RefreshIndicator(
                        onRefresh: _handleRefresh,
                          child:   institution != null ? currentInstitution() : Center(
                            child: CircularProgressIndicator(
                              valueColor:
                              new AlwaysStoppedAnimation<Color>(Color(0xFF00BFA6)),
                            ),
                          ),)
                    )
                  ])
              ),
              Container(
                  padding: EdgeInsets.only(top: 0),
                  color: Colors.grey[100],
                  child: Column(children: [
                    Flexible(
                      child: RefreshIndicator(
                        onRefresh: _handleRefresh2,
                          child: ListView.builder(
                              padding: EdgeInsets.only(bottom: 30.0),
                              itemCount: listPosts == null ? 0 : listPosts.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InsRowPostDesktopWidget(listPosts[index], 1);
                              }
                          )
                  )

                    )]
                  )
              ),
            ]),
            CollapsingInsNavigationDrawer(),
          ],
        ),
      ),
    );
  }
  
  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 3));
    setState(() {
      institution = null;
    });
    _getIns(id);
    return null;
  }

  Future<Null> _handleRefresh2() async {
    await new Future.delayed(new Duration(seconds: 3));
    setState(() {
      listPosts = [];
    });
    _getPostsSolvedByIns(id);
    return null;
  }

}