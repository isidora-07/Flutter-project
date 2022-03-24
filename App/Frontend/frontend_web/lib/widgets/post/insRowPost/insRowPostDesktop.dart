import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/homePage.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/viewPost/viewPostPage.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/viewProfile/viewProfilePageIns.dart';
import 'package:frontend_web/ui/InstitutionPages/solvePage/solvePage.dart';
import 'package:frontend_web/widgets/circleImageWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:frontend_web/extensions/hoverExtension.dart';
import '../../InstitutionCommentWidget.dart';

Color greenPastel = Color(0xFF00BFA6);

class InsRowPostDesktopWidget extends StatefulWidget {
  final FullPost posts;
  final int indicator;

  InsRowPostDesktopWidget(this.posts, this.indicator);

  @override
  _InsRowPostDesktopWidgetState createState() => _InsRowPostDesktopWidgetState(posts, indicator);
}

class _InsRowPostDesktopWidgetState extends State<InsRowPostDesktopWidget> {
  FullPost post;
  int _currentImageIndex = 0;
  int indicator;

  _InsRowPostDesktopWidgetState(FullPost post1, int indicator1) {
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
          solvedColor(),
        ],
      ),
    );
  }

  Widget solvedColor() => Container(
    constraints: BoxConstraints(
      minHeight: 180,
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
      InkWell(
        child: CircleImage(
          userPhotoURL + post.userPhoto,
          imageSize: 36.0,
          whiteMargin: 2.0,
          imageMargin: 6.0,
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
      InkWell(
        child: Text(
          post.username,
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
      (post.statusId == 2)
        ? FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(11.0),
            side: BorderSide(color: greenPastel)),
        color: greenPastel,
        child: Text(
          "Reši",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InstitutionSolvePage(postId: post.postId, id: insId)),
          );
        },
      ).showCursorOnHover
        : SizedBox(),
      SizedBox(width: 10,),
    ],
  );

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


  showCommentsDialog(BuildContext context, int id) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Zatvori", style: TextStyle(color: greenPastel),),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      actions: [
        InstitutionCommentWidget(id),
        okButton,
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
                  showCommentsDialog(context, post.postId);
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
                    MaterialPageRoute(builder: (context) => ViewPostInsPage(post)),
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

class PhotoCarouselIndicator extends StatelessWidget {
  final int photoCount;
  final int activePhotoIndex;

  PhotoCarouselIndicator({
    @required this.photoCount,
    @required this.activePhotoIndex,
  });

  Widget _buildDot({bool isActive}) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 3.0, right: 3.0),
        child: Container(
          height: isActive ? 7.5 : 6.0,
          width: isActive ? 7.5 : 6.0,
          decoration: BoxDecoration(
            color: isActive ? Color(0xFF00BFA6) : Colors.grey,
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(photoCount, (i) => i)
          .map((i) => _buildDot(isActive: i == activePhotoIndex))
          .toList(),
    );
  }
}