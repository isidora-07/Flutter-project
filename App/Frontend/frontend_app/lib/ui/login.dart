import 'dart:async';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/ui/registrationPage.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:convert';

import '../main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  String pogresanLoginText = '';

  User user;

  _login(String _email, String _password) {
    if (_email == '' || _password == '') {
      _emailController.text = "";
      _passwordController.text = "";
      setState(() {
        pogresanLoginText = "Podaci nisu ispravni.";
      });
      throw Exception('Loša e-mail adresa ili šifra.');
    } else {
      var pom = utf8.encode(_password);
      var pass = sha1.convert(pom);
      APIServices.login(_email.trim(), pass.toString()).then((response) {
        if (response != null) {
          storage.write(key: "jwt", value: response);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage.fromBase64(response)));
        } else {
          _passwordController.text = "";
          setState(() {
            pogresanLoginText = "Podaci nisu ispravni.";
          });
          throw Exception('Loša e-mail adresa ili šifra.');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //logo
    final logo = Hero(
      tag: 'hero',
      child: Center(
          child: Image.asset( 
        'assets/mojGradPastelna.png',
        width: 300,
      )),
    );

    //text box for email
    final emailText = TextField(
      cursorColor: MyApp.ind == 0 ? Colors.black : Colors.white,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email, color: Color(0xFF00BFA6)),
        hintText: 'E-mail',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(width: 2, color: Color(0xFF00BFA6)),
        ),
      ),
      controller: _emailController,
    );

    //text box for password
    final passwordText = TextField(
      cursorColor: MyApp.ind == 0 ? Colors.black : Colors.white,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock,
          color: Color(0xFF00BFA6),
        ),
        hintText: 'Šifra',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(width: 2, color: Color(0xFF00BFA6)),
        ),
      ),
      controller: _passwordController,
    );

    //button for login
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(50.0),
        shadowColor: Colors.lightGreenAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 50.0,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(50.0),
              side: BorderSide(color: Colors.transparent)),
          onPressed: () {
            // Call login function
            _login(_emailController.text, _passwordController.text);
          },
          color: Color(0xFF00BFA6),
          child: Text(
            'Uloguj se',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    //redirection to page for new users
    final registerLabel = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Novi korisnik?'),
        SizedBox(
          width: 5.0,
        ),
        InkWell(
          child: Text(
            'Registrujte se ovde.',
            style: TextStyle(
                color: Color(0xFF00BFA6), fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RegisterPage()),
            );
          },
        ),
      ],
    );

    final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

void _doSomething() async {
    Timer(Duration(seconds: 3), () {
       _btnController.reset();
    });
}


    emailAlert(BuildContext context) {
      String errorMessage ="er";
    TextEditingController customController = TextEditingController();
    TextEditingController customControllerError = TextEditingController(text: "");


    Widget notButton = RoundedLoadingButton(
       color:Colors.red,
       width: 60,
       height: 40,
       child: Text("Otkaži", style: TextStyle(color: Colors.white),),
      onPressed: () {
        Navigator.pop(context);
        },
    );

    
    return showDialog(
        context: context,
        builder: (context) {
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
                        Text("Zaboravili ste lozinku?",
                            style: TextStyle(
                                fontSize: 24,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color))
                      ],
                    ),
                    SizedBox(height: 5),
                    Text("Unesite e-mail adresu koju ste koristili prilikom registracije. Na unetu adresu će Vam stići poruka u kojoj se nalazi Vaša nova šifra."),
                    TextField(
                      cursorColor: MyApp.ind == 0 ? Colors.black : Colors.white,
                      controller: customController,
                      decoration: InputDecoration(
                        hoverColor: Colors.grey,
                        labelStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color,
                            fontStyle: FontStyle.italic),
                        fillColor: Colors.black,
                        contentPadding: const EdgeInsets.all(10.0),
                        focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF00BFA6)),
                   ), 
                      ),
                    ),
                  SizedBox(height: 5),
                  Text(
                    customControllerError.text,
                    style: TextStyle(color: Colors.red),
                  ),
                    SizedBox(height: 5),
                   
                RoundedLoadingButton(
                    height: 40,
                    child: Text('Pošalji', style: TextStyle(color: Colors.white)),
                    color: Color(0xFF00BFA6),
                    controller: _btnController,
                    onPressed:(){ 
                      _doSomething();
                      APIServices.forgottenPassword(customController.text.trim()).then((response) {
                            if (response.statusCode == 200) {
                              Navigator.pop(context);
                            } else {
                              setState(() {
                                print("Adresa nije ispravna");
                                customControllerError.text = "E-mail adresa nije ispravna.";
                                errorMessage = "E-mail adresa nije ispravna.";
                                customController.text="";
                              });
                            }
                          });
                    }
                ),
                 FlatButton(
                          child: Text(
                            "Otkaži",
                            style: TextStyle(
                                color: Theme.of(context).textTheme.bodyText1.color),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                
               
                  ],
                )),
                actions: [
             // okButton,
             // notButton,
            ],
          );
        });
  }


    final forgottenPassword = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 10,),
        InkWell(
          child: Text(
            'Zaboravili ste lozinku?',
            style: TextStyle(
                color: Color(0xFF00BFA6), fontWeight: FontWeight.bold),
          ),
          onTap: () {
           emailAlert(context);
          },
        ),
      ],
    );

    //in case of wrong login
    final pogresanLogin = Center(
        child: Text(
      '$pogresanLoginText',
      style: TextStyle(color: Colors.red),
    ));

    return Scaffold(
        backgroundColor: MyApp.ind == 0
            ? Colors.white
            : Theme.of(context).copyWith().backgroundColor,
        body: Center(
            child: Container(
          width: 400,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 48.0,
                  ),
                  emailText,
                  SizedBox(
                    height: 8.0,
                  ),
                  passwordText,
                  SizedBox(
                    height: 5.0,
                  ),
                  forgottenPassword,
                  SizedBox(
                    height: 8.0,
                  ),
                  pogresanLogin,
                  SizedBox(
                    height: 5.0,
                  ),
                  loginButton,
                ],
              ),
              registerLabel,
              SizedBox(
                height: 8.0,
              ),
              
            ],
          ),
        )));
  }
}
