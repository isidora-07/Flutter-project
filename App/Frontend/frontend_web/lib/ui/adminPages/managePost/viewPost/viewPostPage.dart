import 'package:flutter/material.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/ui/adminPages/managePost/viewPost/viewPostDesktop.dart';
import 'package:frontend_web/ui/adminPages/managePost/viewPost/viewPostMobile.dart';
import 'package:frontend_web/widgets/mobileDrawer/drawerAdmin.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:frontend_web/extensions/hoverExtension.dart';

Color greenPastel = Color(0xFF00BFA6);

class ViewPostPage extends StatefulWidget {
  
  final FullPost post;
  ViewPostPage(this.post);

  @override
  _ViewPostPageState createState() => _ViewPostPageState(post);
}

class _ViewPostPageState extends State<ViewPostPage> {
  
  FullPost post;
  _ViewPostPageState(FullPost post1){
    this.post = post1;
  }

  @override
  Widget build(BuildContext context) {

    return ResponsiveBuilder(
      builder: (context, sizingInformation) => DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: sizingInformation.deviceScreenType == DeviceScreenType.Mobile 
            ? DrawerAdmin(3)
            : null,
          appBar: sizingInformation.deviceScreenType != DeviceScreenType.Mobile
            ? PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Container(
                  height: 100.0,
                  child: tabsDesktop(),
                ),
              )
            : AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              bottom: tabsMobile(),
            ),
          backgroundColor: Colors.white,
          body: ScreenTypeLayout(
            mobile: ViewPostMobile(post),
            tablet: ViewPostDesktop(post),
          ),
        ),
      )
    );
  }

  Widget tabsDesktop() {
    return TabBar(
      labelColor: greenPastel,
      indicatorColor: greenPastel,
      tabs: <Widget>[
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(MdiIcons.camera, color: Colors.black, size: 20),
              Text(' SVE O OBJAVI', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.chat_bubble_outline, color: Colors.black, size: 20),
              Text(' KOMENTARI', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.photo_album, color: Colors.black, size: 20),
              Text(' REŠENJA', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ]
    ).showCursorOnHover;
  }

  Widget tabsMobile() {
    return TabBar(
      labelColor: greenPastel,
      indicatorColor: greenPastel,
      tabs: <Widget>[
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('O OBJAVI', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('KOMENTARI', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('REŠENJA', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ]
    );
  }
}