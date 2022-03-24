import 'package:flutter/material.dart';
import 'package:frontend_web/ui/InstitutionPages/loginPage/loginPage.dart';
import 'package:frontend_web/ui/home/aboutUs.dart';
import 'package:frontend_web/ui/home/contactPage.dart';
import 'package:frontend_web/ui/home/homeView.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:frontend_web/extensions/hoverExtension.dart';

Color greenPastel = Color(0xFF00BFA6);

class HomeNavigationBar extends StatelessWidget {
  final int selected;
  HomeNavigationBar(this.selected);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      desktop: HomeNavigationBarTabletDesktop(selected),
      mobile: HomeNavigationBarMobile(selected),
      tablet: HomeNavigationBarTabletDesktop(selected),
    );
  }
}

class HomeNavigationBarMobile extends StatelessWidget {
  final int selected;
  HomeNavigationBarMobile(this.selected);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            child: SizedBox(
              width: 180,
              child: Image.asset('assets/mojGrad2.png'),
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomeView()));
            },
          ).showCursorOnHover,
          new Builder(builder: (context) {
            return IconButton(
              icon: Icon(Icons.toc),
              onPressed: () {
                Scaffold.of(context).openDrawer();
                print('Nece da pull endDrawer');
              },
            );
          })
        ],
      ),
    );
  }
}

class HomeNavigationBarTabletDesktop extends StatelessWidget {
  final int selected;
  HomeNavigationBarTabletDesktop(this.selected);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            child: SizedBox(
              width: 180,
              child: Image.asset('assets/mojGrad2.png'),
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomeView()));
            },
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              InkWell(
                child: Text(
                  "O nama",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: (selected == 2) ? greenPastel : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutUs()));
                },
              ).showCursorOnHover,
              SizedBox(
                width: 15,
              ),
              InkWell(
                child: Text(
                  "Kontakt",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: (selected == 3) ? greenPastel : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ContactPage()));
                },
              ).showCursorOnHover,
              SizedBox(
                width: 15,
              ),
              InkWell(
                child: Text(
                  "Prijava",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: (selected == 4) ? greenPastel : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InstitutionLoginPage()));
                },
              ).showCursorOnHover,
              SizedBox(
                width: 5,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomeNavigationDrawer extends StatelessWidget {
  final int selected;
  HomeNavigationDrawer(this.selected);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text("MOJ GRAD"),
            ),
          ),
          ListTile(
            leading: Icon(Icons.people_outline),
            title: Text(
              'O nama',
              style: TextStyle(
                  fontSize: 16,
                  color: (selected == 2) ? greenPastel : Colors.black),
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AboutUs()));
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_mail),
            title: Text(
              'Kontakt',
              style: TextStyle(
                  fontSize: 16,
                  color: (selected == 3) ? greenPastel : Colors.black),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ContactPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.business),
            title: Text(
              'Prijava',
              style: TextStyle(
                  fontSize: 16,
                  color: (selected == 4) ? greenPastel : Colors.black),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InstitutionLoginPage()));
            },
          ),
        ],
      ),
    ));
  }
}