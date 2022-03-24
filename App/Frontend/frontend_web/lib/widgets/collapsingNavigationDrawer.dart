import 'package:flutter/material.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/manageDonation/manageDonationPage.dart';
import 'package:frontend_web/ui/adminPages/manageEvents/manageEventsPage.dart';
import 'package:frontend_web/ui/adminPages/manageInstitution/manageInstitutionPage.dart';
import 'package:frontend_web/ui/adminPages/managePost/managePostPage.dart';
import 'package:frontend_web/ui/adminPages/manageUser/manageUserPage.dart';
import 'package:frontend_web/ui/adminPages/menageAdmin/manageAdminPage.dart';
import 'package:frontend_web/ui/adminPages/registerAdminPage/registerAdminPage.dart';
import 'package:frontend_web/ui/adminPages/statisticsPage/statisticsPage.dart';
import 'package:frontend_web/ui/home/homeView.dart';
import 'package:frontend_web/widgets/CollapsingListTile.dart';
import 'package:frontend_web/extensions/hoverExtension.dart';
import '../ui/homePage.dart';


class CollapsingNavigationDrawer extends StatefulWidget {
  @override
  CollapsingNavigationDrawerState createState() {
    return new CollapsingNavigationDrawerState();
  }
}

class CollapsingNavigationDrawerState extends State<CollapsingNavigationDrawer>
    with SingleTickerProviderStateMixin {
  double maxWidth = 210;
  double minWidth = 70;
  static bool isCollapsed = true;
  AnimationController _animationController;
  Animation<double> widthAnimation;
  static int currentSelectedIndex = 2;

  _removeToken() async {
    TokenSession.setToken = "";
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this, duration: Duration(milliseconds: 300));
    widthAnimation = Tween<double>(begin: maxWidth, end: minWidth).animate(_animationController);
    setState(() {
      isCollapsed ? _animationController.forward() : _animationController.reverse();
    });
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
                  CollapsingListTile(title: 'Administrator', 
                  icon: Icons.perm_identity, 
                  animationController: _animationController,
                  onTap: () {
                    setState(() {
                          currentSelectedIndex = 1;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ManageAdminPage(globalAdminId)),
                        );
                      },           
                      isSelected: currentSelectedIndex == 1,
                  ),
                  CollapsingListTile(
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
                          MaterialPageRoute(builder: (context) => StatisticsPage()),
                        );
                      },
                      isSelected: currentSelectedIndex == 2,
                      ),
                  CollapsingListTile(
                    title: 'Upravljanje objavama',
                    icon: Icons.rate_review,
                    animationController: _animationController,
                    onTap: () {
                      setState(() {
                          currentSelectedIndex = 3;
                        });
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ManagePostPage())//PostPage(globalUser)),
                      );
                    },
                    isSelected: currentSelectedIndex == 3,
                    ),
                  CollapsingListTile(
                    title: 'Upravljanje korisnicima',
                    icon: Icons.supervised_user_circle,
                    animationController: _animationController,
                    onTap: () => {
                      setState(() {
                          currentSelectedIndex = 4;
                        }),
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ManageUserPage()),
                      ),
                    },
                    isSelected: currentSelectedIndex == 4,
                  ),
                  CollapsingListTile(
                    title: 'Upravljanje institucijama',
                    icon: Icons.business,
                    animationController: _animationController,
                    onTap: () => {
                      setState(() {
                          currentSelectedIndex = 5;
                        }),
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ManageInstitutionPage()),
                      ),
                    },
                    isSelected: currentSelectedIndex == 5,
                  ),
                  CollapsingListTile(
                    title: 'Upravljanje događajima',
                    icon: Icons.event,
                    animationController: _animationController,
                    onTap: () => {
                      setState(() {
                          currentSelectedIndex = 6;
                        }),
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ManageEventsPage()),
                      ),
                    },
                    isSelected: currentSelectedIndex == 6,
                  ),
                  CollapsingListTile(
                    title: 'Upravljanje donacijama',
                    icon: Icons.monetization_on,
                    animationController: _animationController,
                    onTap: () => {
                      setState(() {
                          currentSelectedIndex = 7;
                        }),
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ManageDonationPage()),
                      ),
                    },
                    isSelected: currentSelectedIndex == 7,
                  ),
                  CollapsingListTile(
                    title: 'Dodavanje administratora',
                    icon: Icons.person_add,
                    animationController: _animationController,
                    onTap: () => {
                      setState(() {
                          currentSelectedIndex = 8;
                        }),
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterAdminPage()),
                      ),
                    },
                    isSelected: currentSelectedIndex == 8,
                  ),
                  CollapsingListTile(
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