import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_icon_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:frontend_web/models/donation.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/manageDonation/viewDonation/viewDonationPage.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewDonation.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';

import 'package:frontend_web/extensions/hoverExtension.dart';

import 'createDonation/createDonationPage.dart';

Color greenPastel = Color(0xFF00BFA6);

class ManageDonationDesktop extends StatefulWidget {
  @override
  _ManageDonationDesktopState createState() => _ManageDonationDesktopState();
}

class _ManageDonationDesktopState extends State<ManageDonationDesktop> {
  List<Donation> donations;
  List<Donation> finishedDonations;

  _getDonations() async {
    APIServices.getDonations(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<Donation> donations1 = List<Donation>();
      donations1 = list.map((model) => Donation.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          donations = donations1;
        });
      }
    });
  }

  _getFinishedDonations() async {
    APIServices.getFinishedDonations(TokenSession.getToken).then((res) {
      print(res.body);
      Iterable list = json.decode(res.body);
      List<Donation> donations2 = List<Donation>();
      donations2 = list.map((model) => Donation.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          finishedDonations = donations2;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getDonations();
    _getFinishedDonations();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CenteredViewDonation(
          child: TabBarView(children: <Widget>[
            Column( children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateDonationPage()),
                      );
                    },
                    color: greenPastel,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: greenPastel)),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Nova donacija",
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ).showCursorOnHover,
                  SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
              Flexible(child: buildDonationList(donations),)
            ],),
            Column( children: <Widget>[
              Flexible(child: buildDonationList(finishedDonations),)
            ],),
          ],)),
        CollapsingNavigationDrawer()
      ],
    );
  }

  Widget buildDonationList(List<Donation> listDonations) {
    return GridView.builder(
        padding: EdgeInsets.only(bottom: 30.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 1.7,
        ),
        itemCount: listDonations == null ? 0 : listDonations.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(children: <Widget>[
                    eventInfoRow(listDonations[index].organizationName),
                    SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    titleRow(listDonations[index].title),
                    descriptionRow(listDonations[index].description),
                    Expanded(
                      child: SizedBox(),
                    ),
                    eventProgressRow(listDonations[index].pointsAccumulated,
                        listDonations[index].pointsNeeded),
                    pointsRow(listDonations[index].pointsAccumulated,
                        listDonations[index].pointsNeeded),
                    actionButtonRow(
                        listDonations[index], listDonations[index].id, index)
                  ]),
                ),
                Container(
                  color: (listDonations[index].pointsAccumulated >=
                          listDonations[index].pointsNeeded)
                      ? greenPastel
                      : Colors.white,
                  child: SizedBox(
                    width: 20,
                  ),
                )
              ],
            ),
          ));
        });
  }

  Widget eventInfoRow(String organizationName) {
    return Row(children: <Widget>[
      SizedBox(
        width: 10.0,
      ),
      Text(organizationName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
      Expanded(child: SizedBox()),
      SizedBox(
        width: 10.0,
      ),
    ]);
  }

  Widget titleRow(String title) {
    return Container(
        child: Row(
      children: <Widget>[
        SizedBox(
          width: 10.0,
        ),
        Flexible(
            child: Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0))),
        SizedBox(
          width: 10.0,
        ),
      ],
    ));
  }

  Widget eventProgressRow(int pointsAccumulated, int pointsNeeded) {
    return IconRoundedProgressBar(
      icon:
          Padding(padding: EdgeInsets.all(8), child: Icon(Icons.attach_money)),
      theme: RoundedProgressBarTheme.green,
      margin: EdgeInsets.symmetric(vertical: 16),
      borderRadius: BorderRadius.circular(6),
      percent: (pointsAccumulated / pointsNeeded) * 22, // 22
    );
  }

  Widget pointsRow(int pointsAccumulated, int pointsNeeded) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 10.0,
        ),
        Text("Skupljeno: "),
        Text("$pointsAccumulated poena"),
        Expanded(child: SizedBox()),
        Text("Potrebno: "),
        Text("$pointsNeeded poena"),
        SizedBox(
          width: 10.0,
        ),
      ],
    );
  }

  Widget descriptionRow(String description) {
    return Container(
        child: Row(
      children: <Widget>[
        SizedBox(
          width: 10.0,
        ),
        (description != null)
            ? Flexible(child: Text(description))
            : Text("Nema opis."),
        SizedBox(
          width: 10.0,
        ),
      ],
    ));
  }

  Widget actionButtonRow(Donation don, int id, int index) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 10.0,
        ),
        RaisedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewDonationPage(don)),
            );
          },
          color: greenPastel,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
              side: BorderSide(color: greenPastel)),
          child:
              Text("Više informacija", style: TextStyle(color: Colors.white)),
        ).showCursorOnHover,
        Expanded(
          child: SizedBox(),
        ),
        RaisedButton(
          onPressed: () {
            showAlertDialog(context, id, index);
          },
          color: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.red)),
          child: Text(
            "Obriši",
            style: TextStyle(color: Colors.white),
          ),
        ).showCursorOnHover,
        SizedBox(
          width: 10.0,
        ),
      ],
    );
  }

  showAlertDialog(BuildContext context, int id, int index) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "Obriši",
        style: TextStyle(color: Colors.red),
      ),
      onPressed: () {
        APIServices.deleteDonation(TokenSession.getToken, id).then((res) {
          if (res.statusCode == 200) {
            print("Uspesno brisanje donacije.");
            setState(() {
              donations.removeAt(index);
            });
          }
        });
        Navigator.pop(context);
      },
    ).showCursorOnHover;
    Widget notButton = FlatButton(
      child: Text(
        "Otkaži",
        style: TextStyle(color: greenPastel),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ).showCursorOnHover;

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
