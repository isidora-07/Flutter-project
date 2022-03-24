import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:frontend_web/models/institution.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/InstitutionPages/editInstitutionPage/editInstitutionDesktopPage.dart';
import 'package:frontend_web/ui/InstitutionPages/editInstitutionPage/editInstitutionMobilePage.dart';
import 'package:frontend_web/ui/InstitutionPages/editInstitutionPage/editInstitutionTabletPage.dart';
import 'package:frontend_web/widgets/collapsingInsNavigationDrawer.dart';
import 'package:frontend_web/widgets/mobileDrawer/drawerInstitution.dart';
import 'package:responsive_builder/responsive_builder.dart';


class EditInstitutionPage extends StatefulWidget {
  final int insId;

  EditInstitutionPage(this.insId);

  @override
  _EditInstitutionPageState createState() => _EditInstitutionPageState();
}

class _EditInstitutionPageState extends State<EditInstitutionPage> {
  String wrongRegText = "";
  Institution institution;
  Image imageFile;

  String name = '',password = '', oldPassword = '', email = '',description = '',phone = '',cityName = '';
  int cityId = 0;
  String spoljasnjeIme = '';
  String baseString;

  @override
  void initState() {
    super.initState();
    _getInsData(TokenSession.getToken, widget.insId);
  }

  _getInsData(String jwt, int id) async {
    var result = await APIServices.getInstitutionById(jwt, id);
    Map<String, dynamic> jsonUser = jsonDecode(result.body);
    Institution ins = Institution.fromObject(jsonUser);
    setState(() {
      institution = ins;
    });
  }
  String namePhoto = '';
  String error;
  Uint8List data;

  @override
  Widget build(BuildContext context) {
     return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        drawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
          ? DrawerInstitution(3)
          : null,
        appBar: sizingInformation.deviceScreenType != DeviceScreenType.Mobile
          ? null
          : AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: (institution != null)
                  ? Row(
            children: <Widget>[
                sizingInformation.deviceScreenType != DeviceScreenType.Mobile 
            ? CollapsingInsNavigationDrawer()
            : SizedBox(),
              Expanded(
                child: ScreenTypeLayout(
                  mobile: EditInstitutionMobilePage(institution),
                  desktop: EditInstitutionDesktopPage(institution),
                  tablet: EditInstitutionTabletPage(institution),
                ),
              )
            ],
          )
           : Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                    greenPastel),
              ),
            ),)

      )
    );
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 3));
    setState(() {
      institution = new Institution();
    });
    _getInsData(TokenSession.getToken, widget.insId);
    return null;
  }
}
