import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/models/fullPost.dart';
import 'package:frontend/models/institution.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/widgets/postWidget.dart';

import '../main.dart';


Color greenPastel = Color(0xFF00BFA6);

class InstitutionProfile extends StatefulWidget {
  
  final int instId;
  InstitutionProfile(this.instId);

  @override
  _InstitutionProfileState createState() => _InstitutionProfileState(instId);
}

class _InstitutionProfileState extends State<InstitutionProfile> {
  
  int instId;
  Institution institution;
  ScrollController _scrollController;
  List<FullPost> posts;
  
  _InstitutionProfileState(int inst1){
    this.instId = inst1;
  }

  _getPosts() async {
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getPostsSolvedByInstitution(jwt, instId).then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> listP = List<FullPost>();
      listP = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          posts = listP;
        });
      }
    });
  }

  _getInstitution() async {
     var jwt = await APIServices.jwtOrEmpty();
    var res = await APIServices.getInstitutionById(jwt, instId);
    print(res.body);
    Map<String, dynamic> jsonUser = jsonDecode(res.body);
    Institution user = Institution.fromObject(jsonUser);
    setState(() {
      institution = user;
    });
  
  }

  @override
  void initState() {
    super.initState();
    _getInstitution();
    _getPosts();
  }

 Widget infoInstitution(BuildContext context)
 {
   return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.black26,
            width: 1.0,
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                userImageWithPlus(),
                SizedBox(width: 10,),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        institution.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Lokacija: ' + institution.cityName,
                        style: TextStyle(
                            color: Colors.black),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        institution.description,
                        style: TextStyle(
                            color: Colors.black),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // For padding
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
 }

   Widget userImageWithPlus() => Column(
        children: <Widget>[
          Container(
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage( serverURLPhoto + institution.photoPath),
              ),
            ),
          ),
          Column(
                  children: <Widget>[
                    Text("Broj rešenih",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Text("${institution.postsNum}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold))
                  ],
                )

        ],
      );

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyApp.ind == 0
            ? Colors.white
            : Theme.of(context).copyWith().backgroundColor,
        iconTheme:
            IconThemeData(color: Theme.of(context).copyWith().iconTheme.color),
      ),
      body: (institution != null)
          ? NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
                return <Widget>[
                  // User information section
                  SliverToBoxAdapter(child: infoInstitution(context)),
                ];
              },
              body: (posts != null)
                  ? ListView.builder(
                      padding: EdgeInsets.only(bottom: 30.0),
                      itemCount: posts == null ? 0 : posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PostWidget(posts[index]);
                      })
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Color(0xFF00BFA6)),
                      ),
                    ))
          : Center(
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Color(0xFF00BFA6)),
              ),
            ),
    );
  }
}