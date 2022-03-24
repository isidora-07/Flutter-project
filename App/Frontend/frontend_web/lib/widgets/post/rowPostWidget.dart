import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/constants.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/managePost/viewPost/viewPostPage.dart';
import 'package:frontend_web/widgets/circleImageWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:frontend_web/extensions/hoverExtension.dart';

Color greenPastel = Color(0xFF00BFA6);

class RowPostWidget extends StatefulWidget {
  final FullPost posts;
  RowPostWidget(this.posts);

  @override
  _RowPostWidgetState createState() => _RowPostWidgetState(posts);
}

class _RowPostWidgetState extends State<RowPostWidget> {
  FullPost post;

  _RowPostWidgetState(FullPost post1) {
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
    ).showCursorOnHover;
     Widget notButton = FlatButton(
      child: Text("Otkaži", style: TextStyle(color: greenPastel),),
      onPressed: () {
        Navigator.pop(context);
        },
    ).showCursorOnHover;

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
      maxHeight: 180,
      minWidth: 20,
    ),
    decoration: BoxDecoration(
      color: (post.statusId == 2) ? Colors.white : greenPastel
    ),
  );

  Widget packedThings() => Container(
    constraints: BoxConstraints(
      maxHeight: 180,
      minHeight: 100,
    ),
    child: Column(
      children: <Widget>[
        userInfoRow(),
        category(),
        Expanded(child: SizedBox()),
        description(),
        Expanded(child: SizedBox()),
        location(),
        actionsButtons(),
      ],
    ),
  );

  Widget userInfoRow() => Row(
    children: <Widget>[
      CircleImage(
        userPhotoURL + post.userPhoto,
        imageSize: 36.0,
        whiteMargin: 2.0,
        imageMargin: 6.0,
      ),
      Text(
        post.username,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Expanded(child: SizedBox()),
      FlatButton(
        shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(11.0),
        side: BorderSide(color: Colors.redAccent)),
        color: Colors.redAccent,
        child: Text(
          "Obriši objavu",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          showAlertDialog(context, post.postId);
        },
      ).showCursorOnHover,
      SizedBox(width: 10,),
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
      height: 180.0,
      width: 200.0,
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

  Widget actionsButtons() =>
      Stack(
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
              Expanded(child: SizedBox()),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(11.0),
                    side: BorderSide(color: greenPastel)),
                color: greenPastel,
                child: Text(
                  "Više informacija",
                  style: TextStyle(color: Colors.white),
                ).showCursorOnHover,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewPostPage(post)),
                  );
                },
              ),
              SizedBox(width: 10.0), // For padding
            ],
          ),
        ],
      );

  Widget location() => Container(
    child: Row(
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(post.address, style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
        )
      ],
    )
  );

  Widget category() => Container(
    child: Row(
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(post.typeName, style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
        )
      ],
    )
  );

  Widget description() => Container(
    child: Row(
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(post.description),
        )
      ],
    )
  );
}
