import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/ui/InstitutionPages/registerPage/registerPage.dart';
import 'package:frontend_web/ui/home/homeView.dart';
import 'package:frontend_web/ui/homePage.dart';
import 'package:frontend_web/widgets/centeredView/centeredView.dart';
import 'package:frontend_web/widgets/homeNavigationBar/navigationBar.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:frontend_web/extensions/hoverExtension.dart';

import '../homePage/homePage.dart';

Color greenPastel = Color(0xFF00BFA6);

class InstitutionLoginPage extends StatefulWidget{
  @override
  _InstitutionLoginPageState createState() => new _InstitutionLoginPageState();
}

class _InstitutionLoginPageState extends State<InstitutionLoginPage>{
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        endDrawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
            ? HomeNavigationDrawer(4)
            : null,
        appBar: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
            ? AppBar(
              leading: new Container(),
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              title: InkWell(
                child: SizedBox(
                  width: 150,
                  child: Image.asset('assets/mojGrad2.png'),
                ),
                onTap: (){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeView()
                    )
                  );
                },
              ),
            )
            : null,
        backgroundColor: Colors.white,
        body: CenteredView(
          child: Column(
            children: <Widget>[
              (sizingInformation.deviceScreenType != DeviceScreenType.Mobile) ? HomeNavigationBar(4) : SizedBox(),
              Expanded(
                child: ScreenTypeLayout(
                  mobile: InstitutionAdminLoginMobilePage(),
                  desktop: InstitutionLoginDesktopPage(),
                  tablet: InstitutionAdminLoginMobilePage(),
                ),
              )
            ],
          ),
        )
      )
    );
  }
}

class InstitutionAdminLoginMobilePage extends StatefulWidget{
  @override
  _InstitutionLoginMobilePageState createState() => new _InstitutionLoginMobilePageState();
}

class _InstitutionLoginMobilePageState extends State<InstitutionAdminLoginMobilePage>{
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 100,),
            Image.asset('assets/undraw2.png'),
            InstitutionLoginPageWidget(),
          ],
        )
      ],
    );
  }
}

class InstitutionLoginDesktopPage extends StatefulWidget{
  @override
  _InstitutionLoginDesktopPageState createState() => new _InstitutionLoginDesktopPageState();
}

class _InstitutionLoginDesktopPageState extends State<InstitutionLoginDesktopPage>{
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[ 
        Row(children: <Widget>[
          Expanded(
            child: Center(
              child: Image.asset('assets/undraw2.png'),
            ),
          ),
          InstitutionLoginPageWidget(),
        ],)
      ]
    );
  }
}


class InstitutionLoginPageWidget extends StatefulWidget{
  @override
  _InstitutionLoginPageWidgetState createState() => new _InstitutionLoginPageWidgetState();
}

class _InstitutionLoginPageWidgetState extends State<InstitutionLoginPageWidget>{
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  String pogresanLoginText = '';


  void initState(){
    super.initState();
 
  }

  _login(String _email, String _password){
    if( _email == '' || _password == '' )
    {
      _emailController.text = "";
      _passwordController.text = "";
      setState(() {
        pogresanLoginText = "Podaci nisu ispravni";
      });
      throw Exception('Los email/sifra');
    }
    else{
      var pom = utf8.encode(_password);
      var pass = sha1.convert(pom);
      APIServices.login(_email, pass.toString()).then((response){
         if (response != null) {
          TokenSession.setToken = response;
          print(response);
           var str = response;
            var jwt = str.split(".");

            if(jwt.length !=3) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeView()
                    )
                  );
            } else {
              var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
              if(DateTime.fromMillisecondsSinceEpoch(payload["exp"]*1000).isAfter(DateTime.now())) {
                int type = int.parse(payload["nameid"]);
                if(type == 1)
                   Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(str, payload)
                    )
                  );
                else
                   Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePageInstitution(str,payload)
                    )
                  );
              } else {
                 _passwordController.text = "";
                setState(() {
                  pogresanLoginText = "PODACI NISU ISPRAVNI";
                });
              }
            }
        }
         else {
          _passwordController.text = "";
          setState(() {
            pogresanLoginText = "PODACI NISU ISPRAVNI";
          });
          throw Exception('Bad username/password');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context){

    //text box for email
    final emailText = TextField(
      cursorColor: Colors.black,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email,color: greenPastel),
        hintText: 'E-mail',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(width: 2,color: greenPastel),
        ),
      ),
      controller: _emailController,
    ).showCursorTextOnHover;

    //text box for password
    final passwordText = TextField(
      cursorColor: Colors.black,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock,color: greenPastel,),
        hintText: 'Šifra',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(width: 2,color: greenPastel),
        ),
      ),
      onSubmitted: (text){
        _login(_emailController.text, _passwordController.text);
      },
      controller: _passwordController,
    ).showCursorTextOnHover;

    //button for login
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(50.0),
        shadowColor: Colors.black,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 50.0,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(50.0),
            side: BorderSide(color: Colors.transparent)
          ),
          onPressed: (){
            // Call login function
            _login(_emailController.text, _passwordController.text);
            
          },
          color: greenPastel,
          child: Text(
            'Uloguj se',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ).showCursorOnHover,
      ),
    );

    //in case of wrong login
    final pogresanLogin = Center( child: Text(
        '$pogresanLoginText',
        style: TextStyle(color: Colors.red),
      )
    );

      final registrationLabelWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Nemate profil? '),
        SizedBox(
          width: 5.0,
        ),
        InkWell(
            child: Text(
            'Registruj se.',
            style: TextStyle(
                color: greenPastel, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => InstitutionRegisterPage()),
            );
          },
        ).showCursorOnHover,
      ],
    );


    return Container(
            width: 400,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height: 48.0,),
                    emailText,
                    SizedBox(height: 8.0,),
                    passwordText,
                    SizedBox(height: 24.0,),
                    loginButton,
                    registrationLabelWidget,
                  ], 
                ),
                SizedBox(height: 8.0,),
                pogresanLogin,
              ],
            ),
          );
  }
}