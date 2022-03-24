import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_rounded_progress_bar/flutter_icon_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/widgets/circleImageWidget.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';
import 'home/contactPage.dart';


class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class SalesData {
  SalesData(this.month, this.number);

  final String month;
  final int number;
}

class _StatisticsPageState extends State<StatisticsPage> {
  var data = [2.0,0.0,3.0,1.0,2.0,2.0,4.0];
  var data1 = [0.0,-2.0,3.5,-2.0,0.5,0.7,0.8,1.0,2.0,3.0,3.2];

  List<CircularStackEntry> circularData = <CircularStackEntry>[
    new CircularStackEntry(
      <CircularSegmentEntry>[
        new CircularSegmentEntry(4.0, Color(0xff4285F4), rankKey: 'Rešeno'),
        new CircularSegmentEntry(6.0, Color(0xffcdf4f9), rankKey: 'Nerešeno'),
      ],
      rankKey: 'Quarterly Profits',
    ),
  ];

  List<User> listUsers;
   _getUsers() {
    APIServices.getUsers(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<User> listU = List<User>();
      listU = list.map((model) => User.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listUsers = listU;
        });
      }
    });
  }

 void initState() {
    super.initState();
    _getUsers(); 
 }
  
Material newDonation(){
    return Material(
      color: Colors.white,
      elevation: 14.0,
     // borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color.fromRGBO(210, 245, 203, 1),
      child: Card(
        child: Column( children: <Widget>[   
        Padding(
          padding: EdgeInsets.all(8.0),
          child:Text("NOVE DONACIJE",style:TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey
                      ),),),
          new Card(
            margin: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment:MainAxisAlignment.center,
               children: <Widget>[
                   SizedBox(width: 5),
                  new Column(
                children: <Widget>[
                      SizedBox(height: 5),
                      Text("PMF Kragujevac",style:TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),),
                    
                      Text("Donacija za sadnju drveća",style:TextStyle(
                        fontSize: 13.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),),

                      Text("Kratak opis koji će se ostaviti nakon ovog okupljanja.",style:TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),),
                     Container(
                      width:400,
                        child:IconRoundedProgressBar(
                          icon: Padding( padding: EdgeInsets.all(8), child: Icon(Icons.monetization_on)),
                          theme: RoundedProgressBarTheme.green,
                          margin: EdgeInsets.symmetric(vertical: 16),
                          borderRadius: BorderRadius.circular(6),
                          percent: 30,
                          )
                    ),
                    
                      Row(
                          children: <Widget>[
                           new Column(
                              children: <Widget>[
                              Text("Skupljeno:",style:TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                ),),                            
                                  Text("30 poena",style:TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                ),)                
                              ]),
                              SizedBox(width:200),
                             Column(
                              children: <Widget>[
                              Text("Potrebno:",style:TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                ),),                             
                                  Text("100 poena",style:TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                ),),                  
                          ],)
                          ]),
                      RaisedButton(
                        shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                        child: Text(
                          "Više informacija",
                          style: TextStyle(fontSize: 13.0),
                        ),
                        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        textColor: Colors.black,
                        color: Colors.white,
                        onPressed: () {
                        }
                        ),                   
                        SizedBox(height: 5),
                    ]),
                      
                            ],
                        ),
                  ),
               ],
              ),)
      );
  }       
    
  Material myCircularItems(String title){
    return Material(
      color: Colors.white,
      elevation: 14.0,
    //  borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color.fromRGBO(210, 245, 203, 1),
      child: Card(
        child:Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment:MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child:Text(title,style:TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                    ),
                      textAlign: TextAlign.left,),                    
                  ),
                       SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:Text("UKUPAN BROJ OBJAVA",style:TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                      textAlign: TextAlign.left,),
                  ),
                       SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:Text("UKUPAN BROJ REŠENIH OBJAVA",style:TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),                  
                      textAlign: TextAlign.left,),
                  ),
                ]),
                  Padding(
                    padding:EdgeInsets.all(8.0),
                    child:AnimatedCircularChart(
                      size: const Size(160.0, 160.0),
                      initialChartData: circularData,
                      chartType: CircularChartType.Pie,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Material eventPost(){
    return Material(
      color: Colors.white,
      elevation: 14.0,
     // borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color.fromRGBO(210, 245, 203, 1),
      child: Card(
        child: Column( children: <Widget>[   
        Padding(
          padding: EdgeInsets.all(8.0),
          child:Text("NOVI DOGAĐAJI",style:TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey
                      ),),),
          new Card(
            margin: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment:MainAxisAlignment.center,
               children: <Widget>[
                   SizedBox(width: 5),
                  new Column(
                children: <Widget>[
                      SizedBox(height: 5),
                      Text("Gradska čistoća",style:TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),),
                    
                    Text("Početak:",style:TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),),

                      Text("03/06/2020 08:50",style:TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),),

                      Text("Čišćenje parka",style:TextStyle(
                        fontSize: 13.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),),

                      Text("Kratak opis koji će se ostaviti nakon ovog okupljanja.",style:TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),),
                    
                      Text("Ulica Brđanska 48, Kragujevac, Srbija",style:TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),),

                      RaisedButton(
                        shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                        child: Text(
                          "Više informacija",
                          style: TextStyle(fontSize: 13.0),
                        ),
                        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        textColor: Colors.black,
                        color: Colors.white,
                        onPressed: () {
                        }
                        ),                   
                        SizedBox(height: 5),
                    ]),
                       SizedBox(width: 20),
                    new Column(
                      children: <Widget>[
                       Row(
                          children: <Widget>[
                            Icon(Icons.location_on,color:Colors.black),
                            Text("Kragujevac",style:TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.black,
                                ),),                         
                          ],
                        ),
 
                      Text("Završetak:",style:TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),),
                    
                      Text("08/06/2020 19:30",style:TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                      ),),                   
                    ]),   
                          SizedBox(width: 5),
                        ],
                        ),
                  ),
               ],
              ),)
      );
  }       
                  
 Material myPosts(String number){
    return Material(
      color: Colors.white,
      elevation: 14.0,
     // borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color.fromRGBO(210, 245, 203, 1),
      child: Card(
        child:Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment:MainAxisAlignment.center,
               children: <Widget>[
                  Padding(
                   padding: EdgeInsets.all(8.0),
                      child:Text("OBJAVE",style:TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey
                      ),),
                    ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                     child: Row(
                          children: <Widget>[
                            Icon(Icons.photo_library, color:Colors.black, size:80),
                            SizedBox(width: 20),
                            Text(number, style: TextStyle(color: Colors.grey, fontSize: 40.0)),
                            SizedBox(width: 20),
                          ],
                        ),
                  ),
               ],
              ),
            ],
          ),
        ),
      ),
    );
  }

 Material myEvents(String number){
    return Material(
      color: Colors.white,
      elevation: 14.0,
     // borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color.fromRGBO(210, 245, 203, 1),
      child: Card(
        child:Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment:MainAxisAlignment.center,
               children: <Widget>[
                  Padding(
                   padding: EdgeInsets.all(8.0),
                      child:Text("DOGAĐAJI",style:TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey
                      ),),
                    ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                     child: Row(
                          children: <Widget>[
                            Icon(Icons.calendar_today, color:Colors.black, size:80),
                            SizedBox(width: 20),
                            Text(number, style: TextStyle(color: Colors.grey, fontSize: 40.0)),
                            SizedBox(width: 20),
                          ],
                        ),
                  ),
               ],
              ),
            ],
          ),
        ),
      ),
    );
  }

   Material myAccounts(String number){
    return Material(
      color: Colors.white,
      elevation: 14.0,
     // borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color.fromRGBO(210, 245, 203, 1),
      child: Card(
        child:Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment:MainAxisAlignment.center,
               children: <Widget>[
                  Padding(
                   padding: EdgeInsets.all(8.0),
                      child:Text("KORISNICI",style:TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey
                      ),),
                    ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                     child: Row(
                          children: <Widget>[
                            Icon(Icons.account_circle, color:Colors.black, size:80),
                            SizedBox(width: 20),
                            Text(number, style: TextStyle(color: Colors.grey, fontSize: 40.0)),
                            SizedBox(width: 20),
                          ],
                        ),
                  ),
               ],
              ),
            ],
          ),
        ),
      ),
    );
  }

   Material myIns(String number){
    return Material(
      color: Colors.white,
      elevation: 14.0,
     // borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color.fromRGBO(210, 245, 203, 1),
      child: Card(
        child:Padding(
          padding: EdgeInsets.all(8.0),
          child:
              Column(
               // mainAxisAlignment:MainAxisAlignment.center,
               children: <Widget>[
                  Padding(
                   padding: EdgeInsets.all(8.0),
                      child:Text("INSTITUCIJE",style:TextStyle(             
                        fontSize: 15.0,
                        color: Colors.grey
                      ),
                      textAlign: TextAlign.left,),
                    ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                     child: Row(
                          children: <Widget>[
                            Icon(Icons.account_balance, color:Colors.black, size:80),
                            SizedBox(width: 20),
                            Text(number, style: TextStyle(color: Colors.grey, fontSize: 40.0)),
                            SizedBox(width: 20),
                          ],
                        ),
                  ),
               ],
              ),
        ),
      ),
    );
  }

  Widget buildUserList(List<User> listUsers) {
    return Container(
      width: 70,
      color: greenPastel,
      child:ListView.builder(
      itemCount: listUsers == null ? 0 : listUsers.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
          
                  color: Colors.white,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(top: 5),
                  child: Row(children: [
                    CircleImage(
                      userPhotoURL + listUsers[index].photo,
                      imageSize: 30.0,
                      whiteMargin: 2.0,
                      imageMargin: 6.0,
                    ),
                    Container(
                     // width: 80,
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(listUsers[index].username,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                              listUsers[index].firstName +
                                  " " +
                                  listUsers[index].lastName,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 13))
                        ],
                      ),
                    ),    
                  ])),
            ],
          ),
        ));
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    double width1 = MediaQuery.of(context).size.width - 60;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.black), onPressed: () {
           Navigator.pop(context);
        }),
        backgroundColor: Colors.white,
        title: Text("Statistički podaci",
        
        style: TextStyle(color:Colors.black)),
        
        actions: <Widget>[
          IconButton(icon: Icon(
              FontAwesomeIcons.chartLine), onPressed: () {
            //
          }),
        ],
      ),
       body: Row(
          children: <Widget>[
          CollapsingNavigationDrawer(),
          SizedBox(width: 80,),
          
      
      Center(
        child: Container(
          width: width1,
          color:Color(0xffffffff),
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
          /*child:StaggeredGridView.count(
            crossAxisCount: 4,
           crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,*/

       // children: <Widget>[


         child: Row(children: <Widget> [
            Column (children: <Widget> [
              Row(children: <Widget> [
              //  Padding(
              //  padding: const EdgeInsets.all(8.0),
                Flexible(child: myPosts("10")),
              //  ), 
                SizedBox(width: 20),
                Padding(
                padding: const EdgeInsets.all(8.0),
                child: myEvents("15"),
                ), 
               ]),
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: myCircularItems("STATISTIKA"),
              ), 
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildUserList(listUsers),
              ), 
            ]),

            Column (children: <Widget> [
              Row(children: <Widget> [
                Padding(
                padding: const EdgeInsets.all(8.0),
                child: myAccounts("10"),
                ), 
                SizedBox(width: 20),
                Padding(
                padding: const EdgeInsets.all(8.0),
                child: myIns("1 "),
                ), 
               ]),           
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: eventPost(),
              ), 
                Padding(
              padding: const EdgeInsets.all(8.0),
              child: newDonation(),
              ),
            ]),
          ]),

        /*],
        staggeredTiles: [
        StaggeredTile.extent(3, 300.0),
          StaggeredTile.extent(1, 600.0),
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(2, 300.0),
          StaggeredTile.extent(1, 150.0),
        ],
      ),*/
      ),
    ),
    ]));
  }
}