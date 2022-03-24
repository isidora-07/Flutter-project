import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/bloc/themes.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/models/fullPost.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/ui/login.dart';
import 'package:frontend/ui/top10Page.dart';
import 'package:frontend/widgets/postWidget.dart';
import 'package:frontend/widgets/userInfoWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'EditProfilePage.dart';
import 'package:provider/provider.dart';


class UserProfilePage extends StatefulWidget {
  final User user;

  UserProfilePage(this.user);

  @override
  State<StatefulWidget> createState() {
    return HeaderSection(user);
  }
}

class HeaderSection extends State<UserProfilePage> {
  ScrollController _scrollController;
  User user;
  HeaderSection(User user1) {
    user = user1;
    print("korisnik ${user1.id}");
  }

  final Color green = Color(0xFF00BFA6);
  List<FullPost> posts;
  bool darkThemeEnabled = MyApp.ind == 0 ? false : true;

  _getPosts() async {
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getPostsForUser(jwt, user.id).then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> listP = List<FullPost>();
      listP = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          posts = listP;
        });
      }
    });
  }

  _removeToken() async {
    storage.delete(key: "jwt");
  }

  @override
  void initState() {
    super.initState();
    _getPosts();
  }

  @override
  Widget build(BuildContext context) {
    ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    return new Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyApp.ind == 0
            ? Colors.white
            : Theme.of(context).copyWith().backgroundColor,
        iconTheme:
            IconThemeData(color: Theme.of(context).copyWith().iconTheme.color),
      ),
      endDrawer: Drawer(
          child: Container(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                child: Center(
              child: Text(
                user.firstName + " " + user.lastName,
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            )),
            ListTile(
              leading: Icon(Icons.edit,
                  color: Theme.of(context).copyWith().iconTheme.color,
                  size: Theme.of(context).copyWith().iconTheme.size),
              trailing: Icon(Icons.arrow_right,
                  color: Theme.of(context).copyWith().iconTheme.color),
              title: Text(
                'Izmeni profil',
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyText1.color),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProfilePage(user)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.star,
                  color: Theme.of(context).copyWith().iconTheme.color,
                  size: Theme.of(context).copyWith().iconTheme.size),
              title: Text(
                'Top 10',
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyText1.color),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Top10Page(user)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.brightness_medium,
                  color: Theme.of(context).copyWith().iconTheme.color,
                  size: Theme.of(context).copyWith().iconTheme.size),
              title: Text("Tamna tema",
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyText1.color)),
              trailing: Switch(
                value: darkThemeEnabled,
                onChanged: (changedTheme) async {
                  /*
                  APIServices.jwtOrEmpty().then((res) {
                              String jwt;
                              setState(() {
                                jwt = res;
                              });
                              if (res != null) {
                                APIServices.switchThemeForUser(jwt, userId);
                              }
                            });*/
                  setState(() {
                    darkThemeEnabled = changedTheme;
                    MyApp.ind = changedTheme ? 1 : 0;
                  });
                  changedTheme
                      ? _themeChanger.setTheme(MyApp.themeDark())
                      : _themeChanger.setTheme(MyApp.themeLight());
                  
                  if(changedTheme)
                  {
                     var prefs = await SharedPreferences.getInstance();
                      prefs.setBool('darkMode', true);
                      prefs.setBool('ind', true);
                  }
                  else
                  {
                     var prefs = await SharedPreferences.getInstance();
                      prefs.setBool('darkMode', false);
                      prefs.setBool('ind', false);
                  }
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.cancel,
                  color: Theme.of(context).copyWith().iconTheme.color,
                  size: Theme.of(context).copyWith().iconTheme.size),
              title: Text(
                'Deaktiviraj nalog',
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyText1.color),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    child: AlertDialog(
                      title: Text("Daktivacija profila?"),
                      content: Container(
                        height: 100,
                        child: Text(
                            "Deaktivacijom profila brišete Vaš profil, sve Vaše objave i rešenja iz baze podataka."),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            "Deaktiviraj",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            APIServices.jwtOrEmpty().then((res) {
                              String jwt;
                              setState(() {
                                jwt = res;
                              });
                              if (res != null) {
                                APIServices.deleteUser(jwt, userId);
                              }
                            });
                            _removeToken();
                            Navigator.pushAndRemoveUntil(context,   
                        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),    
                        (Route<dynamic> route) => route is LoginPage);
                          },
                        ),
                        FlatButton(
                          child: Text(
                            "Otkaži",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app,
                  color: Theme.of(context).copyWith().iconTheme.color,
                  size: Theme.of(context).copyWith().iconTheme.size),
              title: Text(
                'Odjavi se',
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyText1.color),
              ),
              onTap: () {
                _removeToken();
               
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      )),
      body: (user != null)
          ? NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
                return <Widget>[
                  // User information section
                  SliverToBoxAdapter(child: UserInfoWidget(user)),
                ];
              },
              body: (posts != null && posts != [] && posts.length != 0)
                  ? ListView.builder(
                      padding: EdgeInsets.only(bottom: 30.0),
                      itemCount: posts == null ? 0 : posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PostWidget(posts[index]);
                      })
                  : Center(child: Text("Trenutno nemate objava"),)
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Color(0xFF00BFA6)),
              ),
            ),
    );
  }
}
