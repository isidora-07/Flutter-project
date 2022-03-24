import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_web/models/city.dart';
import 'package:frontend_web/models/institution.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/ui/InstitutionPages/loginPage/loginPage.dart';
import 'package:frontend_web/ui/home/homeView.dart';
import 'package:frontend_web/widgets/centeredView/centeredView.dart';
import 'package:frontend_web/widgets/homeNavigationBar/navigationBar.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:frontend_web/extensions/hoverExtension.dart';

Color greenPastel = Color(0xFF00BFA6);

class InstitutionRegisterPage extends StatefulWidget{
  @override
  _InstitutionRegisterPageState createState() => new _InstitutionRegisterPageState();
}

class _InstitutionRegisterPageState extends State<InstitutionRegisterPage>{
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        endDrawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
            ? HomeNavigationDrawer(1)
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
              (sizingInformation.deviceScreenType != DeviceScreenType.Mobile) ? HomeNavigationBar(1) : SizedBox(),
              Expanded(
                child: ScreenTypeLayout(
                  mobile: InstitutionRegisterMobilePage(),
                  desktop: InstitutionRegisterDesktopPage(),
                  tablet: InstitutionRegisterMobilePage(),
                ),
              )
            ],
          ),
        )
      )
    );
  }
  
}

class InstitutionRegisterMobilePage extends StatefulWidget{
  @override
  _InstitutionRegisterMobilePageState createState() => new _InstitutionRegisterMobilePageState();
}

class _InstitutionRegisterMobilePageState extends State<InstitutionRegisterMobilePage>{
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
            Image.asset('assets/undraw5.png'),
            InstitutionRegisterPageWidget(),
          ],
        )
      ],
    );
  }
}

class InstitutionRegisterDesktopPage extends StatefulWidget{
  @override
  _InstitutionRegisterDesktopPageState createState() => new _InstitutionRegisterDesktopPageState();
}

class _InstitutionRegisterDesktopPageState extends State<InstitutionRegisterDesktopPage>{
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[ 
        Row(children: <Widget>[
          Expanded(
            child: Center(
              child: Image.asset('assets/undraw5.png'),
            ),
          ),
          InstitutionRegisterPageWidget(),
        ],)
      ]
    );
  }
}

class InstitutionRegisterPageWidget extends StatefulWidget{
  @override
  _InstitutionRegisterPageWidgetState createState() => new _InstitutionRegisterPageWidgetState();
}

class _InstitutionRegisterPageWidgetState extends State<InstitutionRegisterPageWidget>{
  String wrongRegText = "";
  String loadingText = "";

  TextEditingController name = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController mobile = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController cpassword = new TextEditingController();

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
        style: TextStyle(color: greenPastel),
      ),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InstitutionLoginPage()),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Uspešna registracija"),
      content: Text("Putem mail-a će Vam stići povratna informacija kada administrator odobri Vaš zahtev i od tada možete koristiti aplikaciju."),
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

  _register(String name, String description, String email, String mobile,
      String password, int cityId) {
    

    final passRegex = RegExp(r'[a-zA-Z0-9.!]{6,40}');
    final emailRegex = RegExp(r'[a-z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}');
    final mobRegex = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');
    final nameRegex = RegExp(r'^[a-zA-Z0-9ŠšĐđŽžČčĆć\s]{1,50}$');

    
    if (cityId == 0) {
      setState(() {
        wrongRegText = "Izaberite grad.";
      });
      throw Exception("Izaberite grad.");
    }
    if (description == ""){
        setState(() {
              wrongRegText ="Unesite ponovo podatke o Vašoj instituciji.";
               });
              throw Exception("Unesite ponovo podatke o Vašoj instituciji.");
            }
      if (nameRegex.hasMatch(name)) {
        if (passRegex.hasMatch(password)){
          if(emailRegex.hasMatch(email)) {
            if (mobRegex.hasMatch(mobile)) {
                 setState(() {
                  loadingText="Podaci se obrađuju...";
                });
                var tempPass = utf8.encode(password);
                var shaPass = sha1.convert(tempPass);
                Institution ins = new  Institution.without(name, description, shaPass.toString(), email, mobile, cityId);
                print(ins);
                APIServices.registerInstitution(ins).then((response) {
                  if (response.statusCode == 200) {
                    setState(() {
                        loadingText = "";
                        showAlertDialog(context);                    });
                  }
                  else{
                    setState(() {
                      wrongRegText = "Došlo je do greške prilikom registracije. Molimo Vas pokušajte kasnije.";
                       loadingText = "";
                    });
                  }
                });

            }
            else {
              setState(() {
                wrongRegText ="Unesite ponovo mobilni.";
                              });
              throw Exception("Unesite ponovo mobilni.");
            }
          }
          else {
            setState(() {
              wrongRegText = "Unesite ponovo email.";
            });
            throw Exception("Unesite ponovo email.");
          }

      }
        else{
          setState(() {
            wrongRegText = "Unesite ponovo šifru.";
          });
          throw Exception("Unesite ponovo šifru.");
        }
      }
      else {
        setState(() {
          wrongRegText = "Molimo unesite ponovo naziv institucije.";
        });
        throw Exception("Molimo unesite ponovo naziv institucije.");
      }
}

  List<City> _city;
  City city;

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
    _getCity();
  }

  @override
  Widget build(BuildContext context) {

     final wrongReg = Center(
        child: Text(
      '$wrongRegText',
      style: TextStyle(
          color: Colors.red,
          fontSize: 25,
      ),
    ));
    final loader = Center(
        child: Text(
      '$loadingText',
      style: TextStyle(color: Color(0xFF00BFA6), fontSize: 15,),
    ));

    final institutionNameWidget = Container(
      width: 600,
      child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      elevation: 6.0,
      child: TextField(
        inputFormatters:[
          LengthLimitingTextInputFormatter(50),
          ],
        cursorColor: Colors.black,
        controller: name,
        style: TextStyle(
          //color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          hintText: "Naziv institucije",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 20, right: 15),
            child: Icon(Icons.person, color: greenPastel),
          ),
          contentPadding: EdgeInsets.all(18),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2, color: greenPastel),
          ),
        ),
      ).showCursorTextOnHover,
    ),);



  final aboutUsWidget = Container(
    width:600,
    child: Padding(
    padding: const EdgeInsets.all(15.0),
    child: TextField(
      inputFormatters:[
          LengthLimitingTextInputFormatter(100),
          ],
      cursorColor: Colors.black,
      controller: description,
      minLines: 5,
      maxLines: 15,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: 'Kratak opis delatnosti Vaše institucije',
        filled: true,
        fillColor: Color(0xffffffff),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: greenPastel),
        ),
      ),
    ).showCursorTextOnHover,
  ),
);

    final emailWidget = Container(
      width: 600,
      child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      elevation: 6.0,
      child: TextField(
        cursorColor: Colors.black,
        controller: email,
        style: TextStyle(
          //color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          hintText: "E-mail",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 20, right: 15),
            child: Icon(Icons.email, color: greenPastel),
          ),
          contentPadding: EdgeInsets.all(18),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2, color: greenPastel),
          ),
        ),
      ).showCursorTextOnHover,
    ),);

    final mobileNumberWidget = Container(
      width: 600,
      child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      elevation: 6.0,
      child: TextField(
        cursorColor: Colors.black,
        controller: mobile,
        style: TextStyle(
          //color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          hintText: "Mobilni telefon",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 20, right: 15),
            child: Icon(Icons.phone, color: greenPastel),
          ),
          contentPadding: EdgeInsets.all(18),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2, color: greenPastel),
          ),
        ),
        keyboardType: TextInputType.number,
      ).showCursorTextOnHover,
    ),);

    final passwordWidget = Container(
      width: 600,
      child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      elevation: 6.0,
      child: TextField(
        cursorColor: Colors.black,
        obscureText: _secureText,
        controller: password,
        style: TextStyle(
          //color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        decoration: InputDecoration(
          hintText: "Šifra",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50.0)),
          suffixIcon: IconButton(
            onPressed: showHide,
            icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility,
                color: greenPastel),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 20, right: 15),
            child: Icon(Icons.phonelink_lock, color: greenPastel),
          ),
          contentPadding: EdgeInsets.all(18),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2, color: greenPastel),
          ),
        ),
      ).showCursorTextOnHover,
    ),);


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
        ]).showCursorOnHover;

    final registerButtonWidget = SizedBox(
      width: 200.0,
      height: 50.0,
      child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Text(
            "Registruj se",
            style: TextStyle(fontSize: 16.0),
          ),
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          textColor: Colors.white,
          color: greenPastel,
          onPressed: () {
            if (city != null)
              _register(name.text, description.text, email.text, mobile.text,
                  password.text, city.id);
            else
              _register(name.text, description.text, email.text, mobile.text,
                  password.text, 0);
          }).showCursorOnHover,
    );

    final loginLabelWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Vec imate profil? '),
        SizedBox(
          width: 5.0,
        ),
        InkWell(
          child: Text(
            'Prijavite se.',
            style: TextStyle(
                color: greenPastel, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => InstitutionLoginPage()),
            );
          },
        ).showCursorOnHover,
      ],
    );

   

    return Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 30.0,
                    ),
                    wrongReg,
                    institutionNameWidget,
                    aboutUsWidget,
                    mobileNumberWidget,
                    emailWidget,
                    passwordWidget,
                    dropdownWidget,
                    SizedBox(
                      height: 8.0,
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
              );
  }
}