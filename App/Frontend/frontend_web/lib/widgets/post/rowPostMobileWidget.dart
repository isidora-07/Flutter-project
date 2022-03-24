import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/constants.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/managePost/viewPost/viewPostPage.dart';
import 'package:frontend_web/widgets/circleImageWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

Color greenPastel = Color(0xFF00BFA6);

class RowPostMobileWidget extends StatefulWidget {
  final FullPost posts;
  RowPostMobileWidget(this.posts);

  @override
  _RowPostMobileWidgetState createState() => _RowPostMobileWidgetState(posts);
}

class _RowPostMobileWidgetState extends State<RowPostMobileWidget> {
  FullPost post;

  _RowPostMobileWidgetState(FullPost post1) {
    this.post = post1;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (post == null) ? Center() : rowPost(); //buildPostList()
  }

  showAlertDialog(BuildContext context, int id) {
      // set up the button
    Widget okButton = FlatButton(
      child: Text("Obriši", style: TextStyle(color: greenPastel),),
      onPressed: () {
        APIServices.deletePost(TokenSession.getToken,id);
        setState(() {
          post = null;
        });
        Navigator.pop(context);
        /*Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ManagePostPage()),
        );*/
        },
    );
     Widget notButton = FlatButton(
      child: Text("Otkaži", style: TextStyle(color: greenPastel),),
      onPressed: () {
        Navigator.pop(context);
        },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Brisanje objave"),
      content: Text("Da li ste sigurni da želite da obrišete objavu?"),
      actions: [
        okButton,
        notButton,
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

  Widget rowPost(){
    return Card(
      child: Row(
        children: <Widget>[
          imageGalery3(post.photoPath, post.solvedPhotoPath),
          Expanded( child: packedThings()),
          solvedColor(),
        ],
      ),
    );
  }

  Widget solvedColor() => Container(
    constraints: BoxConstraints(
      maxHeight: 120,
      minWidth: 20,
    ),
    decoration: BoxDecoration(
      color: (post.statusId == 2) ? Colors.white : greenPastel
    ),
  );

  Widget packedThings() => Container(
    constraints: BoxConstraints(
      maxHeight: 120,
      minHeight: 100,
    ),
    child: Column(
      children: <Widget>[
        userInfoRow(),
        Expanded(child: SizedBox()),
        description(post.description),
        Expanded(child: SizedBox()),
        actionsButtons(),
      ],
    ),
  );

  Widget userInfoRow() => Row(
    children: <Widget>[
      SizedBox(width: 10,),
      Text(
        post.username,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Expanded(child: SizedBox()),
      PopupMenuButton<String>(
        onSelected: (String choice) {
          choicePostAdmin(choice);
        },
        itemBuilder: (BuildContext context) {
          return ConstantsPostAdmin.choices.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      ),
    ],
  );

  void choicePostAdmin(String choice) {
    if (choice == ConstantsPostAdmin.PogledajObjavu) {
      print("Pogledaj objavu.");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ViewPostPage(post)),
      );
    } else if (choice == ConstantsPostAdmin.PogledajResenja) {
      print("Pogledaj resenja.");
    } else if (choice == ConstantsPostAdmin.ObrisiObjavu){
      print("Obrisi resenja.");
      showAlertDialog(context,post.postId);
    }
  }

  Widget imageGalery3(String image, String image2){
    List<String> imgList=[];
    imgList.add(userPhotoURL + image);
    image2 != "" && image2 != null ?  imgList.add(userPhotoURL + image2) : image2="";
    return SizedBox(
      height: 120.0,
      width: 120.0,
      child: Carousel(
        boxFit: BoxFit.cover,
        autoplay: false,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 6.0,
        dotIncreasedColor: greenPastel,
        dotBgColor: Colors.transparent,
        dotPosition: DotPosition.bottomCenter,
        dotVerticalPadding: 10.0,
        showIndicator: image2 != "" && image2 != null ? true : false,
        indicatorBgPadding: 7.0,
        images: image2 != "" && image2 != null ? [
          NetworkImage(imgList[0]),
          NetworkImage(imgList[1])
        ]
        : [
          NetworkImage(imgList[0])
        ]
      ),
    );
  }

  Widget actionsButtons() =>Stack(
    alignment: Alignment.center,
    children: <Widget>[
      // Actions buttons/icons
      Row(
        children: <Widget>[
          IconButton(
            icon: Icon(MdiIcons.thumbUpOutline, color: greenPastel),
            onPressed: () {
            },
          ),
          GestureDetector(
            onTap: () {},
            child: Text(post.likeNum.toString()),
          ),
          IconButton(
            icon: Icon(MdiIcons.thumbDownOutline, color: Colors.red),
            onPressed: () {
            },
          ),
          GestureDetector(
            onTap: () {},
            child: Text(post.dislikeNum.toString()),
          ),
          IconButton(
            icon: Icon(Icons.chat_bubble_outline, color: greenPastel),
            onPressed: () {
            },
          ),
          Text(post.commNum.toString()),
          SizedBox(width: 10.0), // For padding
        ],
      ),
    ],
  );

  Widget description(String description){
    if(description.length >= 25){
      description = description.substring(0,25);
      description = description.replaceRange(23, 25, "...");
    }

    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(width: 10,),
          Flexible(
            child: Text(description),
          )
        ],
      )
    );
  } 
}
