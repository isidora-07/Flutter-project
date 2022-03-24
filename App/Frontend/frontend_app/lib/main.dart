import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/ui/splash.page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_client/signalr_client.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'bloc/themes.dart';
import 'package:rxdart/subjects.dart';

String notificationURL;
bool connectionIsOpen;
HubConnection hubConnection;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = IOSInitializationSettings();

  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint("notification payload: " + payload);
    }
    selectNotificationSubject.add(payload);
  });
   notificationURL = "http://10.0.2.2:60676" + "/notification";
  //notificationURL = "http://147.91.204.116:2043" + "/notification";
  //notificationURL = "http://192.168.1.4:45457" + "/notification";
  connectionIsOpen = false;

  openNotificationConnection();

  //runApp(new MyApp());
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]).then((_) {
    SharedPreferences.getInstance().then((prefs) {
  var darkModeOn = prefs.getBool('darkMode') ?? true;
  var indOn = prefs.getBool('ind') ?? true;
  if(indOn) 
    MyApp.ind = 1;
  else
    MyApp.ind = 0; 
  runApp(
     ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(darkModeOn ? ThemeData.dark() :ThemeData.light()),
      child: new MaterialAppWithTheme(),
    ),
  );
});
  });
}

class MyApp extends StatelessWidget { 
  static int ind = 0;

  @override
  Widget build(BuildContext context) {
   /*
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(ThemeData.light()),
      child: new MaterialAppWithTheme(),
    );
    */
   SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]).then((_) {
    SharedPreferences.getInstance().then((prefs) {
  var darkModeOn = prefs.getBool('darkMode') ?? true;
  var indOn = prefs.getBool('ind') ?? true;
  if(indOn) 
    MyApp.ind = 1;
  else
    MyApp.ind = 0; 
  runApp(
     ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(darkModeOn ? ThemeData.dark() :ThemeData.light()),
      child: new MaterialAppWithTheme(),
    ),
  );
});
  });
  }

  static themeLight() {
    TextTheme _themeLight(TextTheme base) {
      return base.copyWith(
        title: base.title.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.white),
      );
    }

    final ThemeData base = ThemeData.light();
    return base.copyWith(
        textTheme: _themeLight(base.textTheme),
        primaryColor: Colors.white,
        /*brightness: Brightness.light,
        accentColor: Colors.white,*/
        iconTheme: IconThemeData(color: Colors.black, size: 25),
        backgroundColor: Colors.white);
  }

  static themeDark() {
    TextTheme _themeDark(TextTheme base) {
      return base.copyWith(
        title: base.title.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.white),
      );
    }

    final ThemeData base = ThemeData.dark();
    return base.copyWith(
        textTheme: _themeDark(base.textTheme),
        primaryColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white, size: 25),
        backgroundColor: Colors.black45);
  }

  
}

class MaterialAppWithTheme extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

   initState() {
    configureSelectNotificationSubject();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moj Grad',
      theme: theme.getTheme(),
      home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            if (snapshot.data != "") {
              var str = snapshot.data;
              var jwt = str.split(".");
              if (jwt.length != 3) {
                return SplashPage("",0);
              } else {
                var payload = json.decode(
                    ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
                    .isAfter(DateTime.now())) {
                  int type = int.parse(payload["sub"]);
                  if(type != null && type != 0)
                    return SplashPage(str, type);
                  else
                    return SplashPage("", 0);
                } else {
                  return SplashPage("", 0);
                }
              }
            } else {
              return SplashPage("", 0);
            }
          }),
    );
  }

  void configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) {
      print(payload);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => SignupPage()),
      // );
    });
  }
}



Future<void> showNotification(String title, String body, int payload) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, title, body, platformChannelSpecifics,
      payload: payload.toString());
}

Future<void> openNotificationConnection() async {
  if (hubConnection == null) {
    hubConnection = HubConnectionBuilder().withUrl(notificationURL).build();
    hubConnection.onclose((error) => connectionIsOpen = false);
    hubConnection.on("OnNotification", handleIncommingNotification);
  }

  if (hubConnection.state != HubConnectionState.Connected) {
    await hubConnection.start();
    connectionIsOpen = true;
  }
}

void handleIncommingNotification(List<Object> args) {
  String title = args[0];
  String body = args[1];
  int payload = args[2];

  if (payload == 1) showNotification(title, body, payload);
}

Future<void> sendNotification(
    String title, String body, int payload, int userId) async {
  // title = "Resenje" \ "Solution"
  // body = "Pogledajte resenje za vas izazov" \ "See solution of your challenge"
  // payload = id of solution
  // userId = id of user who post challenge

  await openNotificationConnection();
  hubConnection.invoke("Send", args: <Object>[title, body, payload, userId]);
}