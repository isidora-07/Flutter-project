import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_web/models/donation.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/manageDonation/manageDonationPage.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';
import 'package:frontend_web/widgets/mobileDrawer/drawerAdmin.dart';
import 'package:intl/intl.dart';
import 'package:frontend_web/extensions/hoverExtension.dart';
import 'package:responsive_builder/responsive_builder.dart';

Color greenPastel = Color(0xFF00BFA6);

class EditDonationPage extends StatefulWidget {
  final Donation donation;
  EditDonationPage(this.donation);

  @override
  _EditDonationPage createState() => _EditDonationPage(donation);
}

class _EditDonationPage extends State<EditDonationPage> {
  Donation donation;

  _EditDonationPage(Donation donation1) {
    this.donation = donation1;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        builder: (context, sizingInformation) => Scaffold(
              drawer:
                  sizingInformation.deviceScreenType == DeviceScreenType.Mobile
                      ? DrawerAdmin(7)
                      : null,
              appBar:
                  sizingInformation.deviceScreenType != DeviceScreenType.Mobile
                      ? null
                      : AppBar(
                          backgroundColor: Colors.white,
                          iconTheme: IconThemeData(color: Colors.black),
                        ),
              backgroundColor: Colors.white,
              body: Row(
                children: <Widget>[
                  sizingInformation.deviceScreenType != DeviceScreenType.Mobile
                      ? CollapsingNavigationDrawer()
                      : SizedBox(),
                  Expanded(
                    child: ScreenTypeLayout(
                      mobile: EditDonationMobilePage(donation),
                      desktop: EditDonationDesktopPage(donation),
                      tablet: EditDonationDesktopPage(donation),
                    ),
                  )
                ],
              ),
            ));
  }
}

class EditDonationMobilePage extends StatefulWidget {
 final Donation donation;
  EditDonationMobilePage(this.donation);

  @override
  _EditDonationMobilePageState createState() =>
      new _EditDonationMobilePageState(donation);
}

class _EditDonationMobilePageState extends State<EditDonationMobilePage> {
  Donation donation;

  _EditDonationMobilePageState(Donation don1) {
    this.donation = don1;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment(-0.75, -0.50),
              child: RaisedButton(
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
            ).showCursorOnHover,
            Container(
              width: 350,
              child: EditDonationWidget(donation),
            ),
          ],
        )
      ],
    );
  }
}

class EditDonationDesktopPage extends StatefulWidget {
  final Donation don;
  EditDonationDesktopPage(this.don);

  @override
  _EditDonationDesktopPageState createState() =>
      new _EditDonationDesktopPageState(don);
}

class _EditDonationDesktopPageState extends State<EditDonationDesktopPage> {
  Donation donation;

  _EditDonationDesktopPageState(Donation donation1) {
    this.donation = donation1;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment(-0.65, -0.65),
              child: RaisedButton(
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
            ).showCursorOnHover,
            SizedBox(
              height: 10,
            ),
            Container(
              width: 500,
              child: EditDonationWidget(donation),
            ),
          ],
        )
      ],
    );
  }
}

class EditDonationWidget extends StatefulWidget {
  final Donation donation;
  EditDonationWidget(this.donation);

  @override
  _EditDonationWidget createState() => _EditDonationWidget(donation);
}

class _EditDonationWidget extends State<EditDonationWidget> {
  Donation donation;
  _EditDonationWidget(Donation donation1) {
    this.donation = donation1;
  }

  TextEditingController name;
  TextEditingController titleController;
  TextEditingController description;
  TextEditingController priceController;

  var temp;

  String wrongText = "";

  double _doubleValue;

  @override
  void initState() {
    super.initState();
    setState(() {
      titleController = new TextEditingController(text: donation.title);
      name = new TextEditingController(text: donation.organizationName);
      description = new TextEditingController(text: donation.description);
      temp = donation.pointsNeeded * 10;
      priceController = new TextEditingController(text: temp.toString());
    });
  }

  Widget nameOrganizationWidget() {
    return Container(
        width: 500,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment(-0.95, -0.95),
              child: Text(
                'Ime ogranizacije',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              cursorColor: Colors.black,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
              controller: name,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                contentPadding: EdgeInsets.all(18),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(width: 2, color: greenPastel),
                ),
              ),
            ),
          ],
        )).showCursorTextOnHover;
  }

  Widget title() {
    return Container(
        width: 500,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment(-0.95, -0.95),
              child: Text(
                'Naslov',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              cursorColor: Colors.black,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                contentPadding: EdgeInsets.all(18),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(width: 2, color: greenPastel),
                ),
              ),
            ),
          ],
        )).showCursorTextOnHover;
  }

  Widget longDescription() {
    return Container(
        width: 500,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment(-0.95, -0.95),
              child: Text(
                'Opis donacije',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              cursorColor: Colors.black,
              maxLines: 5,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
              controller: description,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                contentPadding: EdgeInsets.all(18),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide(width: 2, color: greenPastel),
                ),
              ),
            ),
          ],
        )).showCursorTextOnHover;
  }

  Widget money() {
    return Container(
        width: 500,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment(-0.95, -0.95),
              child: Text(
                'Novčani iznos',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: priceController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: greenPastel),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelStyle: TextStyle(color: Colors.black)),
              maxLines: 1,
              keyboardType: TextInputType.number,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                CurrencyPtBrInputFormatter(maxDigits: 8),
              ],
              onChanged: (value) {
                String _onlyDigits = value.replaceAll(RegExp('[^0-9]'), "");
                _doubleValue = double.parse(_onlyDigits) / 100;

                return _doubleValue;
              },
            )
          ],
        )).showCursorTextOnHover;
  }

  Widget wrong() {
    return Container(
        child: Center(
            child: Text(
      '$wrongText',
      style: TextStyle(color: Colors.red),
    )));
  }

  Widget donationButton() {
    return RaisedButton(
      onPressed: () {
        var str = TokenSession.getToken;
        var jwt = str.split(".");
        var payload =
            json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
        //print(payload);

        if (name.text != '' && _doubleValue.toDouble() != 0.0) {
          APIServices.editDonationData(
              str,
              donation.id,
              int.parse(payload["sub"]),
              titleController.text,
              name.text,
              description.text,
              _doubleValue.toDouble()).then((value){
                if(value.statusCode == 200)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManageDonationPage()),
                  );
              });

          setState(() {
            wrongText = "";
          });

          
        } else {
          setState(() {
            wrongText = "Niste izmenili podatke.";
          });
        }
      },
      color: greenPastel,
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
          side: BorderSide(color: greenPastel)),
      child: Text("Izmeni", style: TextStyle(color: Colors.white)),
    ).showCursorOnHover;
  }

  @override
  Widget build(BuildContext context) {
   return Container(
        margin: EdgeInsets.only(top: 15),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            nameOrganizationWidget() ,
            Container(
              margin: EdgeInsets.only(left: 50, right: 20, top: 10, bottom: 10),
            ),
            title(),
            Container(
              margin: EdgeInsets.only(left: 50, right: 20, top: 10, bottom: 10),
            ),
            longDescription(),
            Container(
              margin: EdgeInsets.only(left: 50, right: 20, top: 10, bottom: 10),
            ),
            money(),
            Container(
              margin: EdgeInsets.only(left: 50, right: 20, top: 10, bottom: 10),
            ),
           
            Container(
              margin: EdgeInsets.only(left: 50, right: 20, top: 10, bottom: 10),
            ),
            donationButton(),
            wrong()
          ],
        ));
  }
}

class CurrencyPtBrInputFormatter extends TextInputFormatter {
  CurrencyPtBrInputFormatter({this.maxDigits});
  final int maxDigits;

  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    if (maxDigits != null && newValue.selection.baseOffset > maxDigits) {
      return oldValue;
    }

    double value = double.parse(newValue.text);
    final formatter = new NumberFormat("0.00", "pt_BR");
    String newText = "RSD " + formatter.format(value / 100);
    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }

}
