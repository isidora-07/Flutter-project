import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/constants.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/homePage.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/viewPost/viewPostPage.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/viewProfile/viewProfilePageIns.dart';
import 'package:frontend_web/ui/InstitutionPages/solvePage/solvePage.dart';
import 'package:frontend_web/widgets/circleImageWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

Color greenPastel = Color(0xFF00BFA6);

class InsRowPostMobileWidget extends StatefulWidget {
  final FullPost posts;
  final int indicator;

  InsRowPostMobileWidget(this.posts, this.indicator);

  @override
  _InsRowPostMobileWidgetState createState() => _InsRowPostMobileWidgetState(posts, indicator);
}

class _InsRowPostMobileWidgetState extends State<InsRowPostMobileWidget> {
  FullPost post;
  int _currentImageIndex = 0;
  int indicator;

  _InsRowPostMobileWidgetState(FullPost post1, int indicator1) {
    this.post = post1;
    this.indicator = indicator1;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (post == null) ? Center() : rowPost(); //buildPostList()
  }

  Widget rowPost(){
    return Card(
      child: Row(
        children: <Widget>[
          //imageGallery(),
          imageGalery3(post.photoPath, post.solvedPhotoPath),
          Expanded( child: packedThings()),
          solvedColor()
        ],
      ),
    );
  }

  Widget solvedColor() => Container(
    constraints: BoxConstraints(
      minHeight: 128,
      minWidth: 20,
    ),
    decoration: BoxDecoration(
      color: (post.statusId == 2) ? Colors.white : greenPastel
    ),
  );

  Widget packedThings() => Container(
    constraints: BoxConstraints(
      maxHeight: 128,
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
      InkWell(
        child: Text(
          (post.username.length > 14) ? post.username.substring(0,14).replaceRange(12,14, "...") : post.username,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: (){
          if(indicator == 1)
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ViewUserProfilePageIns(post.userId)),
            );
        },
      ),
      Expanded(child: SizedBox()),
      (post.statusId != 1)
      ? PopupMenuButton<String>(
        onSelected: (String choice) {
          choicePostIns(choice);
        },
        itemBuilder: (BuildContext context) {
          return ConstantsPostIns.choices.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      )
      : PopupMenuButton<String>(
        onSelected: (String choice) {
          choicePostIns(choice);
        },
        itemBuilder: (BuildContext context) {
          return ConstantsPostSolvedIns.choices.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      )
    ],
  );

  void choicePostIns(String choice) {
    if (choice == ConstantsPostIns.PogledajObjavu) {
      print("Pogledaj objavu.");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ViewPostInsPage(post)),
      );
    } else if (choice == ConstantsPostIns.Resi) {
      print("Resi.");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InstitutionSolvePage(postId: post.postId, id: insId)),
      );
    }
  }

  Widget imageGalery3(String image, String image2){
    List<String> imgList=[];
    imgList.add(userPhotoURL + image);
    image2 != "" && image2 != null ?  imgList.add(userPhotoURL + image2) : image2="";
    return SizedBox(
      height: 128.0,
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

  Widget actionsButtons() =>
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Actions buttons/icons
          Row(
            children: <Widget>[
              Expanded(child: IconButton(
                icon: Icon(MdiIcons.thumbUpOutline, color: greenPastel),
                onPressed: () {
                },
              ),),
              GestureDetector(
                onTap: () {},
                child:Text(post.likeNum.toString()),
              ),
              Expanded(child: IconButton(
                icon: Icon(MdiIcons.thumbDownOutline, color: Colors.red),
                onPressed: () {
                },
              ),),
              GestureDetector(
                onTap: () {},
                child: Text(post.dislikeNum.toString()),
              ),
              Expanded(child: IconButton(
                icon: Icon(Icons.chat_bubble_outline, color: greenPastel),
                onPressed: () {
                },
              ),),
              Expanded(child: Text(post.commNum.toString()),),
              //Expanded(child: SizedBox()),
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
          child: Text(post.address, style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
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