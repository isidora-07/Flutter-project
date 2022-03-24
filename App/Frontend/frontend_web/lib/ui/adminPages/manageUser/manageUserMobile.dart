import 'dart:async';
import 'dart:convert';
import 'package:data_tables/data_tables.dart';
import 'package:flutter/material.dart';
import 'package:frontend_web/models/city.dart';
import 'package:frontend_web/models/constants.dart';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/manageUser/reportedUser/reportedUser.dart';
import 'package:frontend_web/ui/adminPages/manageUser/viewProfile/viewProfilePage.dart';
import 'package:frontend_web/widgets/centeredView/centeredViewManageUser.dart';
import 'package:frontend_web/widgets/circleImageWidget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

Color greenPastel = Color(0xFF00BFA6);

class ManageUserMobile extends StatefulWidget {
  @override
  _ManageUserMobileState createState() => _ManageUserMobileState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;
 
  Debouncer({this.milliseconds});
 
  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _ManageUserMobileState extends State<ManageUserMobile> with SingleTickerProviderStateMixin{

List<User> listUsers;
  List<User> listRepUsers;
  List<City> listCities;
  TextEditingController searchController = new TextEditingController();
  TextEditingController searchRepController = new TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  List<User> filteredUsers;
  List<User> filteredRepUsers;
  Animation<double> animation;
  AnimationController animationController;

  List<CategoryDropDown> categories = CategoryDropDown.getCategoriesDropDown();
  CategoryDropDown catF;
  List<MaxMinDropDown> maxMinFilter = MaxMinDropDown.getMaxMinDropDown();
  MaxMinDropDown maxMinF;
  List<NumRepDropDown> repNums = NumRepDropDown.getNumRepDropDown();
  NumRepDropDown repNumF;
  

  _getUsers() {
    APIServices.getUsers(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<User> listU = List<User>();
      listU = list.map((model) => User.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listUsers = listU;
        });
        _sortListBy();
      }
    });
  }

  _getReportedUsers() {
    APIServices.getReportedUsers(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<User> listU = List<User>();
      listU = list.map((model) => User.fromObject(model)).toList();
      if (mounted) {
        setState( () {
          listRepUsers = listU;
        });
        _sortRepListBy();
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
          City allusers = new City(9999, "Svi korisnici");
          listCities.sort((a,b) => a.name.toString().compareTo(b.name.toString()));
          listCities.insert(0, allusers);
        });
      }
    });
  }

  _getUsersFromCity(int cityId) {
    APIServices.getUsersFromCity(TokenSession.getToken, cityId).then((res) {
      Iterable list = json.decode(res.body);
      List<User> listFU = List<User>();
      listFU = list.map((model) => User.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          filteredUsers = listFU;
        });
        _sortListBy();
      }
    });
  }

 _getReportedUsersFromCity(int cityId) {
    APIServices.getReportedUsersFromCity(TokenSession.getToken, cityId).then((res) {
      Iterable list = json.decode(res.body);
      List<User> listFRU = List<User>();
      listFRU = list.map((model) => User.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          filteredRepUsers = listFRU;
        });
      }
    });
  }

  _sortListBy(){
    if(filteredUsers == null){
      if(catF == null || catF.name == "Id"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          listUsers.sort((x, y) => x.id.compareTo(y.id));
        else if(maxMinF.name == "Opadajući")
          listUsers.sort((x, y) => y.id.compareTo(x.id));
      } else if(catF.name == "Objave"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          listUsers.sort((x, y) => x.postsNum.compareTo(y.postsNum));
        else if(maxMinF.name == "Opadajući")
          listUsers.sort((x, y) => y.postsNum.compareTo(x.postsNum));
      } else if(catF.name == "Poeni"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          listUsers.sort((x, y) => x.donatedPoints.compareTo(y.donatedPoints));
        else if(maxMinF.name == "Opadajući")
          listUsers.sort((x, y) => y.donatedPoints.compareTo(x.donatedPoints));
      } else if(catF.name == "Nivoi"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          listUsers.sort((x, y) => x.level.compareTo(y.level));
        else if(maxMinF.name == "Opadajući")
          listUsers.sort((x, y) => y.level.compareTo(x.level));
      }
    }
    else{
      if(catF == null || catF.name == "Id"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          filteredUsers.sort((x, y) => x.id.compareTo(y.id));
        else if(maxMinF.name == "Opadajući")
          filteredUsers.sort((x, y) => y.id.compareTo(x.id));
      } else if(catF.name == "Objave"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          filteredUsers.sort((x, y) => x.postsNum.compareTo(y.postsNum));
        else if(maxMinF.name == "Opadajući")
          filteredUsers.sort((x, y) => y.postsNum.compareTo(x.postsNum));
      } else if(catF.name == "Poeni"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          filteredUsers.sort((x, y) => x.donatedPoints.compareTo(y.donatedPoints));
        else if(maxMinF.name == "Opadajući")
          filteredUsers.sort((x, y) => y.donatedPoints.compareTo(x.donatedPoints));
      } else if(catF.name == "Nivoi"){
        if(maxMinF == null || maxMinF.name == "Rastući")
          filteredUsers.sort((x, y) => x.level.compareTo(y.level));
        else if(maxMinF.name == "Opadajući")
          filteredUsers.sort((x, y) => y.level.compareTo(x.level));
      }
    }
  }

  _sortRepListBy(){
    if(filteredRepUsers == null){
      if(repNumF == null || repNumF.name == "Svi"){
        filteredRepUsers = listRepUsers;
      } else if(repNumF.name == "Više od 10"){
        filteredRepUsers = listRepUsers.where((x) => x.reportsNum >= 10).toList();
      } else if(repNumF.name == "Više od 20"){
        filteredRepUsers = listRepUsers.where((x) => x.reportsNum >= 20).toList();
      } else if(repNumF.name == "Više od 50"){
        filteredRepUsers = listRepUsers.where((x) => x.reportsNum >= 50).toList();
      }
    }
    else{
      if(repNumF == null || repNumF.name == "Svi"){
        filteredRepUsers = listRepUsers;
      } else if(repNumF.name == "Više od 10"){
        filteredRepUsers = listRepUsers.where((x) => x.reportsNum >= 10).toList();
      } else if(repNumF.name == "Više od 20"){
        filteredRepUsers = listRepUsers.where((x) => x.reportsNum >= 20).toList();
      } else if(repNumF.name == "Više od 50"){
        filteredRepUsers = listRepUsers.where((x) => x.reportsNum >= 50).toList();
      }
    }
  }

  @override
  initState() {
    super.initState();

    _getUsers(); 
    _getReportedUsers();
    _getCities();

    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 220, end: 80).animate(animationController);
    animationController.reverse();
  }

  @override
  void dispose() {
    searchController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return CenteredViewManageUser(
        child: TabBarView(children: <Widget>[
          Column(children: [
            dropdownFU(listCities),
            Flexible(child: filteredUsers==null ?  buildDataTable(listUsers) : buildDataTable(filteredUsers)),
          ]),
          Column(children: [
            dropdownFRU(listCities),                 
            searchRep(),
            Flexible(child: filteredRepUsers==null ? buildDataTableReported(listRepUsers) : buildDataTableReported(filteredRepUsers)),
          ]),
        ]
        ),
      );
  }

  deleteFromList(int userId){
    for(int i = 0; i < listUsers.length; i++){
      if(listUsers[i].id == userId){
        setState(() {
          listUsers.removeAt(i);
        });
        break;
      }
    }
    
    for(int i = 0; i < listRepUsers.length; i++){
      if(listRepUsers[i].id == userId){
        setState(() {
          listRepUsers.removeAt(i);
        });
        break;
      }
    }
  }

  showAlertDialog(BuildContext context, int id) {
    final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();
    
    void _doSomething() async {
      APIServices.deleteUser(TokenSession.getToken,id);
      deleteFromList(id);
      Timer(Duration(seconds: 1), () {
          _btnController.success();
          Navigator.pop(context);
      });
    }
    
    // set up the button
    Widget okButton = RoundedLoadingButton(
      child: Text("Obriši", style: TextStyle(color: Colors.white),),
      controller: _btnController,
      color: Colors.red,
      width: 60,
      height: 40,
      onPressed: _doSomething,
    );

    Widget notButton = RoundedLoadingButton(
       color:greenPastel,
       width: 60,
       height: 40,
       child: Text("Otkaži", style: TextStyle(color: Colors.white),),
      onPressed: () {
        Navigator.pop(context);
        },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Brisanje korisnika"),
      content: Text("Da li ste sigurni da želite da obrišete korisnika?"),
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

  Widget buildUserList(List<User> listUsers) {
    return ListView.builder(
      itemCount: listUsers == null ? 0 : listUsers.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left:10,right: 10),
                  child: Row(children: [
                    CircleImage(
                      userPhotoURL + listUsers[index].photo,
                      imageSize: 36.0,
                      whiteMargin: 2.0,
                      imageMargin: 6.0,
                    ),
                    Container(
                      width: 150,
                      padding: EdgeInsets.only(left:10,right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(listUsers[index].username,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          Text(
                              listUsers[index].firstName +
                                  " " +
                                  listUsers[index].lastName,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 12))
                        ],
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    PopupMenuButton<String>(
                      onSelected: (String choice) {
                        choiceActionAllUsers(choice, listUsers[index].id, listUsers[index]);
                      },
                      itemBuilder: (BuildContext context) {
                        return ConstantsAllUsers.choices.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ])),
            ],
          ),
        ));
      },
    );
  }

  void choiceActionAllUsers(String choice, int userId, User user) {
    if (choice == ConstantsAllUsers.PosetiProfil) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ViewUserProfilePage(user)),
      );
    } else if (choice == ConstantsAllUsers.ObrisiKorisnika) {
      showAlertDialog(context, userId);
    }
  }

  Widget buildReportedUserList(List<User> listRepUsers) {

    return ListView.builder(
      itemCount: listRepUsers == null ? 0 : listRepUsers.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(left:10.0,right: 10),
                      child: Row(children: [
                        CircleImage(
                          userPhotoURL + listRepUsers[index].photo,
                          imageSize: 36.0,
                          whiteMargin: 2.0,
                          imageMargin: 6.0,
                        ),
                        Container(
                          width: 120,
                          padding: EdgeInsets.only(left:10.0,right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(listRepUsers[index].username,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Text(
                                  listRepUsers[index].firstName +
                                      " " +
                                      listRepUsers[index].lastName,
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic, fontSize: 12))
                            ],
                          ),
                        ),
                        Column(
                            children: <Widget>[
                              Text(
                                listRepUsers[index].reportsNum.toString(),
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Broj prijava',
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          ),
                        Expanded(child: SizedBox()),
                        PopupMenuButton<String>(
                          onSelected: (String choice) {
                            choiceActionReportedUsers(choice, listRepUsers[index].id, listRepUsers[index].firstName, listRepUsers[index].lastName, listRepUsers[index]);
                          },
                          itemBuilder: (BuildContext context) {
                            return ConstantsReportedUsers.choices.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                        ),
                      ])),
                ],
              ),
            ));
      },
    );
  }

  void choiceActionReportedUsers(String choice, int userId, String firstname, String lastname, User user) {
    if (choice == ConstantsReportedUsers.DetaljiPrijave) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReportedUserPage(userId)),
      );
    } else if (choice == ConstantsReportedUsers.ObrisiKorisnika) {
      showAlertDialog(context, userId);
    } else if (choice == ConstantsReportedUsers.PosetiProfil){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ViewUserProfilePage(user)),
      );
    }
  }

  Widget search() {
    return Container(
      margin: EdgeInsets.only(left: 5, top:5, bottom: 5),
      width: 150,
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        cursorColor: Colors.black,
        onChanged: (string) {
          _debouncer.run(() { 
            setState(() {
              filteredUsers = listUsers
                    .where((u) => (u.username.toLowerCase().contains(string.toLowerCase()) ||
                        ((u.firstName.toLowerCase() + " " + u.lastName.toLowerCase())
                            .contains(string.toLowerCase()))))
                    .toList();
              _rowsOffset = 0;
            });
          });
        },
        autofocus: false,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search,color: greenPastel),
          hintText: 'Pretraži...',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2,color: greenPastel),
          ),
        ),
        controller: searchController,
      )
    );
  }

   City city;


  Widget dropdownFU(List<City> listCities) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(children: <Widget>[
          new Text("Grad: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        listCities != null
        ? new DropdownButton<City>(
            hint: Text("Izaberi"),
            value: city,
            onChanged: (City newValue) {
              if (newValue.name == "Svi korisnici") {
                filteredUsers = null;
                setState(() {
                  _rowsOffset = 0;
                });
              } else {
                _getUsersFromCity(newValue.id);
                _sortListBy();
              }
              setState(() {
                city = newValue;
              });
              setState(() {
                _rowsOffset = 0;
              });
            },
            items: listCities.map((City option) {
              return DropdownMenuItem(
                child: new Text(option.name),
                value: option,
              );
            }).toList(),
          )
        : new DropdownButton<String>(
            hint: Text("Izaberi"),
            onChanged: null,
            items: null,
          ),
         Text("Kategorija: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        DropdownButton<CategoryDropDown>(
          hint: Text("Izaberi"),
          value: catF,
          onChanged: (CategoryDropDown newValue) {
            setState(() {
              catF = newValue;
            });

            if (newValue.name == "Objave") {
              _sortListBy();
            } else if(newValue.name == "Poeni"){
              _sortListBy();
            } else if(newValue.name == "Nivoi"){
              _sortListBy();
            } else if(newValue.name == "Id"){
              _sortListBy();
            }
            setState(() {
              _rowsOffset = 0;
            });
          },
          items: categories.map((CategoryDropDown option) {
            return DropdownMenuItem(
              child: new Text(option.name),
              value: option,
            );
          }).toList(),
        ),
        ],),
        Row(children: <Widget>[
          Text("Redosled: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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
              setState(() {
                _rowsOffset = 0;
              });
            },
            items: maxMinFilter.map((MaxMinDropDown option) {
              return DropdownMenuItem(
                child: new Text(option.name),
                value: option,
              );
            }).toList(),
          ),
          search()
        ],)
      ]);
  }

  City cityR;

  Widget dropdownFRU(List<City> listCities) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text("Grad: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        listCities != null
        ? new DropdownButton<City>(
            hint: Text("Izaberi"),
            value: cityR,
            onChanged: (City newValue) {
              if (newValue.name == "Svi korisnici") {
                filteredRepUsers = null;
                _sortRepListBy();
                setState(() {
                  _rowsOffsetUnauth = 0;
                });
              } else {
                _getReportedUsersFromCity(newValue.id);
                _sortRepListBy();
              }
              setState(() {
                cityR = newValue;
              });
              setState(() {
                _rowsOffsetUnauth = 0;
              });
            },
            items: listCities.map((City option) {
              return DropdownMenuItem(
                child: new Text(option.name),
                value: option,
              );
            }).toList(),
          )
        : new DropdownButton<String>(
            hint: Text("Izaberi"),
            onChanged: null,
            items: null,
          ),
        Text("Broj prijava: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        DropdownButton<NumRepDropDown>(
          hint: Text("Izaberi"),
          value: repNumF,
          onChanged: (NumRepDropDown newValue) {
            setState(() {
              repNumF = newValue;
            });
            if (newValue.name == "Svi") {
              filteredRepUsers = null;
              _sortRepListBy();
            } else if(newValue.name == "Više od 10"){
              setState(() {
                filteredRepUsers = listRepUsers;
              });
              _sortRepListBy();
            } else if(newValue.name == "Više od 20"){
              _sortRepListBy();
            } else if(newValue.name == "Više od 50"){
              _sortRepListBy();
            }
            setState(() {
              _rowsOffsetUnauth = 0;
            });
          },
          items: repNums.map((NumRepDropDown option) {
            return DropdownMenuItem(
              child: new Text(option.name),
              value: option,
            );
          }).toList(),
        )
      ]);
  }

  Widget searchRep() {
    return Container(
      margin: EdgeInsets.only(left: 50, top:5, bottom: 5),
      width: 200,
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        cursorColor: Colors.black,
        onChanged: (string) {
          _debouncer.run(() { 
            setState(() {
              filteredRepUsers = listRepUsers
                    .where((u) => (u.username.toLowerCase().contains(string.toLowerCase()) ||
                        ((u.firstName.toLowerCase() + " " + u.lastName.toLowerCase())
                            .contains(string.toLowerCase()))))
                    .toList();
              _rowsOffsetUnauth = 0;
            });
          });
        },
        autofocus: false,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search,color: greenPastel),
          hintText: 'Pretraži...',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(width: 2,color: greenPastel),
          ),
        ),
        controller: searchRepController,
      )
    );
  }
  
  int _rowsOffset = 0;
  int _rowsOffsetUnauth = 0;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  int _sortColumnIndex;
  bool _sortAscending = true;

  Widget buildDataTable(List<User> _list) {

    List<User> _items = _list;

    return Container(child: Card(
      child: NativeDataTable.builder(
          rowsPerPage: _rowsPerPage,
          itemCount: _items?.length ?? 0,
          firstRowIndex: _rowsOffset,
          handleNext: () async {
            setState(() {
              _rowsOffset += _rowsPerPage;
            });
          },
          handlePrevious: () {
            setState(() {
              _rowsOffset -= _rowsPerPage;
            });
          },
          itemBuilder: (int index) {
            User tableUser = _items[index];
            return DataRow.byIndex(
                index: index,
                cells: <DataCell>[
                  DataCell(CircleImage(
                    userPhotoURL + tableUser.photo,
                    imageSize: 36.0,
                    whiteMargin: 2.0,
                    imageMargin: 6.0,
                  ),),
                  DataCell(Text('${tableUser.firstName} ${tableUser.lastName}')),
                  DataCell(PopupMenuButton<String>(
                      onSelected: (String choice) {
                        choiceActionAllUsers(choice, tableUser.id, tableUser);
                      },
                      itemBuilder: (BuildContext context) {
                        return ConstantsAllUsers.choices.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),),
                  DataCell(Center(child: Text('${tableUser.postsNum}'))),
                  DataCell(Center(child: Text('${tableUser.donatedPoints + tableUser.points}'))),
                  DataCell(Center(child: Text('${tableUser.level}'))),
                ]);
          },
          alwaysShowDataTable: true,
          header: const Text('Korisnici'),
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          onRowsPerPageChanged: (int value) {
            setState(() {
              _rowsPerPage = value;
            });
          },
          rowCountApproximate: false,
          actions: <Widget>[
          ],
          selectedActions: <Widget>[
          ],
          columns: <DataColumn>[
            
            DataColumn(label: Text('', style: TextStyle(fontWeight: FontWeight.bold),),),
            DataColumn(label: const Text('Ime', style: TextStyle(fontWeight: FontWeight.bold),),),
            DataColumn(tooltip: 'Više opcija', label: Text(' ', style: TextStyle(fontWeight: FontWeight.bold)),),
            DataColumn(label: const Text('Objave', style: TextStyle(fontWeight: FontWeight.bold)),),
            DataColumn(label: const Text('Poeni', style: TextStyle(fontWeight: FontWeight.bold)),),
            DataColumn(label: const Text('Nivo', style: TextStyle(fontWeight: FontWeight.bold)),),
          ],
        ),
      ));
  }

  Widget buildDataTableReported(List<User> _list) {

    List<User> _items = _list;

    return Container(child: Card(
      child: NativeDataTable.builder(
          rowsPerPage: _rowsPerPage,
          itemCount: _items?.length ?? 0,
          firstRowIndex: _rowsOffsetUnauth,
          handleNext: () async {
            setState(() {
              _rowsOffsetUnauth += _rowsPerPage;
            });
          },
          handlePrevious: () {
            setState(() {
              _rowsOffsetUnauth -= _rowsPerPage;
            });
          },
          itemBuilder: (int index) {
            User tableUser = _items[index];
            return DataRow.byIndex(
                index: index,
                cells: <DataCell>[
                  
                  DataCell(Text('${tableUser.firstName} ${tableUser.lastName}')),
                  DataCell(Center(child: Text('${tableUser.reportsNum}', style: TextStyle(color: Colors.red),),)),
                  DataCell(PopupMenuButton<String>(
                    onSelected: (String choice) {
                      choiceActionReportedUsers(choice, tableUser.id, tableUser.firstName, tableUser.lastName, tableUser);
                    },
                    itemBuilder: (BuildContext context) {
                      return ConstantsReportedUsers.choices.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),),
                  DataCell(CircleImage(
                    userPhotoURL + tableUser.photo,
                    imageSize: 36.0,
                    whiteMargin: 2.0,
                    imageMargin: 6.0,
                  ),),
                ]);
          },
          alwaysShowDataTable: true,
          header: const Text('Prijavljeni korisnici'),
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          onRowsPerPageChanged: (int value) {
            setState(() {
              _rowsPerPage = value;
            });
          },
          rowCountApproximate: false,
          actions: <Widget>[
          ],
          selectedActions: <Widget>[
          ],
          columns: <DataColumn>[
            DataColumn(label: const Text('Ime', style: TextStyle(fontWeight: FontWeight.bold),),),
            DataColumn(label: const Text('Broj prijava', style: TextStyle(fontWeight: FontWeight.bold)),),
            DataColumn(tooltip: 'Više opcija', label: Text(' ', style: TextStyle(fontWeight: FontWeight.bold)),),
            DataColumn(label: const Text('', style: TextStyle(fontWeight: FontWeight.bold),),),
          ],
        ),
      ));
  }
}

class CategoryDropDown{
  int id;
  String name;

  CategoryDropDown(this.id, this.name);

  static List<CategoryDropDown> getCategoriesDropDown(){
    return <CategoryDropDown>[
      CategoryDropDown(1,"Id"),
      CategoryDropDown(2,"Objave"),
      CategoryDropDown(3,"Poeni"),
      CategoryDropDown(4,"Nivoi"),
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

class NumRepDropDown{
  int id;
  String name;

  NumRepDropDown(this.id, this.name);

  static List<NumRepDropDown> getNumRepDropDown(){
    return <NumRepDropDown>[
      NumRepDropDown(1,"Svi"),
      NumRepDropDown(2,"Više od 10"),
      NumRepDropDown(3,"Više od 20"),
      NumRepDropDown(4,"Više od 50"),
    ];
  }
}