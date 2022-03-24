import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_icon_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:frontend/models/donation.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/ui/othersProfilePage.dart';
import 'package:frontend/ui/splash.page.dart';

import '../main.dart';

class DonationsWidget extends StatefulWidget {
  final Donation donation;

  DonationsWidget(this.donation);

  @override
  _DonationsWidgetState createState() => _DonationsWidgetState(donation);
}

class _DonationsWidgetState extends State<DonationsWidget> {
  Donation donation;
  TextEditingController donateController = new TextEditingController();

  _DonationsWidgetState(Donation donation1) {
    this.donation = donation1;
  }

  @override
  Widget build(BuildContext context) {
    return buildEvent();
  }

  Widget buildEvent() =>Card(
    child: Column(
      children: <Widget>[
        eventInfoRow(),
        SizedBox(height: 10.0,),
        titleRow(),
        descriptionRow(),
        eventProgressRow(),
        pointsRow(),
        actionButtonRow()
      ]
    )
  );

  Widget eventInfoRow(){
    return Row(
      children: <Widget>[
        SizedBox(width: 10.0,),
        Text(
          donation.organizationName, 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)
        ),
        Expanded(child: SizedBox()),
        SizedBox(width: 10.0,),
      ]
    );
  }

  Widget titleRow(){
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(width: 10.0,),
          Flexible(child: Text(donation.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0))),
          SizedBox(width: 10.0,),
        ],
      )
    );
  }

  Widget eventProgressRow(){
    return IconRoundedProgressBar(
      icon: Padding( padding: EdgeInsets.all(8), child: Icon(Icons.attach_money)),
      theme: RoundedProgressBarTheme.green,
      margin: EdgeInsets.symmetric(vertical: 16),
      borderRadius: BorderRadius.circular(6),
      percent: (donation.pointsAccumulated / donation.pointsNeeded) * 84, // 84
    );
  }

  Widget pointsRow(){
    return Row(
      children: <Widget>[
        SizedBox(width: 10.0,),
        Text("Skupljeno: "),
        Text("${donation.pointsAccumulated} poena"),
        Expanded(child: SizedBox()),
        Text("Potrebno: "),
        Text("${donation.pointsNeeded} poena"),
        SizedBox(width: 10.0,),
      ],
    );
  }

  Widget descriptionRow(){
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(width: 10.0,),
          (donation.description != null)?
            Flexible(child: Text(donation.description)) :
            Text("Nema opis."),
          SizedBox(width: 10.0,),
        ],
      )
    );
  }

  Widget actionButtonRow(){
    return Row(
      children: <Widget>[
        SizedBox(width: 10.0,),
        FlatButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DonationsPageWidget(donation)),
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Color(0xFF00BFA6)
          )
        ),
          child: Text("Više informacija"),
        ),
        Expanded(child: SizedBox()),
        RaisedButton(
          onPressed: (){
            donateActionButton();
          },
          color: Color(0xFF00BFA6),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: Color(0xFF00BFA6)
          )
        ),
          child: Text("Doniraj", style: TextStyle(color: Colors.white),),
        ),
        SizedBox(width: 10.0,),
      ],
    );
  }

  donateActionButton(){
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text("Donirajte poene.", style: TextStyle(
         color: Theme.of(context).textTheme.bodyText1.color),),
        content: Container(
          height: 150.0,
          child: Column(
            children: <Widget>[
              Text("Imate ukupno " + publicUser.points.toString() + " poena!"),
              TextField(
               cursorColor: MyApp.ind == 0 ? Colors.black : Colors.white,
                controller: donateController,
                keyboardType: TextInputType.number,
                 decoration: InputDecoration(
                labelStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1.color,
                    fontStyle: FontStyle.italic),
                fillColor: Colors.black,
                contentPadding: const EdgeInsets.all(10.0),
                focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00BFA6)),
                   ),  
              ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
           FlatButton(
            child: Text(
              "Doniraj",
              style:TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
            ),
            onPressed: () {
              int donationAmount = int.parse(donateController.text);
              if(donationAmount != 0 && donationAmount <= publicUser.points && donationAmount > 0)
              {
                APIServices.jwtOrEmpty().then((res) {
                  String jwt;
                  setState(() {
                    jwt = res;
                  });
                  if (res != null) {
                    APIServices.addDonation(jwt, donation.id, userId, donationAmount).then((res){
                      if(res.statusCode == 200){
                        Map<String, dynamic> list = json.decode(res.body);
                        Donation donation1 = Donation();
                        donation1 = Donation.fromObject(list);
                        print('Uspešno ste izvršili donaciju.');
                        setState(() {
                          publicUser.donatedPoints = publicUser.donatedPoints + donationAmount;
                          publicUser.points = publicUser.points - donationAmount;
                          donation.pointsAccumulated = donation1.pointsAccumulated;
                          donateController.text = "";
                        });
                        Navigator.of(context).pop();
                      }
                      else
                      {
                        Navigator.of(context).pop();
                      }
                    });
                  }
                });
              }
              else{
                if(donationAmount == 0){
                  Navigator.of(context).pop();
                  Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Row(children: [ Flexible(child:Text("Ne možete donirati 0 poena.\n "))],),));

                  setState(() {
                    donateController.text = "";
                  });
                }
                else if(donationAmount > publicUser.points){
                  Navigator.of(context).pop();
                  Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Row(children: [Flexible(child:Text("Ne možete donirati više poena nego što ste sakupili.\n "))],),));
                  
                  setState(() {
                    donateController.text = "";
                  });
                }
                else if(donationAmount < 0){
                  Navigator.of(context).pop();
                  Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Row(children: [Flexible(child:Text("Ne možete donirati negativan broj poena.\n "))],),));
                  
                  setState(() {
                    donateController.text = "";
                  });
                }
              }
            },
          ),
           FlatButton(
          child: Text(
            "Otkaži",
            style:TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
          ),
          onPressed: () {
              setState(() {
                donateController.text = "";
              });
              Navigator.of(context).pop();
            },
          )
        ],
      )
    );
  }

}

class DonationsPageWidget extends StatefulWidget {
  final Donation donation;

  DonationsPageWidget(this.donation);

  @override
  _DonationsPageWidgetState createState() => _DonationsPageWidgetState(donation);
}

class _DonationsPageWidgetState extends State<DonationsPageWidget> {
  Donation donation;
  List<User> users;
  _DonationsPageWidgetState(Donation donation1) {
    this.donation = donation1;
  }

  _getUsersFromDonation() async {
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getUsersFromDonation(jwt, donation.id).then((res) {
      Iterable list = json.decode(res);
      List<User> users1 = List<User>();
      users1 = list.map((model) => User.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          users = users1;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getUsersFromDonation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyApp.ind == 0 ? Colors.white :  Theme.of(context).copyWith().backgroundColor,
        iconTheme: IconThemeData(color: Theme.of(context).copyWith().iconTheme.color),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0,),
            Text(
              donation.organizationName, 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0)
            ),
            SizedBox(height: 10.0,),
            eventProgressRow(),
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Skupljeno:"),
                    Text("${donation.pointsAccumulated} poena")
                  ],
                ),
                Expanded(child: SizedBox()),
                Column(
                  children: <Widget>[
                    Text("Potrebno:"),
                    Text("${donation.pointsNeeded} poena")
                  ],
                )
              ],
            ),
            SizedBox(height: 20.0,),
            Flexible(child: Text(donation.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0))),
            Flexible(child: Text(donation.description)),
            SizedBox(height: 10.0,),
            Row(
            children: <Widget>[
              Text("Učesnici:"),
              Expanded(child: SizedBox()),
              //Text("${donation.userNum} korisnika"),
              Text("${donation.userNum}" == '1'
                    ? "${donation.userNum} korisnik"
                    : "${donation.userNum} korisnika"),
            ],
          ),
          (users != null)?listUsers():SizedBox(),
          ]
        ),
      ),
    );
  }

  Widget eventProgressRow(){
    return IconRoundedProgressBar(
      icon: Padding( padding: EdgeInsets.all(8), child: Icon(Icons.attach_money)),
      theme: RoundedProgressBarTheme.green,
      margin: EdgeInsets.symmetric(vertical: 16),
      borderRadius: BorderRadius.circular(6),
      percent:  (donation.pointsAccumulated / donation.pointsNeeded) * 80, // 80
    );
  }

  Widget listUsers(){
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        direction: Axis.horizontal,
        children: users.map((User user) => InputChip(
          avatar: CircleAvatar(child: Container(
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage(serverURLPhoto + user.photo)
                )
              )
            ),
          ),
          label: Text(user.firstName + " " + user.lastName),
          onPressed: (){
            if(user.id != userId)
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OthersProfilePage(user.id)),
              );
          },
        )).toList(),
      )
    );
  }
}