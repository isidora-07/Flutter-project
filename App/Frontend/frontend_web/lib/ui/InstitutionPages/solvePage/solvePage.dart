import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/homePage.dart';
import 'package:frontend_web/widgets/collapsingInsNavigationDrawer.dart';
import 'package:frontend_web/widgets/mobileDrawer/drawerInstitution.dart';
import 'package:frontend_web/extensions/hoverExtension.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'dart:typed_data';
import 'package:universal_html/prefer_universal/html.dart' as html;

class InstitutionSolvePage extends StatefulWidget {
  final int postId;
  final int id;
  InstitutionSolvePage({Key key, this.postId, this.id});
  @override
  _InstitutionSolvePageState createState() => _InstitutionSolvePageState();
}

class _InstitutionSolvePageState extends State<InstitutionSolvePage> {
  int postId;
  int id;
  @override
  void initState() {
    super.initState();
    setState(() {
      postId = widget.postId;
      id = widget.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
        builder: (context, sizingInformation) => Scaffold(
              drawer:
                  sizingInformation.deviceScreenType == DeviceScreenType.Mobile
                      ? DrawerInstitution(2)
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
                      ? CollapsingInsNavigationDrawer()
                      : SizedBox(),
                  Expanded(
                    child: ScreenTypeLayout(
                      mobile:
                          InstitutionSolveMobilePage(postId: postId, id: id),
                      desktop:
                          InstitutionSolveDesktopPage(postId: postId, id: id),
                      tablet:
                          InstitutionSolveDesktopPage(postId: postId, id: id),
                    ),
                  )
                ],
              ),
            ));
  }
}

class InstitutionSolveMobilePage extends StatefulWidget {
  final int postId;
  final int id;
  InstitutionSolveMobilePage({Key key, this.postId, this.id});
  @override
  _InstitutionSolveMobilePageState createState() =>
      new _InstitutionSolveMobilePageState();
}

class _InstitutionSolveMobilePageState
    extends State<InstitutionSolveMobilePage> {
  int postId;
  int id;
  @override
  void initState() {
    super.initState();
    setState(() {
      postId = widget.postId;
      id = widget.id;
    });
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
              child: InstitutionSolveWidget(postId, id),
            ),
          ],
        )
      ],
    );
  }
}

class InstitutionSolveDesktopPage extends StatefulWidget {
  final int postId;
  final int id;
  InstitutionSolveDesktopPage({Key key, this.postId, this.id});
  @override
  _InstitutionSolveDesktopPageState createState() =>
      new _InstitutionSolveDesktopPageState();
}

class _InstitutionSolveDesktopPageState
    extends State<InstitutionSolveDesktopPage> {
  int postId;
  int id;
  @override
  void initState() {
    super.initState();
    setState(() {
      postId = widget.postId;
      id = widget.id;
    });
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
              child: InstitutionSolveWidget(postId, id),
            ),
          ],
        )
      ],
    );
  }
}

class InstitutionSolveWidget extends StatefulWidget {
  final int postId;
  final int id;
  InstitutionSolveWidget(this.postId, this.id);
  @override
  _InstitutionSolveWidget createState() => _InstitutionSolveWidget(postId);
}

class _InstitutionSolveWidget extends State<InstitutionSolveWidget> {
  int postId;
  TextEditingController description = new TextEditingController();
  _InstitutionSolveWidget(int idp) {
    this.postId = idp;
  }

  Image image;
  String error;
  String photoName = '';
  Uint8List data;
  String unknownImageText = "";
  String successText = "";
  int instId;

  @override
  initState() {
    super.initState();
    instId = widget.id;
  }

  solve(int postId, int institutionId, String description) {
    if (photoName != null && photoName != '') {
      String base64Image = base64Encode(data);
      APIServices.addImageWebSolution(base64Image).then((res) {
        var res1 = jsonDecode(res);
        APIServices.solveFromTheInstitution(
            TokenSession.getToken, postId, institutionId, description, res1).then((value){
              String jwt = TokenSession.getToken;
              if(value.statusCode == 200)
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadScreenSolver()),
                );
            });

        setState(() {
          successText = "Uspešno ste rešili objavu.";
          unknownImageText = "";
        });
      });
    } else {
      setState(() {
        unknownImageText =
            "Morate uneti sliku ukoliko želite da rešite objavu.";
      });
      throw Exception("Morate uneti sliku ukoliko želite da rešite objavu.");
    }
  }

  pickImage() {
    final html.InputElement input = html.document.createElement('input');
    input
      ..type = 'file'
      ..accept = 'image/*';

    input.onChange.listen((e) {
      if (input.files.isEmpty) return;
      final reader = html.FileReader();
      reader.readAsDataUrl(input.files[0]);
      reader.onError.listen((err) => setState(() {
            error = err.toString();
          }));
      reader.onLoad.first.then((res) {
        final encoded = reader.result as String;
        // remove data:image/*;base64 preambule
        final stripped =
            encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

        setState(() {
          photoName = input.files[0].name;
          data = base64.decode(stripped);
          error = null;
        });
      });
    });
    input.click();
  }

  Widget descriptionPart() {
    return Container(
      width: 500,
      child: TextFormField(
        inputFormatters:[
          LengthLimitingTextInputFormatter(70),
          ],
        maxLines: 5,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        cursorColor: Colors.black,
        controller: description,
        decoration: InputDecoration(
          hintText: "Opis rešenja",
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

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 25),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                pickImage();
              },
              color: greenPastel,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: greenPastel)),
              child: Text(
                "Dodaj sliku",
                style: TextStyle(color: Colors.white),
              ),
            ).showCursorOnHover,
            SizedBox(
              height: 25,
            ),
            data != null
                ? Container(
                    constraints: BoxConstraints(
                      maxHeight: 400.0, // changed to 400
                      minHeight: 200.0, // changed to 200
                      maxWidth: double.infinity,
                      minWidth: double.infinity,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.grey[200],
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: ClipRect(
                        child: Image.memory(
                      data,
                      height: 400.0,
                      width: 200.0,
                      fit: BoxFit.cover,
                    )),
                  )
                : SizedBox(
                    height: 15,
                  ),
            SizedBox(
              height: 10,
            ),
            descriptionPart(),
            SizedBox(
              height: 15,
            ),
            RaisedButton(
              onPressed: () {
                solve(postId, instId, description.text);
              },
              color: greenPastel,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: greenPastel)),
              child: Text(
                "Reši",
                style: TextStyle(color: Colors.white),
              ),
            ).showCursorOnHover,
            SizedBox(
              height: 10,
            ),
            unknownImageText != ''
                ? Center(
                    child: Text(
                    unknownImageText,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 25,
                    ),
                  ))
                : Center(
                    child: Text(
                    successText,
                    style: TextStyle(
                      color: Color(0xFF00BFA6),
                      fontSize: 25,
                    ),
                  )),
          ],
        ));
  }
}

class UploadScreenSolver extends StatefulWidget {

  @override
  _UploadScreenSolverState createState() => _UploadScreenSolverState();
}

class _UploadScreenSolverState extends State<UploadScreenSolver>{

  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePageInstitution.fromBase64(TokenSession.getToken)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF00BFA6)),
            ),
            Text("Vaše rešenje se šalje na server.")
          ],
        ),
      )
    );
  }
  
}