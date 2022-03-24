import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_progress_bar/flutter_icon_rounded_progress_bar.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:frontend_web/models/donation.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/manageDonation/createDonation/createDonationPage.dart';
import 'package:frontend_web/ui/adminPages/manageDonation/viewDonation/viewDonationPage.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewDonation.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:frontend_web/extensions/hoverExtension.dart';

Color greenPastel = Color(0xFF00BFA6);

class ManageDonationTablet extends StatefulWidget {
  @override
  _ManageDonationTabletState createState() => _ManageDonationTabletState();
}

class _ManageDonationTabletState extends State<ManageDonationTablet> {
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
            child: TabBarView(
              children: <Widget>[
                Column(
                  children: <Widget>[
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
                  Flexible(child: buildDonationList(donations,1),)
                  ],
                ),
                 Column(
                  children: <Widget>[
                Flexible(child: buildDonationList(finishedDonations,2),)
                  ]),
              ],
            )
        ),
        CollapsingNavigationDrawer()
      ],
    );
  }

  Widget buildDonationList(List<Donation> listDonations, int ind) {
    return ListView.builder(
        padding: EdgeInsets.only(bottom: 30.0),
        itemCount: listDonations == null ? 0 : listDonations.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: Row(
            children: <Widget>[
              Expanded(
                child: Column(children: <Widget>[
                  eventInfoRow(listDonations[index].organizationName),
                  SizedBox(
                    height: 10.0,
                  ),
                  titleRow(listDonations[index].title),
                  descriptionRow(listDonations[index].description),
                  eventProgressRow(listDonations[index].pointsAccumulated,
                      listDonations[index].pointsNeeded),
                  pointsRow(listDonations[index].pointsAccumulated,
                      listDonations[index].pointsNeeded),
                  actionButtonRow(listDonations[index], listDonations[index].id, index, ind)
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
      percent: (pointsAccumulated / pointsNeeded) * 84, // 84
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

  Widget actionButtonRow(Donation don, int id, int index, int ind) {
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
            showAlertDialog(context, id, index, ind);
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

  showAlertDialog(BuildContext context, int id, int index, int ind) {
    final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();
    
    void _doSomething() async {
      APIServices.deleteDonation(TokenSession.getToken, id).then((res) {
          if (res.statusCode == 200) {
            print("Uspesno brisanje donacije.");
            setState(() {
              if(ind==1)
                donations.removeAt(index);
              else
                finishedDonations.removeAt(index);
            });
          }
        });
      Timer(Duration(seconds: 1), () {
          _btnController.success();
          Navigator.pop(context);
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
