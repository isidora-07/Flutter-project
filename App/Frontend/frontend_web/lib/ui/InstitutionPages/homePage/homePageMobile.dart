import 'dart:convert';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/editEventPage.dart';
import 'package:frontend_web/models/constants.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/models/institution.dart';
import 'package:frontend_web/models/postType.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/homePage.dart';
import 'package:frontend_web/ui/InstitutionPages/homePage/viewPost/viewPostPage.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewPost.dart';
import 'package:frontend_web/widgets/post/insRowPost/insRowPostMobile.dart';
import 'package:frontend_web/ui/InstitutionPages/solvePage/solvePage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../widgets/circleImageWidget.dart';
import '../solvePage/solvePage.dart';
import 'viewProfile/viewProfilePageIns.dart';
import 'package:frontend_web/extensions/hoverExtension.dart';


List<int> listSelectedTypes = new List();
int indikator = 0;



class HomeInstitutionMobile extends StatefulWidget {
  @override
  _HomeInstitutionMobileState createState() => _HomeInstitutionMobileState();
}

class _HomeInstitutionMobileState extends State<HomeInstitutionMobile> {
  List<FullPost> listUnsolvedPosts;
  Institution institution;
  List<FullPost> listFilteredPosts;
  List<PostType> listTypes;
  int _currentImageIndex = 0;


  _getUnsolvedPosts() async  {

    var res = await APIServices.getInstitutionById(TokenSession.getToken, insId);
    Map<String, dynamic> jsonInst = jsonDecode(res.body);
    Institution inst = Institution.fromObject(jsonInst);
    if(mounted) {
        setState(() {
        institution = inst;
        icityId = institution.cityId;
      });
    }

    res =  await APIServices.getInstitutionUnsolvedFromCityId(TokenSession.getToken, icityId).then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> listP = List<FullPost>();
      listP = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listUnsolvedPosts = listP;
        });
      }
    });
  }

  _getFilteredNew(int cid, int selectedType) async {

    List<int> newList = [];
    newList.add(selectedType);

    await APIServices.getFiltered(TokenSession.getToken, newList, cid).then((res) {
      print(res.body);
      Iterable list = json.decode(res.body);
      List<FullPost> posts =  List<FullPost>();
      posts = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listFilteredPosts = posts;
        });
      }
    });
  }


  _getPostType() async {
    var res =  await APIServices.getPostType(TokenSession.getToken);
    Iterable list = json.decode(res.body);
    List<PostType> postTypes = List<PostType>();
    postTypes = list.map((model) => PostType.fromObject(model)).toList();
    if (mounted) {
      setState(() {
        listTypes = postTypes;
        PostType alltypes = new PostType(9999, "Sve");
        listTypes.sort((a,b) => a.typeName.toString().compareTo(b.typeName.toString()));
        listTypes.insert(0, alltypes);
      });
    }
  }


  Widget rowPost(FullPost post, int ind){
    return Card(
      child: Row(
        children: <Widget>[
          //imageGallery(),
          imageGalery3(post.photoPath, post.solvedPhotoPath),
          Expanded( child: packedThings(post, ind)),
          solvedColor(post),
        ],
      ),
    );
  }



  Widget solvedColor(FullPost post) => Container(
    constraints: BoxConstraints(
      minHeight: 128,
      minWidth: 20,
    ),
    decoration: BoxDecoration(
        color: (post.statusId == 2) ? Colors.white : Color(0xFF00BFA6)
    ),
  );


  Widget packedThings(FullPost post, int ind) => Container(
    constraints: BoxConstraints(
      maxHeight: 128,
      minHeight: 100,
    ),
    child: Column(
      children: <Widget>[
        userInfoRow(post, ind),
        Expanded(child: SizedBox()),
        description(post),
        Expanded(child: SizedBox()),
        actionsButtons(post),
      ],
    ),
  );

  Widget userInfoRow(FullPost post, int ind) => Row(
    children: <Widget>[
      SizedBox(width: 10,),
      InkWell(
        child: Text(
          (post.username.length > 14) ? post.username.substring(0,14).replaceRange(12,14, "...") : post.username,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: (){
          if(ind == 1)
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
          choicePostIns(choice, post);
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
          choicePostIns(choice, post);
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

  Widget imageGallery(FullPost post) => Container(
    constraints: BoxConstraints(
      maxHeight: 180.0, // changed to 400
      minHeight: 100.0, // changed to 200
      maxWidth: 250,
      minWidth: 250,
    ),
    child: Image(image: NetworkImage(userPhotoURL + post.photoPath)),
  );


  Widget location(FullPost post) => Container(
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



  Widget category(FullPost post) => Container(
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
        dotIncreasedColor: Color(0xFF00BFA6),
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

  Widget actionsButtons(FullPost post) =>
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Actions buttons/icons
          Row(
            children: <Widget>[
              Expanded(child: IconButton(
                icon: Icon(MdiIcons.thumbUpOutline, color: Color(0xFF00BFA6)),
                onPressed: () {
                },
              ),),
              GestureDetector(
                onTap: () {},
                child:  Text(post.likeNum.toString()),
              ),
              Expanded(child: IconButton(
                icon: Icon(MdiIcons.thumbDownOutline, color: Colors.red),
                onPressed: () {
                },
              ),),
              GestureDetector(
                onTap: () {},
                child:  Text(post.dislikeNum.toString()),
              ),
              Expanded(child: IconButton(
                icon: Icon(Icons.chat_bubble_outline, color: Color(0xFF00BFA6)),
                onPressed: () {
                  //showCommentsDialog(context, post.postId);
                },
              ),),
              Expanded(child: Text(post.commNum.toString()),),
              //Expanded(child: SizedBox()),
              SizedBox(width: 10.0), // For padding
            ],
          ),
        ],
      );



  Widget description(FullPost post){
    if(post.description.length >= 25){
      post.description = post.description.substring(0,25);
      post.description = post.description.replaceRange(23, 25, "...");
    }

    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(width: 10,),
          Flexible(
            child: Text(post.description),
          )
        ],
      )
    );

    
  } 

   PostType ptSelect;

  void choicePostIns(String choice, FullPost post) {
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

  Widget dropdownFU(List<PostType> types) {
    return new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text("Vrsta problema: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          types != null
          ? new DropdownButton<PostType>(
              hint: Text("Izaberi"),
              value: ptSelect,
              onChanged: (PostType newValue) {
                if (newValue.typeName == "Sve") {
                  listFilteredPosts = null;
                } else {
                  _getFilteredNew(icityId, newValue.id);
                }
                setState(() {
                  ptSelect = newValue;
                });
              },
              items: types.map((PostType option) {
                return DropdownMenuItem(
                  child: new Text(option.typeName),
                  value: option,
                );
              }).toList(),
            ).showCursorOnHover
          : new DropdownButton<String>(
              hint: Text("Izaberi"),
              onChanged: null,
              items: null,
            ).showCursorOnHover,
        ]);
  }

  @override
  void initState() {
    super.initState();
    _getUnsolvedPosts();
    _getPostType();
  }

  @override
  Widget build(BuildContext context) {
    return CenteredViewPost(
        child:  Column(children: [
          dropdownFU(listTypes),
          Flexible(child: listFilteredPosts == null ?
            ListView.builder(
                padding: EdgeInsets.only(bottom: 30.0),
                itemCount: listUnsolvedPosts == null ? 0 : listUnsolvedPosts.length,
                itemBuilder: (BuildContext context, int index) {
                  return rowPost(listUnsolvedPosts[index], 0);
                }
            )
                : ListView.builder(
                padding: EdgeInsets.only(bottom: 30.0),
                itemCount: listFilteredPosts.length,
                itemBuilder: (BuildContext context, int index) {
                  return rowPost(listFilteredPosts[index], 0);
                }
            ),
          ),
        ],));
  }
}