import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/admin.dart';
import 'package:frontend_web/models/constants.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewManageUser.dart';
import 'package:frontend_web/widgets/circleImageWidget.dart';
import 'package:universal_html/prefer_universal/html.dart' as html;

Color greenPastel = Color(0xFF00BFA6);

class ManageAdminMobile extends StatefulWidget {
  final int id;

  const ManageAdminMobile(this.id);
  @override
  _ManageAdminMobileState createState() => _ManageAdminMobileState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;
 
  Debouncer({this.milliseconds});
 
  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _ManageAdminMobileState extends State<ManageAdminMobile> with SingleTickerProviderStateMixin{

  List<Admin> listAdmins;
  List<Admin> filteredAdmins;
  TextEditingController searchController = new TextEditingController();
  int idA;

  String wrongRegText = "";
  Admin admin;
  Image imageFile;

  String firstName = '', password = '', oldPassword = '', email = '', lastName = '';
  String spoljasnjeIme = '';
  String baseString;
  final _debouncer = Debouncer(milliseconds: 500);
  Animation<double> animation;
  AnimationController animationController;

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
                    ),
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
                            var array = check.split(" ");
                            print(array[0] + ", " + array[1]);
                            setState(() {
                                firstName = array[0];
                                lastName = array[1];
                            });
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: Text(
                            "Otkaži",
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
                    ),
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
                        ),
                        FlatButton(
                          child: Text(
                            "Otkaži",
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


  @override
  initState() {
    super.initState();

     idA = widget.id;
    _getAdmin(idA);
    _getAdmins();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 220, end: 80).animate(animationController);
    animationController.reverse();
  }

  @override
  void dispose() {
    searchController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return CenteredViewManageUser(
        child: TabBarView(children: <Widget>[
          RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: (admin1 != null)
                      ?
            Container( child: Center(
              child: loginAdmin(),
            ),)
             :Center(
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Color(0xFF00BFA6)),
                          ),
              )),
          Column(children: [
            new Row(
                children: [
                  Expanded(child: search()),
                ],
              ),
            Flexible(child: filteredAdmins==null ? buildAdminList(listAdmins) : buildAdminList(filteredAdmins)),
          ]),
        ]
        ),
      );
  }
  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 3));
    setState(() {
      listAdmins = [];
    });
    _getAdmin(idA);
     _getAdmins();
    return null;
  }

  deleteFromList(int userId){
    for(int i = 0; i < listAdmins.length; i++){
      if(listAdmins[i].id == userId){
        setState(() {
          listAdmins.removeAt(i);
        });
        break;
      }
    }
    
    for(int i = 0; i < listAdmins.length; i++){
      if(listAdmins[i].id == userId){
        setState(() {
          listAdmins.removeAt(i);
        });
        break;
      }
    }
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
                    ),
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
                    ),
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
                    ),
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

                            if (check == checkAgain) {
                              if (passRegex.hasMatch(check)) {
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
                        ),
                        FlatButton(
                          child: Text(
                            "Otkaži",
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
  showAlertDialog(BuildContext context, int id) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Obriši"),
      onPressed: () {
        APIServices.deleteAdmin(TokenSession.getToken,id);
        deleteFromList(id);
        Navigator.pop(context);
        },
    );
     Widget notButton = FlatButton(
      child: Text("Otkaži",),
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
                  ),
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
                  ),
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
          ),
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
          ),
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
          ),
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
                  ))),
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

  Widget buildAdminList(List<Admin> listUsers) {

    return ListView.builder(
      itemCount: listUsers == null ? 0 : listUsers.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                    listUsers[index].id != idA
                  ? 
                  Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(left:10.0,right: 10),
                      child: Row(children: [
                        CircleImage(
                          userPhotoURL + listUsers[index].photoPath,
                          imageSize: 36.0,
                          whiteMargin: 2.0,
                          imageMargin: 6.0,
                        ),
                        Container(
                          width: 120,
                          padding: EdgeInsets.only(left:10.0,right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(listUsers[index].firstName +" " + listUsers[index].lastName,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                        ),
                  
                        Expanded(child: SizedBox()),
                        PopupMenuButton<String>(
                          onSelected: (String choice) {
                            choiceActionAdmin(choice, listUsers[index].id, listUsers[index].firstName, listUsers[index].lastName, listUsers[index]);
                          },
                          itemBuilder: (BuildContext context) {
                            return ConstantsDelAdmin.choices.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                        ),
                      ])): Container(width: 1, height: 1) ,
                ],
              ),
            ));
      },
    );
  }

  void choiceActionAdmin(String choice, int userId, String firstname, String lastname, Admin user) {
   if (choice == ConstantsReportedUsers.ObrisiKorisnika) {
      print("Obrisi admina.");
      showAlertDialog(context, userId);
    } 
  }

  Widget search() {
    return Container(
      margin: EdgeInsets.only(left: 5, top:5, bottom: 5),
      width: 150,
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        cursorColor: Colors.black,
        onChanged: (string) {
          _debouncer.run(() { 
            setState(() {
              filteredAdmins = listAdmins
                    .where((u) => (((u.firstName.toLowerCase() + " " + u.lastName.toLowerCase())
                            .contains(string.toLowerCase()))))
                    .toList();
            });
          });
        },
        autofocus: false,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search,color: greenPastel),
          hintText: 'Pretraži...',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2,color: greenPastel),
          ),
        ),
        controller: searchController,
      )
    );
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
}

