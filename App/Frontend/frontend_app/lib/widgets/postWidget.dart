import 'dart:io';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/constantsDeleteEdit.dart';
import 'package:frontend/models/likeViewModel.dart';
import 'package:frontend/models/reportType.dart';
import 'package:frontend/services/api.services.dart';
import 'package:frontend/models/fullPost.dart';
import 'package:frontend/ui/challengeSolvingPage.dart';
import 'package:frontend/ui/commentsPage.dart';
import 'package:frontend/ui/homePage.dart';
import 'package:frontend/ui/likesPage.dart';
import 'package:frontend/ui/mapPage.dart';
import 'package:frontend/ui/othersProfilePage.dart';
import 'package:frontend/ui/splash.page.dart';
import 'package:frontend/widgets/circleImageWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:frontend/models/constants.dart';
import 'dart:convert';
import '../main.dart';
import '../services/api.services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostWidget extends StatefulWidget {
  final FullPost post;

  PostWidget(this.post);

  @override
  _PostWidgetState createState() => _PostWidgetState(post);
}

class _PostWidgetState extends State<PostWidget> {
  FullPost post;
  List<ReportType> reportTypes;
  TextEditingController opisController = new TextEditingController();
  ReportType _selectedId;
  List<DropdownMenuItem<ReportType>> _dropdownMenuItems;
  int _currentImageIndex = 0;
  _PostWidgetState(FullPost post1) {
    this.post = post1;
  }

  void _updateImageIndex(int index) {
    if (mounted) {
      setState(() => _currentImageIndex = index);
    }
  }

  getReportTypes() async {
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getReportType(jwt).then((res) {
      Iterable list = json.decode(res.body);
      List<ReportType> listRepTypes = List<ReportType>();
      listRepTypes = list.map((model) => ReportType.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          reportTypes = listRepTypes;
          _dropdownMenuItems = buildDropDownMenuItems(reportTypes);
          _selectedId = _dropdownMenuItems[0].value;
        });
      }
    });
  }

  _getPostById() async {
    var jwt = await APIServices.jwtOrEmpty();
    APIServices.getPostById(jwt, post.postId, userId).then((res) {
      Map<String, dynamic> list = json.decode(res.body);
      FullPost post1 = FullPost.nothing();
      post1 = FullPost.fromObject(list);
      if (mounted) {
        setState(() {
          post = post1;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.getReportTypes();
  }

  List<DropdownMenuItem<ReportType>> buildDropDownMenuItems(List reports) {
    List<DropdownMenuItem<ReportType>> newReports = List();
    for (ReportType item in reports) {
      newReports.add(DropdownMenuItem(
        value: item,
        child: Text(item.typeName),
      ));
    }

    return newReports;
  }

  @override
  Widget build(BuildContext context) {
    return (post == null) ? Center() : newPost(); //buildPostList()
  }

  Widget newPost() {
    return Card(
        child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
          userInfoRow(post.userId, post.username, post.typeName, post.userPhoto,
              post.statusId),
          imageGalery3(post.photoPath, post.solvedPhotoPath),
          SizedBox(height: 2.0),
          Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(post.address)
                ],
              )),
          actionsButtons(post.statusId, post.postId, post.likeNum,
              post.dislikeNum, post.commNum, post.isLiked),
          description(post.userId, post.username, post.description),
          SizedBox(height: 10.0),
        ]));
  }

  Widget userInfoRow(int otherUserId, String username, String category,
          String userPhoto, int statusId) =>
      Row(
        children: <Widget>[
          InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OthersProfilePage(otherUserId)),
                );
              },
              child: CircleImage(
                serverURLPhoto + userPhoto,
                imageSize: 36.0,
                whiteMargin: 2.0,
                imageMargin: 6.0,
              )),
          InkWell(
              onTap: () {
                if (userId != otherUserId)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OthersProfilePage(otherUserId)),
                  );
              },
              child: Text(
                username,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          Expanded(child: SizedBox()),
          Text(category),
          (statusId == 2)
              ? IconButton(
                  icon: Icon(Icons.location_on),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapPage(
                              postLatitude: post.latitude,
                              postLongitude: post.longitude)),
                    );
                  },
                )
              : Center(),
          /*IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {

            },
          ),*/
          (otherUserId != userId)
              ? PopupMenuButton<String>(
                  onSelected: (String choice) {
                    choiceAction(choice, otherUserId);
                  },
                  itemBuilder: (BuildContext context) {
                    return Constants.choices.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                )
              : PopupMenuButton<String>(
                  onSelected: choiceActionDeleteEdit,
                  itemBuilder: (BuildContext context) {
                    return ConstantsDeleteEdit.choices.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
        ],
      );

  //Choice for Report and other things
  void choiceAction(String choice, int _otherUserId) {
    if (choice == Constants.PrijaviKorisnika) {
      showDialog(
          context: context,
          child: new MyDialog(
            onValueChange: _onValueChange,
            initialValue: _selectedId,
            reportTypes: _dropdownMenuItems,
            otherUserId: _otherUserId,
          ));
    }
  }

  void _onValueChange(ReportType value) {
    if (mounted) {
      setState(() {
        _selectedId = value;
      });
    }
  }

  //Choice for Delete and Edit
  void choiceActionDeleteEdit(String choice) {
    if (choice == ConstantsDeleteEdit.IzbrisiObjavu) {
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text(
              "Brisanje objave?",
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Izbriši",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color),
                ),
                onPressed: () {
                  APIServices.jwtOrEmpty().then((res) {
                    String jwt;
                    if (mounted) {
                      setState(() {
                        jwt = res;
                      });
                    }
                    if (res != null) {
                      APIServices.deletePost(jwt, post.postId);
                      if (mounted) {
                        setState(() {
                          post = null;
                          publicUser.postsNum = publicUser.postsNum - 1;
                        });
                      }
                    }
                  });
                  print('Uspešno ste izbrisali objavu.');
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  "Otkaži",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
    } else if (choice == ConstantsDeleteEdit.IzmeniObjavu) {
      opisController.text = post.description;
      showDialog(
          context: context,
          child: AlertDialog(
            title: Text(
              "Izmeni opis.",
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
            ),
            content: Container(
              height: 50.0,
              child: Column(
                children: <Widget>[
                  TextField(
                    cursorColor: MyApp.ind == 0 ? Colors.black : Colors.white,
                    controller: opisController,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "Sačuvaj",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color),
                ),
                onPressed: () {
                  APIServices.jwtOrEmpty().then((res) {
                    String jwt;
                    if (mounted) {
                      setState(() {
                        jwt = res;
                      });
                    }
                    if (res != null) {
                      APIServices.editPost(
                          jwt, post.postId, opisController.text);
                      if (mounted) {
                        setState(() {
                          post.description = opisController.text;
                        });
                      }
                    }
                  });
                  print('Uspešno ste izmenili opis.');
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(
                  "Otkaži",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
    }
  }

  _getSolvedStatus() async {
    print("");
    int result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ChallengeSolvingPage(post.postId, post.userId, post.statusId)),
    );
    print("Status id ${post.statusId} a result je $result");
    _getPostById();
    if (mounted) {
      setState(() {
        if (result != null && result == 1) post.statusId = 1;
      });
    }
  }

  Widget imageGallery(String image, String image2) {
    List<String> imgList = [];
    imgList.add(serverURLPhoto + image);
    image2 != "" && image2 != null
        ? imgList.add(serverURLPhoto + image2)
        : image2 = "";
    return Column(
      children: <Widget>[
        GestureDetector(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              CarouselSlider(
                options: CarouselOptions(
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    _updateImageIndex(index);
                  },
                  enableInfiniteScroll: false,
                ),
                items: imgList
                    .map((item) => Container(
                          constraints: BoxConstraints(
                            maxHeight: 350.0, // changed to 400
                            minHeight: 250.0, // changed to 200
                            maxWidth: double.infinity,
                            minWidth: double.infinity,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Colors.grey[200],
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Center(
                              child: Image.network(
                            item,
                            fit: BoxFit.fitWidth,
                            width: MediaQuery.of(context).size.width,
                          )),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            (imgList.length > 1)
                ? Container(
                    height: 30,
                    child: PhotoCarouselIndicator(
                      photoCount: imgList.length,
                      activePhotoIndex: _currentImageIndex,
                    ))
                : Container(
                    width: 1,
                    height: 1,
                  ),
          ],
        )
      ],
    );
  }

  Widget imageGalery3(String image, String image2) {
    List<String> imgList = [];
    imgList.add(serverURLPhoto + image);
    image2 != "" && image2 != null
        ? imgList.add(serverURLPhoto + image2)
        : image2 = "";
    return SizedBox(
      height: 300.0,
      width: double.infinity,
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
          images: image2 != "" && image2 != null
              ? [NetworkImage(imgList[0]), NetworkImage(imgList[1])]
              : [NetworkImage(imgList[0])]),
    );
  }

  Widget actionsButtons(int statusId, int postId, int likeNum, int dislikeNum,
          int commNum, int isLiked) =>
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Actions buttons/icons
          Row(
            children: <Widget>[
              IconButton(
                icon: isLiked == 1
                    ? Icon(MdiIcons.thumbUpOutline, color: Color(0xFF00BFA6))
                    : Icon(MdiIcons.thumbUpOutline, color: Colors.grey),
                onPressed: () {
                  APIServices.jwtOrEmpty().then((res) {
                    String jwt;
                    if (mounted) {
                      setState(() {
                        jwt = res;
                      });
                    }
                    if (res != null) {
                      APIServices.addLike(jwt, postId, userId, 2).then((res) {
                        Map<String, dynamic> list = json.decode(res);
                        LikeViewModel likeVM = LikeViewModel();
                        likeVM = LikeViewModel.fromObject(list);
                        if (mounted) {
                          setState(() {
                            post.likeNum = likeVM.likeNum;
                            post.dislikeNum = likeVM.dislikeNum;
                            post.commNum = likeVM.commNum;
                            post.isLiked = likeVM.isLiked;
                          });
                        }
                      });
                    }
                  });
                },
              ),
              GestureDetector(
                onTap: () {
                  _getLikesFromPage(postId);
                },
                child: Text(likeNum.toString(), style: TextStyle(fontSize: 15)),
              ),
              IconButton(
                icon: isLiked == 2
                    ? Icon(MdiIcons.thumbDownOutline, color: Colors.red)
                    : Icon(MdiIcons.thumbDownOutline, color: Colors.grey),
                onPressed: () {
                  APIServices.jwtOrEmpty().then((res) {
                    String jwt;
                    if (mounted) {
                      setState(() {
                        jwt = res;
                      });
                    }
                    if (res != null) {
                      APIServices.addLike(jwt, postId, userId, 1).then((res) {
                        Map<String, dynamic> list = json.decode(res);
                        LikeViewModel likeVM = LikeViewModel();
                        likeVM = LikeViewModel.fromObject(list);
                        if (mounted) {
                          setState(() {
                            post.likeNum = likeVM.likeNum;
                            post.dislikeNum = likeVM.dislikeNum;
                            post.commNum = likeVM.commNum;
                            post.isLiked = likeVM.isLiked;
                          });
                        }
                      });
                    }
                  });
                },
              ),
              GestureDetector(
                onTap: () {
                  _getLikesFromPage(postId);
                },
                child:
                    Text(dislikeNum.toString(), style: TextStyle(fontSize: 15)),
              ),
              IconButton(
                icon: Icon(Icons.chat_bubble_outline, color: Color(0xFF00BFA6)),
                onPressed: () {
                  _getCommentsFromPage(postId);
                },
              ),
              Text(commNum.toString(), style: TextStyle(fontSize: 15)),
              Expanded(child: SizedBox()),
              post.postTypeId == 1
                  ? SizedBox()
                  : statusId == 2 && post.postTypeId != 1
                      ? Container(
                          width: 95,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Color(0xFF00BFA6),
                            borderRadius: BorderRadius.circular(11.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(11.0),
                                side: BorderSide(color: Color(0xFF00BFA6))),
                            color: Color(0xFF00BFA6),
                            child: Text(
                              "Reši",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              _getSolvedStatus();
                            },
                          ))
                      : Container(
                          decoration: BoxDecoration(
                            color:
                                MyApp.ind == 0 ? Colors.white : Colors.black26,
                            border: Border.all(
                                width: 0.3, color: Color(0xFF00BFA6)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon:
                                Icon(Icons.done_all, color: Color(0xFF00BFA6)),
                            onPressed: () {
                              _getSolvedStatus();
                            },
                          ),
                        ),
              SizedBox(width: 10.0), // For padding
            ],
          ),
        ],
      );

  _getCommentsFromPage(int postId) async {
    int result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CommentsPage(postId)),
    );
    if (mounted) {
      setState(() {
        if (result != null) post.commNum = result;
      });
    }
    _getPostById();
  }

  _getLikesFromPage(int postId) async {
    int result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LikesPage(postId)),
    );
    if (mounted) {
      setState(() {
        if (result != null) post.likeNum = result;
      });
    }
  }

  Widget description(
    int otherUserId,
    String username,
    String description,
  ) =>
      Container(
          child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(description),
          )
        ],
      ));
}

class MyDialog extends StatefulWidget {
  const MyDialog(
      {this.onValueChange,
      this.initialValue,
      this.reportTypes,
      this.otherUserId});

  final ReportType initialValue;
  final int otherUserId;
  final void Function(ReportType) onValueChange;
  final List<DropdownMenuItem<ReportType>> reportTypes;

  @override
  State createState() => new MyDialogState();
}

class MyDialogState extends State<MyDialog> {
  ReportType _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialValue;
  }

  Widget build(BuildContext context) {
    TextEditingController messageController = new TextEditingController();
    return new AlertDialog(
      title: Text(
        "Prijavljivanje korisnika",
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
      ),
      content: Container(
          height: 150,
          child: Column(children: <Widget>[
            new DropdownButton<ReportType>(
              isExpanded: true,
              value: _selectedId,
              onChanged: (ReportType value) {
                if (mounted) {
                  setState(() {
                    _selectedId = value;
                  });
                }
                widget.onValueChange(value);
              },
              items: widget.reportTypes,
            ),
            TextFormField(
              controller: messageController,
              autocorrect: false,
              decoration: InputDecoration(
                hoverColor: Colors.grey,
                hintText: 'Komentar',
                labelStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1.color,
                    fontStyle: FontStyle.italic),
                fillColor: Colors.black,
                contentPadding: const EdgeInsets.all(10.0),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00BFA6)),
                ),
              ),
            )
          ])),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Prijavi",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
          ),
          onPressed: () {
            APIServices.jwtOrEmpty().then((res) {
              String jwt;
              setState(() {
                jwt = res;
              });
              if (res != null) {
                APIServices.addReport(jwt, userId, widget.otherUserId,
                        _selectedId.id, messageController.text)
                    .then((res) {
                  if (res.statusCode == 200) {
                    print('Uspešno ste prijavili korisnika.');
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                        msg: "Uspešno ste prijavili korisnika.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                        timeInSecForIos: 2);
                  } else {
                    print('Već ste prijavili korisnika.');
                    Navigator.of(context).pop();
                    Fluttertoast.showToast(
                        msg: "Već ste prijavili korisnika.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                        timeInSecForIos: 2);
                  }
                });
              }
            });
          },
        ),
        FlatButton(
          child: Text(
            "Otkaži",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
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
