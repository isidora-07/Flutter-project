import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/ui/login.dart';
import '../main.dart';
import '../models/city.dart';
import '../models/user.dart';
import '../services/api.services.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String wrongRegText = "";
  String loadingText = "";

  TextEditingController firstName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController mobile = new TextEditingController();
  TextEditingController username = new TextEditingController();
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: TextStyle(color: Color(0xFF00BFA6)),
      ),
      onPressed: () {
        Navigator.pushAndRemoveUntil(context,   
                        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),    
                        (Route<dynamic> route) => route is LoginPage);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Uspešna registracija"),
      content: Text("Na Vaš e-mail će za nekoliko sekundi stići lozinka koju možete koristiti. Prijavite se da biste nastavili."),
      actions: [
        okButton,
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

  _register(String firstName, String lastName, String email, String mobile,
      String password, String username, int cityId) {
    final flNameRegex = RegExp(r'^[a-zA-ZŠšĐđŽžČčĆć]{3,14}$');
    final mobRegex = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
    final emailRegex = RegExp(r'^[a-z0-9._]{2,}[@][a-z]{3,8}[.][a-z]{2,3}$');
    final usernameRegex = RegExp(r'^(?=[a-z0-9._]{5,20}$)(?!.*[_.]{2})[^_.].*[^_.]$');

    if (flNameRegex.hasMatch(firstName)) {
      if (flNameRegex.hasMatch(lastName)) {
        if (usernameRegex.hasMatch(username)) {
          if (mobRegex.hasMatch(mobile)) {
            if (emailRegex.hasMatch(email)) {
              if(city != null){
                setState(() {
                  loadingText="Podaci se obrađuju...";
                });
                User user = User.without(firstName, lastName, username, null, email, mobile, cityId,"Upload//ProfilePhoto//default.jpg");
                APIServices.registration(user).then((response) {
                  if (response.statusCode == 200) {
                    Map<String, dynamic> jsonObject =
                        json.decode(response.body);
                    User extractedUser = new User();
                    extractedUser = User.fromObject(jsonObject);
                    User user1;
                    setState(() {
                      user1 = extractedUser;
                      loadingText = "";
                      wrongRegText = "";
                    });
                    if (user1 != null) {
                      showAlertDialog(context);
                    }
                  } else {
                    setState(() {
                      loadingText = "";
                      wrongRegText = "E-mail adresa ili korisničko ime su zauzeti.".toUpperCase();
                    });
                    throw Exception('E-mail adresa ili korisničko ime su zauzeti.');
                  }
                });            
              }else{
                setState(() {
                wrongRegText = "Grad nije izabran.";
              });
              throw Exception("Grad nije izabran.");
              }
            } else {
              setState(() {
                wrongRegText = "Neispravna e-mail adresa.";
              });
              throw Exception("Neispravna e-mail adresa.");
            }
          } else {
            setState(() {
              wrongRegText = "Ponovo unesite broj telefona.\nTelefon može biti u formatu 064 111111";
            });
            throw Exception("Ponovo unesite broj telefona.");
          }
        } else {
          setState(() {
            wrongRegText = "Korisničko ime mora imati najmanje 5 karaktera.\nKoriste se samo mala slova, brojevi i simboli(. _ )";
          });
          throw Exception("Ponovo unesite korisničko ime.");
        }
      } else {
        setState(() {
          wrongRegText = "Unesite ispravno prezime.\nPrezime mora imati najmanje 3 slova.";
        });
        throw Exception("Unesite drugo prezime.");
      }
    } else {
      setState(() {
        wrongRegText = "Unestite ispravno ime.\nIme mora imati najmanje 3 slova.";
      });
      throw Exception("Unesite drugo ime.");
    }
  }

  List<City> _city;
  City city;

  //function that adds cities to list
  _getCity() async {
    APIServices.getCity().then((res) {
      Iterable list = json.decode(res.body);
      List<City> cities = new List<City>();
      cities = list.map((model) => City.fromObject(model)).toList();
      setState(() {
        _city = cities;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getCity();
  }

  @override
  Widget build(BuildContext context) {
    final logoWidget = Hero(
      tag: 'hero',
      child: Center(
          child: Image.asset(
        'assets/mojGradPastelna.png',
        width: 300,
      )),
    );

    final firstNameWidget = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      elevation: 6.0,
      child: TextField(
        cursorColor: MyApp.ind == 0 ? Colors.black : Colors.white,
        controller: firstName,
        inputFormatters:[
      LengthLimitingTextInputFormatter(15),
      ],
        style: TextStyle(
          //color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 20, right: 15),
            child: Icon(Icons.person, color: Color(0xFF00BFA6)),
          ),
          contentPadding: EdgeInsets.all(18),
          hintText: "Ime",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2, color: Color(0xFF00BFA6)),
          ),
        ),
      ),
    );

    final lastNameWidget = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      elevation: 6.0,
      child: TextField(
        cursorColor: MyApp.ind == 0 ? Colors.black : Colors.white,
        controller: lastName,
        inputFormatters:[
      LengthLimitingTextInputFormatter(15),
      ],
        style: TextStyle(
          //color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 20, right: 15),
            child: Icon(Icons.person, color: Color(0xFF00BFA6)),
          ),
          contentPadding: EdgeInsets.all(18),
          hintText: "Prezime",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2, color: Color(0xFF00BFA6)),
          ),
        ),
      ),
    );

    final usernameWidget = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      elevation: 6.0,
      child: TextField(
        cursorColor: MyApp.ind == 0 ? Colors.black : Colors.white,
        controller: username,
        inputFormatters:[
      LengthLimitingTextInputFormatter(15),
      ],
        style: TextStyle(
          //color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 20, right: 15),
            child: Icon(Icons.adb, color: Color(0xFF00BFA6)),
          ),
          contentPadding: EdgeInsets.all(18),
          hintText: "Korisničko ime",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2, color: Color(0xFF00BFA6)),
          ),
        ),
      ),
    );

    final emailWidget = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      elevation: 6.0,
      child: TextField(
       cursorColor: MyApp.ind == 0 ? Colors.black : Colors.white,
        controller: email,
        style: TextStyle(
          //color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 20, right: 15),
            child: Icon(Icons.email, color: Color(0xFF00BFA6)),
          ),
          contentPadding: EdgeInsets.all(18),
          hintText: "E-mail adresa",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2, color: Color(0xFF00BFA6)),
          ),
        ),
      ),
    );

    final mobileNumberWidget = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      elevation: 6.0,
      child: TextField(
       cursorColor: MyApp.ind == 0 ? Colors.black : Colors.white,
        controller: mobile,
        style: TextStyle(
          //color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 20, right: 15),
            child: Icon(Icons.phone, color: Color(0xFF00BFA6)),
          ),
          contentPadding: EdgeInsets.all(18),
          hintText: "Mobilni telefon",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2, color: Color(0xFF00BFA6)),
          ),
        ),
        keyboardType: TextInputType.number,
      ),
    );

    final dropdownWidget = new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text("Izaberite svoj grad: ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
          new Container(
            padding: new EdgeInsets.all(16.0),
          ),
          _city != null
              ? new DropdownButton<City>(
                  hint: Text("Izaberi"),
                  value: city,
                  onChanged: (City newValue) {
                    setState(() {
                      city = newValue;
                    });
                  },
                  items: _city.map((City option) {
                    return DropdownMenuItem(
                      child: new Text(option.name),
                      value: option,
                    );
                  }).toList(),
                )
              : new DropdownButton<String>(
                  hint: Text("Izaberi"),
                  onChanged: null,
                  items: null,
                ),
        ]);

    final registerButtonWidget = SizedBox(
      height: 48.0,
      child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Text(
            "Registruj se",
            style: TextStyle(fontSize: 16.0),
          ),
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          textColor: Colors.white,
          color: Color(0xFF00BFA6),
          onPressed: () {
            if (city != null)
              _register(firstName.text, lastName.text, email.text, mobile.text,
                  null, username.text, city.id);
            else
              _register(firstName.text, lastName.text, email.text, mobile.text,
                  null, username.text, 1);
          }),
    );

    final loginLabelWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Već imate nalog? ', style: TextStyle(color: MyApp.ind == 0 ? Colors.black : Colors.white,),),
        SizedBox(
          width: 5.0,
        ),
        InkWell(
          child: Text(
            'Prijavite se.',
            style: TextStyle(
                color: Color(0xFF00BFA6), fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ],
    );

    final wrongReg = Center(
        child: Text(
      '$wrongRegText',
      style: TextStyle(color: Colors.red),
      textAlign: TextAlign.center,
    ));

      final loader = Center(
        child: Text(
      '$loadingText',
      style: TextStyle(color: Color(0xFF00BFA6)),
    ));

    return Scaffold(
      backgroundColor: MyApp.ind == 0 ? Colors.white :  Colors.black26,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: MyApp.ind == 0 ? Colors.white :  Colors.black26,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    logoWidget,
                    SizedBox(
                      height: 15.0,
                    ),
                    wrongReg,
                    firstNameWidget,
                    lastNameWidget,
                    usernameWidget,
                    mobileNumberWidget,
                    emailWidget,
                    dropdownWidget,
                    SizedBox(
                      height: 9.0,
                    ),
                    loader,
                    SizedBox(
                      height: 2.0,
                    ),
                    registerButtonWidget,
                    SizedBox(
                      height: 12.0,
                    ),
                    loginLabelWidget,
                    SizedBox(
                      height: 12.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
