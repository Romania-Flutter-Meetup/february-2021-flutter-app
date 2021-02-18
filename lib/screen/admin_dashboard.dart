import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:index_app/classes/water_consumption.dart';
import 'package:index_app/network_utils/api.dart';

import 'login.dart';

class AdminDashboard extends StatefulWidget {
  AdminDashboard();

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  var months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  var now = new DateTime.now();
  List<WaterConsumption> waterConsumptionList = List<WaterConsumption>();
  List<WaterConsumption> waterConsumptionFromJson(String str) =>
      List<WaterConsumption>.from(
        json.decode(str).map(
              (x) => WaterConsumption.fromJson(x),
            ),
      );

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Admin dashboard'),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Network().logOut();
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
            )
          ],
          backgroundColor: Color.fromRGBO(63, 70, 84, 1),
        ),
        body: ListView.builder(
          itemCount: waterConsumptionList.length,
          itemBuilder: (BuildContext context, int index) {},
        ),
      ),
    );
  }

  Future<void> _loadData() async {
    print('loading apartments and water levels from api');
    var res = await Network().getData('/apartments');
    print(res.body);
    // setState(() {
    //   waterConsumptionList = waterConsumptionFromJson(res.body);
    // });
  }
}
