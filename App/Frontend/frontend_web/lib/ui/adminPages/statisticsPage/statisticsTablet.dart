import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend_web/models/donation.dart';
import 'package:frontend_web/models/statistics.dart';
import 'package:frontend_web/models/user.dart';
import 'package:frontend_web/services/api.services.dart';
import 'package:frontend_web/services/token.session.dart';
import 'package:frontend_web/ui/adminPages/manageDonation/viewDonation/viewDonationPage.dart';
import 'package:frontend_web/ui/adminPages/manageUser/viewProfile/viewProfilePage.dart';
import 'package:frontend_web/ui/adminPages/statisticsPage/statisticsDesktop.dart';
import 'package:frontend_web/widgets/circleImageWidget.dart';
import 'package:frontend_web/widgets/collapsingNavigationDrawer.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatisticsTablet extends StatefulWidget {
  @override
  _StatisticsTabletState createState() => _StatisticsTabletState();
}

class _StatisticsTabletState extends State<StatisticsTablet> {
  List<User> listUsers;
  Statistics stat;
  List<double> monthlyUsers;
  Donation donation;
  List<charts.Series<Task, String>> _seriesPieData;
  List<charts.Series<Task, String>> _seriesPieData1;
  List<charts.Series<TimeSeriesSimple, DateTime>> seriesList;
  var data;

  _getUsers() {
    APIServices.getTop10(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<User> listU = List<User>();
      listU = list.map((model) => User.fromObject(model)).toList();
      if (mounted) {
        setState(() {
          listUsers = listU;
        });
      }
      _getStatistics();
    });
  }

  _getMonthlyUsers() {
    APIServices.getMonthlyUsers(TokenSession.getToken).then((res) {
      Iterable list = json.decode(res.body);
      List<double> listU = List<double>();
      listU = list.cast<double>();
      if (mounted) {
        setState(() {
          monthlyUsers = listU;
        });
      }
    });
  }

  _getStatistics() async {
    var res = await APIServices.getStatistics(TokenSession.getToken);
    Map<String, dynamic> jsonUser = jsonDecode(res.body);
    Statistics statistics = Statistics.fromObject(jsonUser);
    setState(() {
      stat = statistics;

      var piedata = [
        new Task('Sve donacije', statistics.numberOfActiveDonations.toDouble(),
            Color(0xFF99BFA6)),
        new Task('Aktivne donacije', statistics.numberOfDonations.toDouble(),
            Color(0xFF6060A6)),
        new Task('Svi događaji', statistics.numberOfEvents.toDouble(),
            Color(0xFF00BFA6)),
        new Task('Nezavršeni događaji',
            statistics.numberOfActiveEvents.toDouble(), Color(0xfffdbe19)),
      ];

      var piedata1 = [
        new Task('Rešene objave', statistics.numberOfSolvedPosts.toDouble(),
            Color(0xFF99BFA6)),
        new Task('Nerešene objave', statistics.numberOfUnsolvedPosts.toDouble(),
            Color(0xFF00BFA6)),
      ];

      _seriesPieData = List<charts.Series<Task, String>>();
      _seriesPieData1 = List<charts.Series<Task, String>>();

      seriesList = List<charts.Series<TimeSeriesSimple, DateTime>>();

      _seriesPieData.add(
        charts.Series(
          domainFn: (Task task, _) => task.task,
          measureFn: (Task task, _) => task.taskvalue,
          colorFn: (Task task, _) =>
              charts.ColorUtil.fromDartColor(task.colorval),
          id: 'Događaji i donacije',
          data: piedata,
          labelAccessorFn: (Task row, _) => '${row.taskvalue}',
        ),
      );
      _seriesPieData1.add(
        charts.Series(
          domainFn: (Task task, _) => task.task,
          measureFn: (Task task, _) => task.taskvalue,
          colorFn: (Task task, _) =>
              charts.ColorUtil.fromDartColor(task.colorval),
          id: 'Objave',
          data: piedata1,
          labelAccessorFn: (Task row, _) => '${row.taskvalue}',
        ),
      );
    });

    DateTime month12 = new DateTime(
        DateTime.now().month - 12 <= 0
            ? DateTime.now().year - 1
            : DateTime.now().year,
        DateTime.now().month - 12 <= 0
            ? DateTime.now().month + 12 - 12
            : DateTime.now().month - 12,
        DateTime.now().day);
    DateTime month11 = new DateTime(
        DateTime.now().month - 11 <= 0
            ? DateTime.now().year - 1
            : DateTime.now().year,
        DateTime.now().month - 11 <= 0
            ? DateTime.now().month + 12 - 11
            : DateTime.now().month - 11,
        DateTime.now().day);
    DateTime month10 = new DateTime(
        DateTime.now().month - 10 <= 0
            ? DateTime.now().year - 1
            : DateTime.now().year,
        DateTime.now().month - 10 <= 0
            ? DateTime.now().month + 12 - 10
            : DateTime.now().month - 10,
        DateTime.now().day);
    DateTime month9 = new DateTime(
        DateTime.now().month - 9 <= 0
            ? DateTime.now().year - 1
            : DateTime.now().year,
        DateTime.now().month - 9 <= 0
            ? DateTime.now().month + 12 - 9
            : DateTime.now().month - 9,
        DateTime.now().day);
    DateTime month8 = new DateTime(
        DateTime.now().month - 8 <= 0
            ? DateTime.now().year - 1
            : DateTime.now().year,
        DateTime.now().month - 8 <= 0
            ? DateTime.now().month + 12 - 8
            : DateTime.now().month - 8,
        DateTime.now().day);
    DateTime month7 = new DateTime(
        DateTime.now().month - 7 <= 0
            ? DateTime.now().year - 1
            : DateTime.now().year,
        DateTime.now().month - 7 <= 0
            ? DateTime.now().month + 12 - 7
            : DateTime.now().month - 7,
        DateTime.now().day);
    DateTime month6 = new DateTime(
        DateTime.now().month - 6 <= 0
            ? DateTime.now().year - 1
            : DateTime.now().year,
        DateTime.now().month - 6 <= 0
            ? DateTime.now().month + 12 - 6
            : DateTime.now().month - 6,
        DateTime.now().day);
    DateTime month5 = new DateTime(
        DateTime.now().month - 5 <= 0
            ? DateTime.now().year - 1
            : DateTime.now().year,
        DateTime.now().month - 5 <= 0
            ? DateTime.now().month + 12 - 5
            : DateTime.now().month - 5,
        DateTime.now().day);
    DateTime month4 = new DateTime(
        DateTime.now().month - 4 <= 0
            ? DateTime.now().year - 1
            : DateTime.now().year,
        DateTime.now().month - 4 <= 0
            ? DateTime.now().month + 12 - 4
            : DateTime.now().month - 4,
        DateTime.now().day);
    DateTime month3 = new DateTime(
        DateTime.now().month - 3 <= 0
            ? DateTime.now().year - 1
            : DateTime.now().year,
        DateTime.now().month - 3 <= 0
            ? DateTime.now().month + 12 - 3
            : DateTime.now().month - 3,
        DateTime.now().day);
    DateTime month2 = new DateTime(
        DateTime.now().month - 2 <= 0
            ? DateTime.now().year - 1
            : DateTime.now().year,
        DateTime.now().month - 2 <= 0
            ? DateTime.now().month + 12 - 2
            : DateTime.now().month - 2,
        DateTime.now().day);
    DateTime month1 = new DateTime(
        DateTime.now().month - 1 <= 0
            ? DateTime.now().year - 1
            : DateTime.now().year,
        DateTime.now().month - 1 <= 0
            ? DateTime.now().month + 12 - 1
            : DateTime.now().month - 1,
        DateTime.now().day);

    data = [
      new TimeSeriesSimple(time: month12, novi: monthlyUsers[11].toInt()),
      new TimeSeriesSimple(time: month11, novi: monthlyUsers[10].toInt()),
      new TimeSeriesSimple(time: month10, novi: monthlyUsers[9].toInt()),
      new TimeSeriesSimple(time: month9, novi: monthlyUsers[8].toInt()),
      new TimeSeriesSimple(time: month8, novi: monthlyUsers[7].toInt()),
      new TimeSeriesSimple(time: month7, novi: monthlyUsers[6].toInt()),
      new TimeSeriesSimple(time: month6, novi: monthlyUsers[5].toInt()),
      new TimeSeriesSimple(time: month5, novi: monthlyUsers[4].toInt()),
      new TimeSeriesSimple(time: month4, novi: monthlyUsers[3].toInt()),
      new TimeSeriesSimple(time: month3, novi: monthlyUsers[2].toInt()),
      new TimeSeriesSimple(time: month2, novi: monthlyUsers[1].toInt()),
      new TimeSeriesSimple(time: month1, novi: monthlyUsers[0].toInt()),
    ];

    seriesList.add(charts.Series<TimeSeriesSimple, DateTime>(
      id: 'Balance',
      colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      domainFn: (TimeSeriesSimple sales, _) => sales.time,
      measureFn: (TimeSeriesSimple sales, _) => sales.novi,
      data: data,
    ));
  }

  _getDonation() async {
    var res = await APIServices.getLastDonation(TokenSession.getToken);
    Map<String, dynamic> jsonUser = jsonDecode(res.body);
    Donation don = Donation.fromObject(jsonUser);
    setState(() {
      donation = don;
    });
  }

  void initState() {
    super.initState();
    _getUsers();
    //_getStatistics();
    _getMonthlyUsers();
    _getDonation();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: (stat != null &&
              donation != null &&
              monthlyUsers != null &&
              _seriesPieData != null &&
              _seriesPieData1 != null &&
              _seriesPieData != [] &&
              _seriesPieData1 != [])
          ? Stack(children: <Widget>[
              Container(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 500),
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            stats("OBJAVE", Icons.photo_library,
                                stat.numberOfPosts, stat.numberOfNewPostsIn24h),
                            Expanded(child: SizedBox(width: 5)),
                            stats("KORISNICI", Icons.account_circle,
                                stat.numberOfUsers, stat.numberOfNewUsersIn24h),
                            Expanded(child: SizedBox(width: 5)),
                            stats(
                                "INSTITUCIJE",
                                Icons.account_balance,
                                stat.numberOfInstitutions,
                                stat.numberOfNewInstitutionIn24h),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(child: SizedBox(width: 5)),
                            stats("DOGAĐAJI", Icons.calendar_today,
                                stat.numberOfEvents, stat.numberOfActiveEvents),
                            Expanded(child: SizedBox(width: 5)),
                            stats(
                                "DONACIJE",
                                Icons.calendar_today,
                                stat.numberOfDonations,
                                stat.numberOfActiveDonations),
                            Expanded(child: SizedBox(width: 5)),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        buildUserList(listUsers),
                        SizedBox(
                          height: 20,
                        ),
                        newDonation(),
                        SizedBox(
                          height: 20,
                        ),
                        eventPost(),
                        SizedBox(
                          height: 20,
                        ),
                        piePost1()
                      ],
                    ),
                  )),
              CollapsingNavigationDrawer()
            ])
          : Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF00BFA6)),
              ),
            ),
    );
  }

  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 4));
    setState(() {
      stat = new Statistics();
      donation = new Donation();
    });
    _getStatistics();
    _getDonation();
    _getMonthlyUsers();
    return null;
  }

  Widget stats(String name, IconData icon, int number, int number2) {
    return Card(
        child: Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  name,
                  style: TextStyle(fontSize: 15.0, color: Colors.grey),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Icon(icon, color: Colors.black, size: 40),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Text("$number",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 20.0)),
                        Text("+ " + "$number2",
                            style: TextStyle(
                                color: Color(0xFF00BFA6), fontSize: 20.0)),
                      ],
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget newDonation() {
    return Card(
        child: Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          width: 400,
          height: 400,
          child: Column(
            children: <Widget>[
              Text(
                'Događaji i donacije',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w200),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.PieChart(_seriesPieData,
                    behaviors: [
                      new charts.DatumLegend(
                        outsideJustification:
                            charts.OutsideJustification.endDrawArea,
                        horizontalFirst: false,
                        desiredMaxRows: 2,
                        cellPadding:
                            new EdgeInsets.only(right: 4.0, bottom: 4.0),
                        entryTextStyle: charts.TextStyleSpec(
                            color: charts.MaterialPalette.gray.shadeDefault,
                            fontFamily: 'Georgia',
                            fontSize: 11),
                      )
                    ],
                    defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 100,
                        arcRendererDecorators: [
                          new charts.ArcLabelDecorator(
                              labelPosition: charts.ArcLabelPosition.inside)
                        ])),
              ),
            ],
          ),
        ),
      )
    ]));
  }

  Widget buildUserList(List<User> listUsers) {
    return Card(
        child: Column(
      children: [
        Text(
          'Top 10 korisnika',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w200),
        ),
        Container(
            width: 350,
            height: 400,
            child: ListView.builder(
              itemCount: listUsers == null ? 0 : listUsers.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewUserProfilePage(listUsers[index])),
                    );
                  },
                  child: Container(
                    child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(top: 5),
                          child: Row(children: [
                            CircleImage(
                              userPhotoURL + listUsers[index].photo,
                              imageSize: 40.0,
                              whiteMargin: 2.0,
                              imageMargin: 6.0,
                            ),
                            Container(
                              // width: 80,
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(listUsers[index].username,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      listUsers[index].firstName +
                                          " " +
                                          listUsers[index].lastName,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 15))
                                ],
                              ),
                            ),
                            Expanded(
                                child: SizedBox(
                              width: 10,
                            )),
                            Text(
                              (listUsers[index].points +
                                      listUsers[index].donatedPoints)
                                  .toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 20),
                            ),
                          ])),
                    ],
                  ),
                )),
                );
              },
            ))
      ],
    ));
  }

  Widget eventPost() {
    return Card(
      color: Colors.white,
      child: Container(
        height: 350,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        'Novi korisnici u prethodnih godinu dana',
                        style: TextStyle(
                            fontSize: 21.0, fontWeight: FontWeight.w200),
                      ),
                    ),
                    Container(
                        constraints:
                            BoxConstraints(maxHeight: 350, maxWidth: 300),
                        child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Container(
                              constraints:
                                  BoxConstraints(maxHeight: 250, maxWidth: 250),
                              child: new charts.TimeSeriesChart(
                                seriesList,
                                defaultRenderer:
                                    new charts.LineRendererConfig(),
                                customSeriesRenderers: [
                                  new charts.PointRendererConfig(
                                      customRendererId: 'customPoint')
                                ],
                                dateTimeFactory:
                                    const charts.LocalDateTimeFactory(),
                              ),
                            ))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget piePost1() {
    return Card(
      color: Colors.white,
      child: Center(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          width: 300,
          height: 250,
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  'Objave ',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w200),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: charts.PieChart(_seriesPieData1,
                      behaviors: [
                        new charts.DatumLegend(
                          outsideJustification:
                              charts.OutsideJustification.endDrawArea,
                          horizontalFirst: false,
                          desiredMaxRows: 2,
                          cellPadding:
                              new EdgeInsets.only(right: 4.0, bottom: 4.0),
                          entryTextStyle: charts.TextStyleSpec(
                              color: charts.MaterialPalette.gray.shadeDefault,
                              fontFamily: 'Georgia',
                              fontSize: 11),
                        )
                      ],
                      defaultRenderer: new charts.ArcRendererConfig(
                          arcWidth: 100,
                          arcRendererDecorators: [
                            new charts.ArcLabelDecorator(
                                labelPosition: charts.ArcLabelPosition.inside)
                          ])),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
