import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:frontend_web/models/city.dart';
import 'package:frontend_web/models/institution.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/widgets/circleImageWidget.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

import 'package:frontend_web/extensions/hoverExtension.dart';

import '../../../services/api.services.dart';
import '../../../services/token.session.dart';
import '../loginPage/loginPage.dart';


class EditInstitutionDesktopPage extends StatefulWidget {
  final Institution institution;

  EditInstitutionDesktopPage(this.institution);

  @override
  _EditInstitutionDesktopPageState createState() =>
      _EditInstitutionDesktopPageState();
}

class _EditInstitutionDesktopPageState
    extends State<EditInstitutionDesktopPage> {
  String wrongRegText = "";
  Institution institution;
  Image imageFile;

  String name = '',
      password = '',
      oldPassword = '',
      email = '',
      description = '',
      phone = '',
      cityName = '';
  int cityId = 0;
  String spoljasnjeIme = '';
  String baseString;
  String city1 = '';
  int city1Id = 0;

  _getCity() {
    APIServices.getCity1().then((res) {
      Iterable list = json.decode(res.body);
      List<City> listC = List<City>();
      listC = list.map((model) => City.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          _city = listC;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    institution = widget.institution;
    _getCity();
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

  _removeToken() async {
    TokenSession.setToken = "";
  }


  showDeactivateDialog(BuildContext context, int id) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Potvrdi",),
      onPressed: () {
        APIServices.deleteInstitution(TokenSession.getToken, id);
        _removeToken();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InstitutionLoginPage()),
        );
      },
    );

    Widget notButton = FlatButton(
      child: Text("Otkaži", style: TextStyle(color: Colors.red),),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Deaktivacija naloga'),
      content: Text("Potvrdite deaktivaciju naloga"),
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








  Future<String> institutionName(BuildContext context, String instName) {
    TextEditingController customController;
    if (name == '') {
      customController = new TextEditingController(text: "$instName");
    } else {
      String _instName = name;
      customController = new TextEditingController(text: "$_instName");
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
                          "Naziv institucije",
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
                      /*decoration: InputDecoration(
                        hoverColor: Colors.grey,
                        labelStyle: TextStyle(
                            color: greenPastel, fontStyle: FontStyle.italic),
                        fillColor: Colors.black,
                        contentPadding: const EdgeInsets.all(10.0),
                      ),*/
                    ).showCursorTextOnHover,
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        MaterialButton(
                          child: Text(
                            "Izmeni",
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            var check = customController.text;
                            print(check);
                            setState(() {
                              name = check;
                            });
                            Navigator.pop(context);
                          },
                        ).showCursorOnHover,
                        FlatButton(
                          child: Text(
                            "Otkaži",
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

  Future<String> instDescription(BuildContext context, String instDescription) {
    TextEditingController customController;
    if (description == '') {
      customController = new TextEditingController(text: "$instDescription");
    } else {
      String _instDescription = description;
      customController = new TextEditingController(text: "$_instDescription");
    }
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            content: Container(
                width: 450,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Cilj institucije",
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
                      key: Key('atext'),
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: 15,
                      controller: customController,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: greenPastel),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelStyle: TextStyle(color: Colors.black)),
                      /* decoration: InputDecoration(
                        hoverColor: Colors.grey,
                        labelStyle: TextStyle(
                            color: greenPastel, fontStyle: FontStyle.italic),
                        fillColor: Colors.black,
                        contentPadding: const EdgeInsets.all(10.0),
                      ),*/
                    ).showCursorTextOnHover,
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(width: 50),
                        MaterialButton(
                          child: Text(
                            "Izmeni",
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            var check = customController.text;
                            print(check);
                            setState(() {
                              description = check;
                            });
                            Navigator.pop(context);
                          },
                        ).showCursorOnHover,
                        FlatButton(
                          child: Text(
                            "Otkaži",
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

  Future<String> instPhone(BuildContext context, String instPhone) {
    TextEditingController customController;
    if (phone == '') {
      customController = new TextEditingController(text: "$instPhone");
    } else {
      String _instPhone = phone;
      customController = new TextEditingController(text: "$_instPhone");
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
                        Text("Kontakt telefon",
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
                      /* decoration: InputDecoration(
                        hoverColor: Colors.grey,
                        labelStyle: TextStyle(
                            color: greenPastel, fontStyle: FontStyle.italic),
                        fillColor: Colors.black,
                        contentPadding: const EdgeInsets.all(10.0),
                      ),*/
                    ).showCursorTextOnHover,
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        MaterialButton(
                          child: Text(
                            "Izmeni",
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            var check = customController.text;
                            print(check);
                            if (mobRegex.hasMatch(check)) {
                              setState(() {
                                phone = check;
                              });
                              Navigator.of(context).pop();
                            } else {
                              check = "Greska";
                              setState(() {
                                wrongRegText =
                                    "Broj telefona nije u dobrom formatu.";
                              });
                              print(check);
                              Navigator.of(context).pop(check.toString());
                            }
                          },
                        ).showCursorOnHover,
                        FlatButton(
                          child: Text(
                            "Otkaži",
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

  Future<String> instEmail(BuildContext context, String instEmail) {
    TextEditingController customController;
    if (email == '') {
      customController = new TextEditingController(text: "$instEmail");
    } else {
      String _instEmail = phone;
      customController = new TextEditingController(text: "$_instEmail");
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
                      /*decoration: InputDecoration(
                        hoverColor: Colors.grey,
                        labelStyle: TextStyle(
                            color: greenPastel, fontStyle: FontStyle.italic),
                        fillColor: Colors.black,
                        contentPadding: const EdgeInsets.all(10.0),
                      ),*/
                    ).showCursorTextOnHover,
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        MaterialButton(
                          child: Text(
                            "Izmeni",
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
  Future<String> instPassword(BuildContext context) {
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
                      /*decoration: InputDecoration(
                        hoverColor: Colors.grey,
                        hintText: "Trenutna šifra",
                        labelStyle: TextStyle(
                            color: greenPastel, fontStyle: FontStyle.italic),
                        fillColor: greenPastel,
                        contentPadding: const EdgeInsets.all(10.0),
                      ),*/
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
                      /* decoration: InputDecoration(
                        hoverColor: Colors.grey,
                        hintText: "Nova šifra",
                        labelStyle: TextStyle(
                            color: greenPastel, fontStyle: FontStyle.italic),
                        fillColor: Colors.black,
                        contentPadding: const EdgeInsets.all(10.0),
                      ),*/
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
                      /*decoration: InputDecoration(
                        hoverColor: Colors.grey,
                        hintText: "Ponovi šifru",
                        labelStyle: TextStyle(
                            color: greenPastel, fontStyle: FontStyle.italic),
                        fillColor: Colors.black,
                        contentPadding: const EdgeInsets.all(10.0),
                      ),*/
                    ).showCursorTextOnHover,
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        MaterialButton(
                          child: Text(
                            "Izmeni",
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            var temp2 = password1.text; //trenutna
                            var check = password2.text; //nova
                            var checkAgain = password3.text;
                            print(temp2);
                            print(instPassword);

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

  List<City> _city;
  City city;

  Future<String> editCity(BuildContext context, String cityName) async {
    // show the dialog
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        City pomCity;
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            content: Container(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Grad", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
                      ],
                    ),
                    SizedBox(height: 5),
                    Center(
                        child: Row(
                      children: <Widget>[
                        _city != null
                            ? DropdownButton<City>(
                                hint: Text("Izaberi",
                                    style: TextStyle(color: Colors.black)),
                                value: pomCity,
                                onChanged: (City value) {
                                  setState(() {
                                    pomCity = value;
                                    city1 = value.name;
                                    city1Id = value.id;
                                  });
                                },
                                items: _city.map((City option) {
                                  return DropdownMenuItem<City>(
                                    value: option,
                                    child: Text(option.name),
                                  );
                                }).toList(),
                              )
                            : DropdownButton<String>(
                                hint: Text("Izaberi",
                                    style: TextStyle(color: Colors.black)),
                                onChanged: null,
                                items: null,
                              ),
                      ],
                    ).showCursorOnHover),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        MaterialButton(
                          child: Text(
                            "Izmeni",
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            if (pomCity != null) {
                              Navigator.pop(context, pomCity.name);
                            }
                          },
                        ).showCursorOnHover,
                        FlatButton(
                          child: Text(
                            "Otkaži",
                          ),
                          onPressed: () {
                            setState(() {
                              city1 = '';
                              city1Id = 0;
                            });

                            Navigator.pop(context, '');
                          },
                        ).showCursorOnHover,
                      ],
                    )
                  ],
                )),
          );
        });
      },
    );
  }

  /*
  final deactLabelWidget = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text('Želite da deaktivirate nalog Vaše institucije? '),
      SizedBox(
        width: 5.0,
      ),
      InkWell(
        child: Text(
          'Deaktiviraj nalog.',
          style: TextStyle(
              color: Colors.redAccent[800], fontWeight: FontWeight.bold),
        ),
        onTap: () {
        },
      ).showCursorOnHover,
    ],
  );
*/




  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 5),
      width: 600,
      child: ListView(
        children: <Widget>[
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
                                userPhotoURL + institution.photoPath,
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
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ).showCursorOnHover,
                  SizedBox(
                    height: 10,
                  )
                ],
              )),
          ListTile(
            leading:
                Icon(Icons.business, color: Color.fromRGBO(15, 32, 67, 100)),
            title: Text('Naziv institucije',
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: name == '' ? Text(institution.name) : Text(name),
            trailing: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(11.0),
                  side: BorderSide(color: Colors.grey)),
              color: Colors.grey,
              child: Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                institutionName(context, institution.name);
              },
            ),
          ).showCursorOnHover,
          ListTile(
            leading:
                Icon(Icons.description, color: Color.fromRGBO(15, 32, 67, 100)),
            title: Text('Opis institucije',
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: description == ''
                ? Text(institution.description)
                : Text(description),
            trailing: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(11.0),
                  side: BorderSide(color: Colors.grey)),
              color: Colors.grey,
              child: Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                instDescription(context, institution.description);
              },
            ),
          ).showCursorOnHover,
          ListTile(
            leading: Icon(Icons.email, color: Color.fromRGBO(15, 32, 67, 100)),
            title: Text(
              'Email',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: email == '' ? Text(institution.email) : Text(email),
            trailing: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(11.0),
                  side: BorderSide(color: Colors.grey)),
              color: Colors.grey,
              child: Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                instEmail(context, institution.email);
              },
            ),
          ).showCursorOnHover,
          ListTile(
            leading: Icon(Icons.phone, color: Color.fromRGBO(15, 32, 67, 100)),
            title: Text(
              'Kontakt telefon',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: phone == '' ? Text(institution.phone) : Text(phone),
            trailing: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(11.0),
                  side: BorderSide(color: Colors.grey)),
              color: Colors.grey,
              child: Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                instPhone(context, institution.phone);
              },
            ),
          ).showCursorOnHover,
          ListTile(
            leading: Icon(Icons.phonelink_lock,
                color: Color.fromRGBO(15, 32, 67, 100)),
            title: Text(
              'Šifra',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("******"),
            trailing: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(11.0),
                  side: BorderSide(color: Colors.grey)),
              color: Colors.grey,
              child: Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                instPassword(context);
              },
            ),
          ).showCursorOnHover,
          ListTile(
            leading: Icon(Icons.location_city,
                color: Color.fromRGBO(15, 32, 67, 100)),
            title: Text(
              'Grad',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(city1 == '' ? institution.cityName : city1),
            trailing: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(11.0),
                  side: BorderSide(color: Colors.grey)),
              color: Colors.grey,
              child: Icon(Icons.edit, color: Colors.white),
              onPressed: () async {
                var res = await editCity(context, institution.cityName);
                setState(() {
                  city1 = res;
                });
              },
            ),
          ).showCursorOnHover,
          Center(
              child: Container(
                  width: 600,
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
                      if (city1Id != 0) {
                        edit(name, description, email, phone, city1Id,
                            institution, oldPassword, password);
                      } else {
                        edit(name, description, email, phone, 0, institution,
                            oldPassword, password);
                      }
                    },
                  ).showCursorOnHover)),
          Center(
              child: Text(
            wrongRegText,
            style: TextStyle(
              color: Colors.red,
            ),
          )),
          FlatButton(
            child: Text('Da li želite da deaktivirate Vaš nalog?',
            style: TextStyle(
                color: Colors.redAccent[800], fontWeight: FontWeight.bold
            )
            ),
            onPressed: () {
              showDeactivateDialog(context, institution.id);
            },
          ),
        ],
      ),
    ));
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
                      children: <Widget>[Text("Uspešno ste promenili podatke")],
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

  final passRegex = RegExp(r'[a-zA-Z0-9.!]{6,}');
  final emailRegex = RegExp(r'^[a-z0-9._]{2,}[@][a-z]{3,6}[.][a-z]{2,3}$');
  final mobRegex = RegExp(r'^06[0-9]{7,9}$');

  edit(String nname, String ndescription, String nemail, String nmobile,
      int ncityId, Institution institution, String pass1, String pass2) {
    if (ncityId == 0) {
      ncityId = institution.cityId;
    }
    if (nname == "") {
      nname = institution.name;
    }
    if (ndescription == "") {
      ndescription = institution.description;
    }
    if (nemail == "") {
      nemail = institution.email;
    }
    if (nmobile == "") {
      nmobile = institution.phone;
    }
    if (nname == institution.name &&
        ndescription == institution.description &&
        nemail == institution.email &&
        nmobile == institution.phone &&
        ncityId == institution.cityId &&
        pass1 == "" &&
        pass2 == "" &&
        namePhoto == "") {
      setState(() {
        wrongRegText = "Niste izmenili ništa.";
      });
      throw Exception("Nista niste izmenili");
    } else {
      if (namePhoto != "") {
        String base64Image = base64Encode(data);
        APIServices.addImageWeb(base64Image).then((res) {
          var res1 = jsonDecode(res);
          APIServices.editInstitutionProfilePhoto(
              TokenSession.getToken, institution.id, res1);
        });
      }
      if (pass1 == "" && pass2 == "") {
        String jwt = TokenSession.getToken;
        APIServices.editInstitutionData(jwt, institution.id, nname, nemail,
                nmobile, ndescription, ncityId)
            .then((value) {});
      } else {
        String jwt = TokenSession.getToken;

        var tempPass1 = utf8.encode(pass1);
        var shaPass1 = sha1.convert(tempPass1);
        var tempPass2 = utf8.encode(pass2);
        var shaPass2 = sha1.convert(tempPass2);
        APIServices.editInstitutionData(
            jwt, institution.id, nname, nemail, nmobile, ndescription, ncityId);
        APIServices.editInstitutionPassword(
                jwt, institution.id, shaPass1.toString(), shaPass2.toString())
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
}
