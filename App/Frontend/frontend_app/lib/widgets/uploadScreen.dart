import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/ui/homePage.dart';

class UploadScreen extends StatefulWidget {
  String jwt;

  UploadScreen(this.jwt);

  @override
  _UploadScreenState createState() => _UploadScreenState(jwt);
}

class _UploadScreenState extends State<UploadScreen>{
  
  String jwt;
  _UploadScreenState(String jwt1){
    this.jwt = jwt1;
  }

  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage.fromBase64(jwt)),
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
            Text("Vaša obajva se šalje na server.")
          ],
        ),
      )
    );
  }
  
}

class UploadScreenSolver extends StatefulWidget {

  @override
  _UploadScreenSolverState createState() => _UploadScreenSolverState();
}

class _UploadScreenSolverState extends State<UploadScreenSolver>{

  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context,1);
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