import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;
import 'package:frontend_web/extensions/hoverExtension.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'dart:convert';
import 'package:frontend_web/widgets/circleImageWidget.dart';
import '../../models/admin.dart';
import '../../widgets/centeredView/centeredViewManageUser.dart';
import '../../widgets/collapsingNavigationDrawer.dart';

Color greenPastel = Color(0xFF00BFA6);

class ManageAdminsPage extends StatefulWidget {
  final int id;

  ManageAdminsPage({Key key, this.id});

  @override
  _ManageAdminsPageState createState() => new _ManageAdminsPageState();
}

class _ManageAdminsPageState extends State<ManageAdminsPage> {
  List<Admin> listAdmins;
  TextEditingController searchController = new TextEditingController();
  int idA;

  String wrongRegText = "";
  Admin admin;
  Image imageFile;

  String firstName = '', password = '', oldPassword = '', email = '', lastName = '';
  String spoljasnjeIme = '';
  String baseString;

  Admin admin1;
  _getAdmin(int idA) async {
    var res = await APIServices.getAdmin(TokenSession.getToken, idA);
    Map<String, dynamic> jsonUser = jsonDecode(res.body);
    Admin admin = Admin.fromObject(jsonUser);
    setState(() {
      admin1 = admin;
    });
  }

  _getAdmins() {
    APIServices.getAdmins(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<Admin> listA = List<Admin>();
      listA = list.map((model) => Admin.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listAdmins = listA;
        });
      }
    });
  }



  @override
  initState() {
    super.initState();
    idA = widget.id;
    _getAdmin(idA);
    _getAdmins();
  }

  String namePhoto = '';
  String error;
  Uint8List data;
  Color greenPastel = Color(0xFF00BFA6);

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
          namePhoto = input.files[0].name;
          data = base64.decode(stripped);
          error = null;
        });
      });
    });

    input.click();
  }

  Future<String> firstLastName(BuildContext context, String name) {
    TextEditingController customController;
    if (firstName == '') {
      customController = new TextEditingController(text: "$name");
    } else {
      String _name = firstName + " " + lastName;
      customController = new TextEditingController(text: "$_name");
    }
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            content: Container(
                width: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Ime i prezime",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      cursorColor: Colors.black,
                      controller: customController,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: greenPastel),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelStyle: TextStyle(color: Colors.black)),
                    ).showCursorTextOnHover,
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        MaterialButton(
                          child: Text(
                            "Izmeni",
                            style: TextStyle(color: greenPastel),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            var check = customController.text;
                            print(check);
                            var array = check.split(" ");
                            print(array[0] + ", " + array[1]);
                            setState(() {
                                firstName = array[0];
                                lastName = array[1];
                            });
                            Navigator.pop(context);
                          },
                        ).showCursorOnHover,
                        FlatButton(
                          child: Text(
                            "Otkaži",
                            style: TextStyle(color: greenPastel),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ).showCursorOnHover,
                      ],
                    )
                  ],
                )),
          );
        });
  }

 

  Future<String> adminEmail(BuildContext context, String adminEmail) {
    TextEditingController customController;
    if (email == '') {
      customController = new TextEditingController(text: "$adminEmail");
    } else {
      String _adminEmail = email;
      customController = new TextEditingController(text: "$_adminEmail");
    }
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            content: Container(
                width: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Email",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      cursorColor: Colors.black,
                      controller: customController,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: greenPastel),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelStyle: TextStyle(color: Colors.black)),
                    ).showCursorTextOnHover,
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        MaterialButton(
                          child: Text(
                            "Izmeni",
                            style: TextStyle(color: greenPastel),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            var check = customController.text;
                            print(check);
                            if (emailRegex.hasMatch(check)) {
                              setState(() {
                                email = check;
                              });
                              Navigator.of(context).pop();
                            } else {
                              check = "Greska";
                              print(check);
                              setState(() {
                                wrongRegText = "Neispravno uneta email adresa.";
                              });
                              Navigator.of(context).pop(check.toString());
                            }
                          },
                        ).showCursorOnHover,
                        FlatButton(
                          child: Text(
                            "Otkaži",
                            style: TextStyle(color: greenPastel),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ).showCursorOnHover,
                      ],
                    )
                  ],
                )),
          );
        });
  }

//dialog password
  Future<String> adminPassword(BuildContext context) {
    TextEditingController password1 = new TextEditingController();
    TextEditingController password2 = new TextEditingController();
    TextEditingController password3 = new TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            content: Container(
                width: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Šifra",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    SizedBox(height: 5),
                    TextField(
                      cursorColor: Colors.black,
                      controller: password1,
                      autofocus: false,
                      obscureText: true,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: greenPastel),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: 'Trenutna šifra',
                          labelStyle: TextStyle(color: Colors.black)),
                    ).showCursorTextOnHover,
                    SizedBox(height: 5),
                    TextField(
                      cursorColor: Colors.black,
                      controller: password2,
                      autofocus: false,
                      obscureText: true,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: greenPastel),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: 'Nova šifra',
                          labelStyle: TextStyle(color: Colors.black)),
                    ).showCursorTextOnHover,
                    SizedBox(height: 5),
                    TextField(
                      cursorColor: Colors.black,
                      controller: password3,
                      autofocus: false,
                      obscureText: true,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: greenPastel),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: 'Ponovi šifru',
                          labelStyle: TextStyle(color: Colors.black)),
                    ).showCursorTextOnHover,
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        MaterialButton(
                          child: Text(
                            "Izmeni",
                            style: TextStyle(color: greenPastel),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            var temp2 = password1.text; //trenutna
                            var check = password2.text; //nova
                            var checkAgain = password3.text;
                            print(temp2);
                            print(adminPassword);

                            if (check == checkAgain) {
                              if (passRegex.hasMatch(check)) {
                                print(check);
                                setState(() {
                                  password = check;
                                  oldPassword = temp2;
                                });
                                Navigator.of(context).pop();
                              } else {
                                check = "Greska regEx";
                                setState(() {
                                  wrongRegText =
                                      "Šifra mora imati najmanje 6 karaktera.";
                                });
                                print(check);
                                Navigator.of(context).pop(check.toString());
                              }
                            } else {
                              print("Nova i ponovljena nisu iste");
                            }
                          },
                        ).showCursorOnHover,
                        FlatButton(
                          child: Text(
                            "Otkaži",
                            style: TextStyle(color: greenPastel),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ).showCursorOnHover,
                      ],
                    )
                  ],
                )),
          );
        });
  }

  showAlertDialog(BuildContext context, int id) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "Obriši",
        style: TextStyle(color: greenPastel),
      ),
      onPressed: () {
       APIServices.deleteAdmin(TokenSession.getToken, id);
        deleteFromList(id);
        Navigator.pop(context);
      },
    );
    Widget notButton = FlatButton(
      child: Text(
        "Otkaži",
        style: TextStyle(color: Colors.redAccent),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Brisanje administratora"),
      content: Text("Da li ste sigurni da želite da obrišete administratora?"),
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

  Widget buildAdminList() {
    return ListView.builder(
      itemCount: listAdmins == null ? 0 : listAdmins.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              listAdmins[index].id != idA
                  ? Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(5),
                      //margin: EdgeInsets.only(top: 5),
                      child: Row(children: [
                        CircleImage(
                          userPhotoURL + listAdmins[index].photoPath,
                          imageSize: 56.0,
                          whiteMargin: 2.0,
                          imageMargin: 6.0,
                        ),
                        Container(
                            width: 200,
                            padding: EdgeInsets.all(10),
                            child: Text(
                                listAdmins[index].firstName +
                                    " " +
                                    listAdmins[index].lastName,
                                style: TextStyle(fontSize: 15))),
                        FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(11.0),
                              side: BorderSide(color: Colors.redAccent)),
                          color: Colors.redAccent,
                          child: Text(
                            "Obriši administatora",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            showAlertDialog(context, listAdmins[index].id);
                          },
                        ),
                      ]))
                  : Container(width: 1, height: 1),
            ],
          ),
        ));
      },
    );
  }

  Widget search() {
    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(left: 50, right: 50, top: 5, bottom: 5),
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          autofocus: false,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: greenPastel),
            hintText: 'Pretraži ostale administratore...',
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: BorderSide(width: 2, color: greenPastel),
            ),
          ),
          controller: searchController,
        ).showCursorTextOnHover);
  }

  Widget loginAdmin() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        // margin: EdgeInsets.only(top: 5),
        width: 750,
        height: 550,
        child: ListView(children: <Widget>[
          SizedBox(height: 50),
       
          Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      pickImage();
                    },
                    child: error != null
                        ? Text(error)
                        : data != null
                            ? ClipOval(
                                child: Image.memory(
                                data,
                                height: 100.0,
                                width: 100.0,
                                fit: BoxFit.cover,
                              ))
                            : CircleImage(
                                userPhotoURL + admin1.photoPath,
                                imageSize: 100.0,
                                whiteMargin: 0.0,
                                imageMargin: 0.0,
                              ),
                  ).showCursorOnHover,
                  GestureDetector(
                    onTap: () {
                      pickImage();
                    },
                    child: Text(
                      "Promeni profilnu sliku",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 12,
                          decoration: TextDecoration.underline),
                    ),
                  ).showCursorOnHover,
                  SizedBox(
                    height: 10,
                  )
                ],
              )),
          ListTile(
            leading: Icon(Icons.person, color: greenPastel),
            title: Text('Ime i prezime'),
            subtitle: Text(
                      firstName == ''
                          ? admin1.firstName + ' ' + admin1.lastName
                          : firstName + " " + lastName == ''
                              ? admin1.lastName
                              : firstName + ' ' + lastName),
            trailing: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(11.0),
                  side: BorderSide(color: Colors.grey)),
              color: Colors.grey,
              child: Icon(Icons.edit, color: Colors.white),
              onPressed: () {
               firstLastName(context, admin1.firstName + " " + admin1.lastName);
              },
            ),
          ).showCursorOnHover,
          ListTile(
            leading: Icon(Icons.email, color: greenPastel),
            title: Text('E-mail'),
            subtitle: email == '' ? Text(admin1.email) : Text(email),
            trailing: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(11.0),
                  side: BorderSide(color: Colors.grey)),
              color: Colors.grey,
              child: Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                adminEmail(context, admin1.email);
              },
            ),
          ).showCursorOnHover,
          ListTile(
            leading: Icon(Icons.lock_outline, color: greenPastel),
            title: Text('Šifra'),
            subtitle: Text('******'),
            trailing: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(11.0),
                  side: BorderSide(color: Colors.grey)),
              color: Colors.grey,
              child: Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                adminPassword(context);
              },
            ),
          ).showCursorOnHover,
          Center(
              child: Container(
                  width: 150,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(11.0),
                    ),
                    color: greenPastel,
                    child: Text(
                      "Sačuvaj izmene",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      edit(firstName, lastName, email, admin1, idA, oldPassword,
                          password);
                    },
                  ).showCursorOnHover)),
          Center(
              child: Text(
            wrongRegText,
            style: TextStyle(
              color: Colors.red,
            ),
          )),
        ]));
  }

  Future<String> showDial(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            content: Container(
                width: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Uspešno ste promenili podatke!")
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          child: Text(
                            "OK",
                            style: TextStyle(color: greenPastel),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    )
                  ],
                )),
          );
        });
  }

  Widget tabs() {
    return TabBar(
      labelColor: greenPastel,
      indicatorColor: greenPastel,
      tabs: <Widget>[
        Tab(
          child: Text('PODACI O PRIJAVLJENOM ADMINISTRATORU', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
        ),
        Tab(
          child: Text('OSTALI ADMINISTRATORI', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
        ),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
 
    return Stack(
      children: <Widget>[
    DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              flexibleSpace:tabs(),
            ),
            body: TabBarView(children: <Widget>[
              Container(
                margin: EdgeInsets.only(left:400, right: 400),
                  padding: EdgeInsets.only(top: 0),
                  color: Colors.grey[100],
                  child: 
                    Flexible(child:RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: (admin1 != null)
                      ? loginAdmin()
                      : Center(
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Color(0xFF00BFA6)),
                          ),
                        ),
                ),),
                  ),
              Container(
                  margin: EdgeInsets.only(left:400, right: 400),
                  padding: EdgeInsets.only(top: 0),
                  color: Colors.grey[100],
                  child: Column(children: [
                    search(),
                    Flexible(child: RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: (listAdmins != null)
                      ? buildAdminList()
                      : Center(
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Color(0xFF00BFA6)),
                          ),
                        ),
                ))
              ])),
                  ])),
            ),
             CollapsingNavigationDrawer(),
      ],
    );;
  }



  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 3));
    setState(() {
      listAdmins = [];
    });
    _getAdmins();
    return null;
  }

  final passRegex = RegExp(r'[a-zA-Z0-9.!]{6,}');
  final emailRegex = RegExp(r'^[a-z0-9._]{2,}[@][a-z]{3,6}[.][a-z]{2,3}$');

  edit(String nname, String nlastname, String nemail, Admin admin, int nadminId,
      String pass1, String pass2) {
    if (nadminId == 0) {
      nadminId = admin.id;
    }
    if (nname == "") {
      nname = admin.firstName;
    }
    if (nlastname == "") {
      nlastname = admin.lastName;
    }
    if (nemail == "") {
      nemail = admin.email;
    }
    if (nname == admin.firstName &&
        nlastname == admin.lastName &&
        nemail == admin.email &&
        pass1 == "" &&
        pass2 == "" &&
        namePhoto == "") {
      setState(() {
        wrongRegText = "Nema promena.";
      });
      throw Exception("Nema promena.");
    } else {
      if (namePhoto != "") {
        String base64Image = base64Encode(data);
        APIServices.addImageWeb(base64Image).then((res) {
          var res1 = jsonDecode(res);
          APIServices.editAdminProfilePhoto(
              TokenSession.getToken, admin.id, res1);
        });
      }
      if (pass1 == "" && pass2 == "") {
        String jwt = TokenSession.getToken;
        APIServices.editAdminData(jwt, admin.id, nname, nlastname, nemail)
            .then((value) {});
      } else {
        String jwt = TokenSession.getToken;

        var tempPass1 = utf8.encode(pass1);
        var shaPass1 = sha1.convert(tempPass1);
        var tempPass2 = utf8.encode(pass2);
        var shaPass2 = sha1.convert(tempPass2);
        APIServices.editAdminData(jwt, admin.id, nname, nlastname, nemail);
        APIServices.editAdminPassword(
                jwt, admin.id, shaPass1.toString(), shaPass2.toString())
            .then((res) {
          if (res.statusCode == 200) {
            setState(() {
              password = '';
              oldPassword = '';
            });
          }
        });
      }
      showDial(context);
    }
  }

   deleteFromList(int userId) {
    for (int i = 0; i < listAdmins.length; i++) {
      if (listAdmins[i].id == userId) {
        setState(() {
          listAdmins.removeAt(i);
        });
        break;
      }
    }
}}