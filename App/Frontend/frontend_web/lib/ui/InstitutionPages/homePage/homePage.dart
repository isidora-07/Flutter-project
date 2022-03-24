import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/models/institution.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/homePageDesktop.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/homePageMobile.dart';
import 'package:frontend_web/widgets/mobileDrawer/drawerInstitution.dart';
import 'package:responsive_builder/responsive_builder.dart';

int insId;
int icityId;
Color greenPastel = Color(0xFF00BFA6);
class HomePageInstitution extends StatefulWidget {

  HomePageInstitution(this.jwt, this.payload);
  factory HomePageInstitution.fromBase64(String jwt) => HomePageInstitution(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  _HomePageInstitutionState createState() => new _HomePageInstitutionState(jwt, payload);
}

class _HomePageInstitutionState extends State<HomePageInstitution> {

  Institution institution;
  final String jwt;
  final Map<String, dynamic> payload;
  List<FullPost> listUnsolvedPosts;

  _HomePageInstitutionState(this.jwt, this.payload);


  _getInstitutionId() {
    int inId = int.parse(payload['sub']);
    setState(() {
      insId = inId;
    });
  }

  _getInstitutionWithId(int id) async {
      var res = await APIServices.getInstitutionById(TokenSession.getToken, id);
      Map<String, dynamic> jsonInst = jsonDecode(res.body);
      Institution inst = Institution.fromObject(jsonInst);
      setState(() {
        institution = inst;
        icityId = institution.cityId;
      });
  }


  @override
  void initState() {
    super.initState();
    _getInstitutionId();
    _getInstitutionWithId(insId);
  }


  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
            ? DrawerInstitution(2)
            : null,
          appBar: sizingInformation.deviceScreenType != DeviceScreenType.Mobile
            ? null
            : AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
            ),
          backgroundColor: Colors.white,
          body: ScreenTypeLayout(
            mobile: HomeInstitutionMobile(),
            tablet: HomeInstitutionDesktop(id: icityId,),
          ),
        ),
      )
    );
  }
}

