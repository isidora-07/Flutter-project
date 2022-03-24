import 'package:flutter/material.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/InstitutionPages/editInstitutionPage/editInstitutionPage.dart';
import 'package:frontend_web/ui/InstitutionPages/eventsPage/eventsPage.dart';
import 'package:frontend_web/ui/InstitutionPages/profilePage/institutionProfilePage.dart';
import 'package:frontend_web/ui/home/homeView.dart';
import 'package:frontend_web/widgets/CollapsingInsListTile.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/homePage.dart';

import 'package:frontend_web/extensions/hoverExtension.dart';

class CollapsingInsNavigationDrawer extends StatefulWidget {
  @override
  CollapsingInsNavigationDrawerState createState() {
    return new CollapsingInsNavigationDrawerState();
  }
}

class CollapsingInsNavigationDrawerState extends State<CollapsingInsNavigationDrawer>
    with SingleTickerProviderStateMixin {
  double maxWidth = 210;
  double minWidth = 70;
  static bool isCollapsed = true;
  AnimationController _animationController;
  Animation<double> widthAnimation;
  static int currentSelectedIndex = 2;

  _removeToken() async {
    TokenSession.setToken = "";
    insId=null;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 300));
    widthAnimation = Tween<double>(begin: maxWidth, end: minWidth).animate(_animationController);
    isCollapsed ? _animationController.forward() : _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, widget) => getWidget(context, widget),
    );
  }

  Widget getWidget(context, widget) {
    return Material(
      child: Container(
        width: widthAnimation.value,
        color: Colors.grey[100],
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  CollapsingInsListTile(
                    title: 'Institucija',
                    icon: Icons.business,
                    animationController: _animationController,
                    onTap: () {
                      setState(() {
                        currentSelectedIndex = 1;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InstitutionProfilePage(insId)),
                      );
                    },
                    isSelected: currentSelectedIndex == 1,
                  ),
                  CollapsingInsListTile(
                    title: 'Početna strana',
                    icon: Icons.home,
                    animationController: _animationController,
                    onTap: () {
                      setState(() {
                        currentSelectedIndex = 2;
                      });
                      String jwt = TokenSession.getToken;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePageInstitution.fromBase64(jwt)),
                      );
                    },
                    isSelected: currentSelectedIndex == 2,
                  ),
                  CollapsingInsListTile(
                    title: 'Izmena podataka',
                    icon: Icons.edit,
                    animationController: _animationController,
                    onTap: () {
                      setState(() {
                        currentSelectedIndex = 3;
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditInstitutionPage(insId)),
                      );
                    },
                    isSelected: currentSelectedIndex == 3,
                  ),
                  CollapsingInsListTile(
                    title: 'Kreiranje događaja',
                    icon: Icons.calendar_today,
                    animationController: _animationController,
                    onTap: () => {
                      setState(() {
                        currentSelectedIndex = 4;
                      }),

                      Navigator.push(context, 
                        MaterialPageRoute(builder: (context) => EventsPage()),
                      )
                    },
                    isSelected: currentSelectedIndex == 4,
                  ),
                  CollapsingInsListTile(
                    title: 'Odjavite se',
                    icon: Icons.exit_to_app,
                    animationController: _animationController,
                    onTap: () => {
                      setState(() {
                        currentSelectedIndex = 2;
                      }),
                      _removeToken(),
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeView()),
                      )
                    },
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isCollapsed = !isCollapsed;
                  isCollapsed
                      ? _animationController.forward()
                      : _animationController.reverse();
                });
              },
              child: AnimatedIcon(
                icon: AnimatedIcons.arrow_menu,
                progress: _animationController,
                color: Colors.black54,
                size: 40.0,
              ),
            ),
          ],
        ),
      ),
    ).showCursorOnHover;
  }
}