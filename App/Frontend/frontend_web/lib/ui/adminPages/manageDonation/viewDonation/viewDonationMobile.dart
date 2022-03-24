import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_icon_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:frontend_web/models/donation.dart';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/manageDonation/editDonation/editDonationPage.dart';
import 'package:frontend_web/ui/adminPages/manageDonation/manageDonationPage.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewPost.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

Color greenPastel = Color(0xFF00BFA6);

class ViewDonationMobile extends StatefulWidget {
  final Donation donation;
  ViewDonationMobile(this.donation);

  @override
  _ViewDonationMobileState createState() => _ViewDonationMobileState(donation);
}

class _ViewDonationMobileState extends State<ViewDonationMobile> {
  Donation donation;
  List<User> users;

  _ViewDonationMobileState(Donation donation1) {
    this.donation = donation1;
  }

  _getUsersFromDonation() async {
    APIServices.getUsersFromDonation(TokenSession.getToken, donation.id)
        .then((res) {
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
    return CenteredViewPostMobile(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.only(left: 10.0, right: 10.0),
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: greenPastel,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: greenPastel)),
                child: Text(
                  "Vrati se nazad",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: SizedBox(),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditDonationPage(this.donation)),
                  );
                },
                color: greenPastel,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: greenPastel)),
                child: Text(
                  "Izmeni donaciju",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  showAlertDialog(context, donation.id);
                },
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.red)),
                child: Text(
                  "Obriši",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(donation.organizationName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0)),
          SizedBox(
            height: 10.0,
          ),
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
          SizedBox(
            height: 20.0,
          ),
          Flexible(
              child: Text(donation.title,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0))),
          Flexible(child: Text(donation.description)),
          SizedBox(
            height: 10.0,
          ),
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
          (users != null) ? listUsers() : SizedBox(),
        ]),
      ),
    );
  }

  Widget eventProgressRow() {
    return IconRoundedProgressBar(
      icon:
          Padding(padding: EdgeInsets.all(8), child: Icon(Icons.attach_money)),
      theme: RoundedProgressBarTheme.green,
      margin: EdgeInsets.symmetric(vertical: 16),
      borderRadius: BorderRadius.circular(6),
      percent: (donation.pointsAccumulated / donation.pointsNeeded) * 80, // 80
    );
  }

  Widget listUsers() {
    return Align(
        alignment: Alignment.topLeft,
        child: Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          direction: Axis.horizontal,
          children: users
              .map((User user) => InputChip(
                    avatar: CircleAvatar(
                      child: Container(
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(
                                      userPhotoURL + user.photo)))),
                    ),
                    label: Text(user.firstName + " " + user.lastName),
                    onPressed: () {},
                  ))
              .toList(),
        ));
  }

  showAlertDialog(BuildContext context, int id) {
    final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();
    
    void _doSomething() async {
      APIServices.deleteDonation(TokenSession.getToken, id).then((res) {
          if (res.statusCode == 200) {
            print("Uspesno brisanje donacije.");
            
          }
        });
      Timer(Duration(seconds: 1), () {
          _btnController.success();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ManageDonationPage()),
          );
      });
    }
    // set up the button
    Widget okButton = RoundedLoadingButton(
      child: Text("Obriši", style: TextStyle(color: Colors.white),),
      controller: _btnController,
      color: Colors.red,
      width: 60,
      height: 40,
      onPressed: _doSomething,
    );

    Widget notButton = RoundedLoadingButton(
       color:greenPastel,
       width: 60,
       height: 40,
       child: Text("Otkaži", style: TextStyle(color: Colors.white),),
      onPressed: () {
        Navigator.pop(context);
        },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Brisanje Donacije"),
      content: Text("Da li ste sigurni da želite da obrišete donaciju?"),
      actions: [
        okButton,
        notButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
