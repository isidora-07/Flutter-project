import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/manageDonation/manageDonationPage.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';
import 'package:frontend_web/widgets/mobileDrawer/drawerAdmin.dart';
import 'package:intl/intl.dart';
import 'package:frontend_web/extensions/hoverExtension.dart';
import 'package:responsive_builder/responsive_builder.dart';

Color greenPastel = Color(0xFF00BFA6);


class CreateDonationPage extends StatefulWidget {
  @override
  _CreateDonationPageState createState() => _CreateDonationPageState();
}

class _CreateDonationPageState extends State<CreateDonationPage> {
  
  @override
  Widget build(BuildContext context) {
     return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        drawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
          ? DrawerAdmin(7)
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
              sizingInformation.deviceScreenType != DeviceScreenType.Mobile 
            ? CollapsingNavigationDrawer(): SizedBox(),
              Expanded(
                child: ScreenTypeLayout(
                  mobile:CreateDonationMobilePage(),
                  desktop: CreateDonationDesktopPage(),
                  tablet: CreateDonationDesktopPage(),
                ),
              )
            ],
          ),
        )
    );

  }
}


class CreateDonationMobilePage extends StatefulWidget{
  @override
  _CreateDonationMobilePageState createState() => new _CreateDonationMobilePageState();
}

class _CreateDonationMobilePageState extends State<CreateDonationMobilePage>{
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20,),
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
            Container(width: 350, child: 
            CreateDonationWidget(),
            ),
          ],
        )
      ],
    );
  }
}

class CreateDonationDesktopPage extends StatefulWidget{
  @override
  _CreateDonationDesktopPageState createState() => new _CreateDonationDesktopPageState();
}

class _CreateDonationDesktopPageState extends State<CreateDonationDesktopPage>{
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
            SizedBox(height: 10,),
            Container(width: 500, child: 
            CreateDonationWidget(),
            ),
          ],
        )
      ],
    );
  }
}

class CreateDonationWidget extends StatefulWidget {
  @override
  _CreateDonationWidget createState() => _CreateDonationWidget();
}

class _CreateDonationWidget extends State<CreateDonationWidget> {
  TextEditingController name = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController description = TextEditingController();
  String wrongText = "";

  double _doubleValue = 0.0;

  Widget nameOrganizationWidget() {
    return Container(
      width: 500,
      child: TextField(
        cursorColor: Colors.black,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        controller: name,
        maxLength: 50,
        decoration: InputDecoration(
          counterText: '',
          counterStyle: TextStyle(fontSize: 0),
          hintText: "Ime ogranizacije",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
          contentPadding: EdgeInsets.all(18),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(width: 2, color: greenPastel),
          ),
        ),
      ),
    ).showCursorTextOnHover;
  }

  Widget title() {
    return Container(
      width: 500,
      child: TextField(
        cursorColor: Colors.black,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        controller: titleController,
        maxLength: 50,
        decoration: InputDecoration(
          counterText: '',
          counterStyle: TextStyle(fontSize: 0),
          hintText: "Naslov",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
          contentPadding: EdgeInsets.all(18),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(width: 2, color: greenPastel),
          ),
        ),
      ),
    ).showCursorTextOnHover;
  }

  Widget longDescription() {
    return Container(
      width: 500,
      child: TextFormField(
        maxLines: 5,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        cursorColor: Colors.black,
        controller: description,
        maxLength: 300,
        decoration: InputDecoration(
          counterText: '',
          counterStyle: TextStyle(fontSize: 0),
          hintText: "Opis donacije",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
          contentPadding: EdgeInsets.all(18),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(width: 2, color: greenPastel),
          ),
        ),
      ),
    ).showCursorTextOnHover;
  }

  Widget money() {
    return Container(
        width: 500,
        child: TextFormField(
          cursorColor: Colors.black,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: greenPastel),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              labelText: 'Novčani iznos',
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
        print(payload);

        if (name.text != '' && _doubleValue.toDouble() != 0.0 && _doubleValue.toDouble() >= 1.0) {
          APIServices.createDonation(
              str,
              int.parse(payload["sub"]),
              titleController.text,
              name.text,
              description.text,
              _doubleValue.toDouble()).then((value){
                if(value.statusCode == 200){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ManageDonationPage()),
                  );
                  setState(() {
                    wrongText = "";
                  });
                }
              });
        } else {
          setState(() {
            wrongText = "Morate uneti ime organizacije i novčani iznos!";
          });
        }
      },
      color: greenPastel,
      shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
          side: BorderSide(color: greenPastel)),
      child: Text("Kreiraj", style: TextStyle(color: Colors.white)),
    ).showCursorOnHover;
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
              margin: EdgeInsets.only(top: 25),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  nameOrganizationWidget(),
                  Container(
                    margin: EdgeInsets.only(
                        left: 50, right: 20, top: 10, bottom: 10),
                  ),
                  title(),
                  Container(
                    margin: EdgeInsets.only(
                        left: 50, right: 20, top: 10, bottom: 10),
                  ),
                  longDescription(),
                  Container(
                    margin: EdgeInsets.only(
                        left: 50, right: 20, top: 10, bottom: 10),
                  ),
                  money(),
                  Container(
                    margin: EdgeInsets.only(
                        left: 50, right: 20, top: 10, bottom: 10),
                  ),
                  donationButton(),
                  wrong()
                ],
              )
              );

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
