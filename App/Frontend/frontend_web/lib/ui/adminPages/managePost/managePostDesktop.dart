import 'dart:async';
import 'dart:convert';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/city.dart';
import 'package:frontend_web/models/fullPost.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/managePost/viewPost/viewPostPage.dart';
import 'package:frontend_web/widgets/InstitutionCommentWidget.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewRowPost.dart';
import 'package:frontend_web/widgets/circleImageWidget.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';
import 'package:frontend_web/extensions/hoverExtension.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';


class ManagePostDesktop extends StatefulWidget {
  @override
  _ManagePostDesktopState createState() => _ManagePostDesktopState();
}

class _ManagePostDesktopState extends State<ManagePostDesktop> {

  Color greenPastel = Color(0xFF00BFA6);

  List<FullPost> temp;
  List<FullPost> listPosts;
  List<FullPost> listPostsFilt;
  List<FullPost> listSolvedPosts;
  List<FullPost> listSolvedPostsFilt;
  List<FullPost> listUnsolvedPosts;
  List<FullPost> listUnsolvedPostsFilt;

  List<City> listCities;
  City city;
  City cityS;
  City cityU;
  List<CategoryDropDown> categories = CategoryDropDown.getCategoriesDropDown();
  CategoryDropDown catF;
  CategoryDropDown catFS;
  CategoryDropDown catFU;
  List<MaxMinDropDown> maxMinFilter = MaxMinDropDown.getMaxMinDropDown();
  MaxMinDropDown maxMinF;
  MaxMinDropDown maxMinFS;
  MaxMinDropDown maxMinFU;


  _getSolvedPosts() {
    APIServices.getSolvedPosts(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> listP = List<FullPost>();
      listP = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listSolvedPosts = listP;
        });
      }
    });
  }

  _getUnsolvedPosts() {
    APIServices.getUnsolvedPosts(TokenSession.getToken).then((res) {
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

  _getAllPosts() async {
    APIServices.getPost(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> listP = List<FullPost>();
      listP = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listPosts = listP;
        });
      }
    });
  }

  _getCities() {
    APIServices.getCity(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<City> listC = List<City>();
      listC = list.map((model) => City.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listCities = listC;
          City allusers = new City(9999, "Sve objave");
          city = allusers;
          listCities.sort((a,b) => a.name.toString().compareTo(b.name.toString()));
          listCities.insert(0, allusers);
        });
      }
    });
  }

  _getPostFromCity(int cityId) {
    APIServices.getPostsByCityId(TokenSession.getToken, cityId).then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> listFU = List<FullPost>();
      listFU = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listPostsFilt = listFU;
        });
        _sortListBy();
      }
    });
  }

  _getSolvedPostFromCity(int cityId) {
    APIServices.getPostsSolvedByCityId(TokenSession.getToken, cityId).then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> listFU = List<FullPost>();
      listFU = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listSolvedPostsFilt = listFU;
        });
        _sortSolvedListBy();
      }
    });
  }

  _getUnsolvedPostFromCity(int cityId) {
    APIServices.getPostsUnsolveddByCityId(TokenSession.getToken, cityId).then((res) {
      Iterable list = json.decode(res.body);
      List<FullPost> listFU = List<FullPost>();
      listFU = list.map((model) => FullPost.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listUnsolvedPostsFilt = listFU;
        });
        _sortUnsolvedListBy();
      }
    });
  }

  _sortListBy(){
    if(listPostsFilt == null){
      if(catF == null || catF.name == "Sve"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          listPosts.sort((x, y) => x.postId.compareTo(y.postId));
        else if(maxMinF.name == "Opadajući")
          listPosts.sort((x, y) => y.postId.compareTo(x.postId));
      } else if(catF.name == "Broj lajkova"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          listPosts.sort((x, y) => x.likeNum.compareTo(y.likeNum));
        else if(maxMinF.name == "Opadajući")
          listPosts.sort((x, y) => y.likeNum.compareTo(x.likeNum));
      } else if(catF.name == "Broj dislajkova"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          listPosts.sort((x, y) => x.dislikeNum.compareTo(y.dislikeNum));
        else if(maxMinF.name == "Opadajući")
          listPosts.sort((x, y) => y.dislikeNum.compareTo(x.dislikeNum));
      } else if(catF.name == "Broj komentara"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          listPosts.sort((x, y) => x.commNum.compareTo(y.commNum));
        else if(maxMinF.name == "Opadajući")
          listPosts.sort((x, y) => y.commNum.compareTo(x.commNum));
      }
    }
    else{
      if(catF == null || catF.name == "Sve"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          listPostsFilt.sort((x, y) => x.postId.compareTo(y.postId));
        else if(maxMinF.name == "Opadajući")
          listPostsFilt.sort((x, y) => y.postId.compareTo(x.postId));
      } else if(catF.name == "Broj lajkova"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          listPostsFilt.sort((x, y) => x.likeNum.compareTo(y.likeNum));
        else if(maxMinF.name == "Opadajući")
          listPostsFilt.sort((x, y) => y.likeNum.compareTo(x.likeNum));
      } else if(catF.name == "Broj dislajkova"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          listPostsFilt.sort((x, y) => x.dislikeNum.compareTo(y.dislikeNum));
        else if(maxMinF.name == "Opadajući")
          listPostsFilt.sort((x, y) => y.dislikeNum.compareTo(x.dislikeNum));
      } else if(catF.name == "Broj komentara"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          listPostsFilt.sort((x, y) => x.commNum.compareTo(y.commNum));
        else if(maxMinF.name == "Opadajući")
          listPostsFilt.sort((x, y) => y.commNum.compareTo(x.commNum));
      }
    }
  }

  _sortSolvedListBy(){
    if(listSolvedPostsFilt == null){
      if(catFS == null || catFS.name == "Sve"){
        if(maxMinFS == null || maxMinFS.name == "Rastući")
          listSolvedPosts.sort((x, y) => x.postId.compareTo(y.postId));
        else if(maxMinFS.name == "Opadajući")
          listSolvedPosts.sort((x, y) => y.postId.compareTo(x.postId));
      } else if(catFS.name == "Broj lajkova"){
        if(maxMinFS == null || maxMinFS.name == "Rastući")
          listSolvedPosts.sort((x, y) => x.likeNum.compareTo(y.likeNum));
        else if(maxMinFS.name == "Opadajući")
          listSolvedPosts.sort((x, y) => y.likeNum.compareTo(x.likeNum));
      } else if(catFS.name == "Broj dislajkova"){
        if(maxMinF == null || maxMinFS.name == "Rastući")
          listSolvedPosts.sort((x, y) => x.dislikeNum.compareTo(y.dislikeNum));
        else if(maxMinFS.name == "Opadajući")
          listSolvedPosts.sort((x, y) => y.dislikeNum.compareTo(x.dislikeNum));
      } else if(catFS.name == "Broj komentara"){
        if(maxMinF == null || maxMinFS.name == "Rastući")
          listSolvedPosts.sort((x, y) => x.commNum.compareTo(y.commNum));
        else if(maxMinFS.name == "Opadajući")
          listSolvedPosts.sort((x, y) => y.commNum.compareTo(x.commNum));
      }
    }
    else{
      if(catFS == null || catFS.name == "Sve"){
        if(maxMinFS == null || maxMinFS.name == "Rastući")
          listSolvedPostsFilt.sort((x, y) => x.postId.compareTo(y.postId));
        else if(maxMinFS.name == "Opadajući")
          listSolvedPostsFilt.sort((x, y) => y.postId.compareTo(x.postId));
      } else if(catFS.name == "Broj lajkova"){
        if(maxMinFS == null || maxMinFS.name == "Rastući")
          listSolvedPostsFilt.sort((x, y) => x.likeNum.compareTo(y.likeNum));
        else if(maxMinFS.name == "Opadajući")
          listSolvedPostsFilt.sort((x, y) => y.likeNum.compareTo(x.likeNum));
      } else if(catFS.name == "Broj dislajkova"){
        if(maxMinFS == null || maxMinFS.name == "Rastući")
          listSolvedPostsFilt.sort((x, y) => x.dislikeNum.compareTo(y.dislikeNum));
        else if(maxMinFS.name == "Opadajući")
          listSolvedPostsFilt.sort((x, y) => y.dislikeNum.compareTo(x.dislikeNum));
      } else if(catFS.name == "Broj komentara"){
        if(maxMinFS == null || maxMinFS.name == "Rastući")
          listSolvedPostsFilt.sort((x, y) => x.commNum.compareTo(y.commNum));
        else if(maxMinFS.name == "Opadajući")
          listSolvedPostsFilt.sort((x, y) => y.commNum.compareTo(x.commNum));
      }
    }
  }

  _sortUnsolvedListBy(){
    if(listUnsolvedPostsFilt == null){
      if(catFU == null || catFU.name == "Sve"){
        if(maxMinFU == null || maxMinFU.name == "Rastući")
          listUnsolvedPosts.sort((x, y) => x.postId.compareTo(y.postId));
        else if(maxMinFU.name == "Opadajući")
          listUnsolvedPosts.sort((x, y) => y.postId.compareTo(x.postId));
      } else if(catFU.name == "Broj lajkova"){
        if(maxMinFU == null || maxMinFU.name == "Rastući")
          listUnsolvedPosts.sort((x, y) => x.likeNum.compareTo(y.likeNum));
        else if(maxMinFU.name == "Opadajući")
          listUnsolvedPosts.sort((x, y) => y.likeNum.compareTo(x.likeNum));
      } else if(catFU.name == "Broj dislajkova"){
        if(maxMinFU == null || maxMinFU.name == "Rastući")
          listUnsolvedPosts.sort((x, y) => x.dislikeNum.compareTo(y.dislikeNum));
        else if(maxMinFU.name == "Opadajući")
          listUnsolvedPosts.sort((x, y) => y.dislikeNum.compareTo(x.dislikeNum));
      } else if(catFU.name == "Broj komentara"){
        if(maxMinFU == null || maxMinFU.name == "Rastući")
          listUnsolvedPosts.sort((x, y) => x.commNum.compareTo(y.commNum));
        else if(maxMinFU.name == "Opadajući")
          listUnsolvedPosts.sort((x, y) => y.commNum.compareTo(x.commNum));
      }
    }
    else{
      if(catFU == null || catFU.name == "Sve"){
        if(maxMinFU == null || maxMinFU.name == "Rastući")
          listUnsolvedPostsFilt.sort((x, y) => x.postId.compareTo(y.postId));
        else if(maxMinFU.name == "Opadajući")
          listUnsolvedPostsFilt.sort((x, y) => y.postId.compareTo(x.postId));
      } else if(catFU.name == "Broj lajkova"){
        if(maxMinFU == null || maxMinFU.name == "Rastući")
          listUnsolvedPostsFilt.sort((x, y) => x.likeNum.compareTo(y.likeNum));
        else if(maxMinFU.name == "Opadajući")
          listUnsolvedPostsFilt.sort((x, y) => y.likeNum.compareTo(x.likeNum));
      } else if(catFU.name == "Broj dislajkova"){
        if(maxMinFU == null || maxMinFU.name == "Rastući")
          listUnsolvedPostsFilt.sort((x, y) => x.dislikeNum.compareTo(y.dislikeNum));
        else if(maxMinFU.name == "Opadajući")
          listUnsolvedPostsFilt.sort((x, y) => y.dislikeNum.compareTo(x.dislikeNum));
      } else if(catFU.name == "Broj komentara"){
        if(maxMinFU == null || maxMinFU.name == "Rastući")
          listUnsolvedPostsFilt.sort((x, y) => x.commNum.compareTo(y.commNum));
        else if(maxMinFU.name == "Opadajući")
          listUnsolvedPostsFilt.sort((x, y) => y.commNum.compareTo(x.commNum));
      }
    }
  }

  deleteFromList(int postId) {
    for (int i = 0; i < listPosts.length; i++) {
      if (listPosts[i].postId == postId) {
        setState(() {
          listPosts.removeAt(i);
        });
        break;
      }
    }

    if(listPostsFilt != null){
      for (int i = 0; i < listPostsFilt.length; i++) {
        if (listPostsFilt[i].postId == postId) {
          setState(() {
            listPostsFilt.removeAt(i);
          });
          break;
        }
      }
    }

    for (int i = 0; i < listSolvedPosts.length; i++) {
      if (listSolvedPosts[i].postId == postId) {
        setState(() {
          listSolvedPosts.removeAt(i);
        });
        break;
      }
    }

    if(listSolvedPostsFilt != null){
      for (int i = 0; i < listSolvedPostsFilt.length; i++) {
        if (listSolvedPostsFilt[i].postId == postId) {
          setState(() {
            listSolvedPostsFilt.removeAt(i);
          });
          break;
        }
      }
    }

    for (int i = 0; i < listUnsolvedPosts.length; i++) {
      if (listUnsolvedPosts[i].postId == postId) {
        setState(() {
          listUnsolvedPosts.removeAt(i);
        });
        break;
      }
    }

    if(listUnsolvedPostsFilt != null){
      for (int i = 0; i < listUnsolvedPostsFilt.length; i++) {
        if (listUnsolvedPostsFilt[i].postId == postId) {
          setState(() {
            listUnsolvedPostsFilt.removeAt(i);
          });
          break;
        }
      }
    }
  }

  @override
  initState() {
    super.initState();
    _getAllPosts();
    _getSolvedPosts();
    _getUnsolvedPosts();
    _getCities();
  }

  @override
  Widget build(BuildContext context) {
    
    return Stack(children: <Widget>[
      CenteredViewRowPost(
          child: TabBarView(children: <Widget>[
            Column(children: <Widget>[
              dropdownFirstRow(listCities),
              Flexible(child: (listPostsFilt == null)
                ? buildPostList(listPosts)
                : buildPostList(listPostsFilt)
              )
            ],),
            Column(children: <Widget>[
              dropdownSecondRow(listCities),
              Flexible(child: (listSolvedPostsFilt == null)
                ? buildPostList(listSolvedPosts)
                : buildPostList(listSolvedPostsFilt)
              )
            ],),
            Column(children: <Widget>[
              dropdownThirdRow(listCities),
              Flexible(child: (listUnsolvedPostsFilt == null)
                ? buildPostList(listUnsolvedPosts)
                : buildPostList(listUnsolvedPostsFilt)
              )
            ],),
          ]
          ),
      ),
      CollapsingNavigationDrawer(),
      ]
    );
  }

  Widget buildPostList(List<FullPost> listPosts){
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 30.0),
      itemCount: listPosts == null ? 0 : listPosts.length,
      itemBuilder: (BuildContext context, int index) {
        return rowPost(listPosts[index]);
      }
    );
  }

  Widget dropdownFirstRow(List<City> listCities) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text("Grad: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        listCities != null
        ? new DropdownButton<City>(
            hint: Text("Izaberi"),
            value: city,
            onChanged: (City newValue) {
              if (newValue.name == "Sve objave") {
                listPostsFilt = null;
                _getAllPosts();
                
              } else {
                listPosts = null;
                listPostsFilt = null;
                _getPostFromCity(newValue.id);
                  
                //SORT()
              }
              setState(() {
                city = newValue;
              });
            },
            items: listCities.map((City option) {
              return DropdownMenuItem(
                child: new Text(option.name),
                value: option,
              );
            }).toList(),
          ).showCursorOnHover
        : new DropdownButton<String>(
            hint: Text("Izaberi"),
            onChanged: null,
            items: null,
          ).showCursorOnHover,
        new Text("Kategorija: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        DropdownButton<CategoryDropDown>(
          hint: Text("Izaberi"),
          value: catF,
          onChanged: (CategoryDropDown newValue) {
            setState(() {
              catF = newValue;
            });
            if (newValue.name == "Broj lajkova") {
              _sortListBy();
            } else if(newValue.name == "Broj dislajkova"){
              _sortListBy();
            } else if(newValue.name == "Broj komentara"){
              _sortListBy();
            } else if(newValue.name == "Sve"){
              _sortListBy();
            }
          },
          items: categories.map((CategoryDropDown option) {
            return DropdownMenuItem(
              child: new Text(option.name),
              value: option,
            );
          }).toList(),
        ).showCursorOnHover,
        new Text("Redosled: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        DropdownButton<MaxMinDropDown>(
          hint: Text("Izaberi"),
          value: maxMinF,
          onChanged: (MaxMinDropDown newValue) {
            setState(() {
              maxMinF = newValue;
            });
            if(newValue.name == "Rastući"){
              _sortListBy();
            } else if(newValue.name == "Opadajući"){
              _sortListBy();
            }
          },
          items: maxMinFilter.map((MaxMinDropDown option) {
            return DropdownMenuItem(
              child: new Text(option.name),
              value: option,
            );
          }).toList(),
        ).showCursorOnHover,
      ]);
  }
  
  Widget dropdownSecondRow(List<City> listCities) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text("Grad: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        listCities != null
        ? new DropdownButton<City>(
            hint: Text("Izaberi"),
            value: cityS,
            onChanged: (City newValue) {
              if (newValue.name == "Sve objave") {
                listSolvedPostsFilt = null;
                _getSolvedPosts();
              } else {
                listSolvedPosts = null;
                listSolvedPostsFilt = null;
                _getSolvedPostFromCity(newValue.id);
                  
                //SORT()
              }
              setState(() {
                cityS = newValue;
              });
            },
            items: listCities.map((City option) {
              return DropdownMenuItem(
                child: new Text(option.name),
                value: option,
              );
            }).toList(),
          ).showCursorOnHover
        : new DropdownButton<String>(
            hint: Text("Izaberi"),
            onChanged: null,
            items: null,
          ).showCursorOnHover,
        new Text("Kategorija: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        DropdownButton<CategoryDropDown>(
          hint: Text("Izaberi"),
          value: catFS,
          onChanged: (CategoryDropDown newValue) {
            setState(() {
              catFS = newValue;
            });
            if (newValue.name == "Broj lajkova") {
                _sortSolvedListBy();
            } else if(newValue.name == "Broj dislajkova"){
                _sortSolvedListBy();
            } else if(newValue.name == "Broj komentara"){
                _sortSolvedListBy();
            } else if(newValue.name == "Sve"){
                _sortSolvedListBy();
            }
          },
          items: categories.map((CategoryDropDown option) {
            return DropdownMenuItem(
              child: new Text(option.name),
              value: option,
            );
          }).toList(),
        ).showCursorOnHover,
        new Text("Redosled: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        DropdownButton<MaxMinDropDown>(
          hint: Text("Izaberi"),
          value: maxMinFS,
          onChanged: (MaxMinDropDown newValue) {
            setState(() {
              maxMinFS = newValue;
            });
            if(newValue.name == "Rastući"){
                _sortSolvedListBy();
            } else if(newValue.name == "Opadajući"){
                _sortSolvedListBy();
            }
          },
          items: maxMinFilter.map((MaxMinDropDown option) {
            return DropdownMenuItem(
              child: new Text(option.name),
              value: option,
            );
          }).toList(),
        ).showCursorOnHover,
      ]);
  }

  Widget dropdownThirdRow(List<City> listCities) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text("Grad: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        listCities != null
        ? new DropdownButton<City>(
            hint: Text("Izaberi"),
            value: cityU,
            onChanged: (City newValue) {
              if (newValue.name == "Sve objave") {
                listUnsolvedPostsFilt = null;
                _getUnsolvedPosts();
              } else {
                listUnsolvedPosts = null;
                listUnsolvedPostsFilt = null;
                _getUnsolvedPostFromCity(newValue.id);
                  
                //SORT()
              }
              setState(() {
                cityU = newValue;
              });
            },
            items: listCities.map((City option) {
              return DropdownMenuItem(
                child: new Text(option.name),
                value: option,
              );
            }).toList(),
          ).showCursorOnHover
        : new DropdownButton<String>(
            hint: Text("Izaberi"),
            onChanged: null,
            items: null,
          ).showCursorOnHover,
        new Text("Kategorija: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        DropdownButton<CategoryDropDown>(
          hint: Text("Izaberi"),
          value: catFU,
          onChanged: (CategoryDropDown newValue) {
            setState(() {
              catFU = newValue;
            });
            if (newValue.name == "Broj lajkova") {
              _sortUnsolvedListBy();
            } else if(newValue.name == "Broj dislajkova"){
              _sortUnsolvedListBy();
            } else if(newValue.name == "Broj komentara"){
              _sortUnsolvedListBy();
            } else if(newValue.name == "Sve"){
              _sortUnsolvedListBy();
            }
          },
          items: categories.map((CategoryDropDown option) {
            return DropdownMenuItem(
              child: new Text(option.name),
              value: option,
            );
          }).toList(),
        ).showCursorOnHover,
        new Text("Redosled: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        DropdownButton<MaxMinDropDown>(
          hint: Text("Izaberi"),
          value: maxMinFU,
          onChanged: (MaxMinDropDown newValue) {
            setState(() {
              maxMinFU = newValue;
            });
            if(newValue.name == "Rastući"){
              _sortUnsolvedListBy();
            } else if(newValue.name == "Opadajući"){
              _sortUnsolvedListBy();
            }
          },
          items: maxMinFilter.map((MaxMinDropDown option) {
            return DropdownMenuItem(
              child: new Text(option.name),
              value: option,
            );
          }).toList(),
        ).showCursorOnHover,
      ]);
  }

  Widget rowPost(FullPost post){
    return Card(
      child: Row(
        children: <Widget>[
          //imageGallery(),
          //Expanded( child: imageGallery2(post.photoPath, post.solvedPhotoPath)),
          imageGalery3(post.photoPath, post.solvedPhotoPath),
          Expanded( child: packedThings(post)),
          solvedColor(post.statusId),
        ],
      ),
    );
  }

  Widget solvedColor(int statusId) => Container(
    constraints: BoxConstraints(
      minHeight: 180,
      minWidth: 20,
    ),
    decoration: BoxDecoration(
      color: (statusId == 2) ? Colors.white : greenPastel
    ),
  );

  Widget packedThings(FullPost post) => Container(
    constraints: BoxConstraints(
      maxHeight: 180,
      minHeight: 100,
    ),
    child: Column(
      children: <Widget>[
        userInfoRow(post.userPhoto, post.userId, post.username, post.statusId, post.postId),
        category(post.typeName),
        Expanded(child: SizedBox()),
        description(post.description),
        Expanded(child: SizedBox()),
        location(post.address),
        actionsButtons(post.likeNum, post.dislikeNum, post.postId, post.commNum, post),
      ],
    ),
  );

  showAlertDialog(BuildContext context, int id) {
      // set up the button
    final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();
    void _doSomething() async {
      APIServices.deletePost(TokenSession.getToken,id);
      deleteFromList(id);
      Timer(Duration(seconds: 1), () {
          _btnController.success();
          Navigator.pop(context);
      });
    }

    Widget okButton = RoundedLoadingButton(
      color: Colors.red,
      width: 60,
      height: 40,
      child: Text("Obriši", style: TextStyle(color: Colors.white),),
    controller: _btnController,    
    onPressed: _doSomething,
    ).showCursorOnHover;

     Widget notButton = RoundedLoadingButton(
       color:greenPastel,
       width: 60,
       height: 40,
       child: Text("Otkaži", style: TextStyle(color: Colors.white),),
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
  
  Widget userInfoRow(String userPhoto, int userId, String username, int statusId, int postId) => Row(
    children: <Widget>[
      InkWell(
        child: CircleImage(
          userPhotoURL + userPhoto,
          imageSize: 36.0,
          whiteMargin: 2.0,
          imageMargin: 6.0,
        ),
        onTap: (){
        },
      ),
      InkWell(
        child: Text(
          username,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: (){
        },
      ),
      Expanded(child: SizedBox()),
      FlatButton(
        shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(11.0),
        side: BorderSide(color: Colors.redAccent)),
        color: Colors.redAccent,
        child: Text(
          "Obriši",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          showAlertDialog(context, postId);
        },
      ).showCursorOnHover,
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


  Widget actionsButtons(int likeNum, int dislikeNum, int postId, int commNum, FullPost post) => Row(
    children: <Widget>[
      IconButton(
        icon: Icon(MdiIcons.thumbUpOutline, color: greenPastel),
        onPressed: () {
        },
      ),
      GestureDetector(
        onTap: () {},
        child: Text(likeNum.toString()),
      ),
      IconButton(
        icon: Icon(MdiIcons.thumbDownOutline, color: Colors.red),
        onPressed: () {
        },
      ),
      GestureDetector(
        onTap: () {},
        child: Text(dislikeNum.toString()),
      ),
      IconButton(
        icon: Icon(Icons.chat_bubble_outline, color: greenPastel),
        onPressed: () {
          showCommentsDialog(context, postId);
        },
      ),
      Text(commNum.toString()),
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
  );

  Widget location(String address) => Container(
    child: Row(
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(address, style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
        )
      ],
    )
  );

  Widget category(String typeName) => Container(
    child: Row(
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(typeName, style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
        )
      ],
    )
  );

  Widget description(String description) => Container(
    child: Row(
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(description),
        )
      ],
    )
  );
}

class CategoryDropDown{
  int id;
  String name;

  CategoryDropDown(this.id, this.name);

  static List<CategoryDropDown> getCategoriesDropDown(){
    return <CategoryDropDown>[
      CategoryDropDown(1,"Sve"),
      CategoryDropDown(2,"Broj lajkova"),
      CategoryDropDown(3,"Broj dislajkova"),
      CategoryDropDown(4,"Broj komentara"),
    ];
  }
}

class MaxMinDropDown{
  int id;
  String name;

  MaxMinDropDown(this.id, this.name);

  static List<MaxMinDropDown> getMaxMinDropDown(){
    return <MaxMinDropDown>[
      MaxMinDropDown(1,"Rastući"),
      MaxMinDropDown(2,"Opadajući"),
    ];
  }
}