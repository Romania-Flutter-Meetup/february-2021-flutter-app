import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:index_app/classes/water_consumption.dart';
import 'package:index_app/network_utils/api.dart';
import 'package:index_app/screen/water_consumption_form.dart';

import 'login.dart';

class WaterConsumptionListing extends StatefulWidget {
  @override
  _WaterConsumptionListingState createState() =>
      _WaterConsumptionListingState();
}

class _WaterConsumptionListingState extends State<WaterConsumptionListing> {
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
    _loadClientData();
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
          title: Text('Dashboard'),
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
        body: waterConsumptionList.length > 0
            ? ListView.builder(
                itemCount: waterConsumptionList.length,
                itemBuilder: (BuildContext context, int index) {
                  var parsedDate =
                      DateTime.parse(waterConsumptionList[index].createdAt);

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          months[parsedDate.month - 1] +
                              " " +
                              parsedDate.year.toString(),
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Colors.black,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Kitchen',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Cold: " +
                                      waterConsumptionList[index]
                                          .kitchenCold
                                          .toString()),
                                  Text("Hot: " +
                                      waterConsumptionList[index]
                                          .kitchenHot
                                          .toString()),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Bathroom',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("Cold: " +
                                      waterConsumptionList[index]
                                          .bathroomCold
                                          .toString()),
                                  Text("Hot: " +
                                      waterConsumptionList[index]
                                          .bathroomHot
                                          .toString())
                                ],
                              )
                            ],
                          ),
                        ),
                        index == waterConsumptionList.length - 1
                            ? Column(
                                children: [
                                  Text(
                                    months[parsedDate.month] +
                                        " " +
                                        parsedDate.year.toString(),
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  RaisedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              WaterConsumptionForm(),
                                        ),
                                      );
                                    },
                                    child: Text("Press here to add " +
                                        months[parsedDate.month] +
                                        " water consumption levels"),
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  );
                },
              )
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "There are no water levels inserted yet",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WaterConsumptionForm(),
                      ),
                    );
                  },
                  child: Text("Press here to add " +
                      months[now.month - 1] +
                      " water consumption levels"),
                ),
              ]),
      ),
    );
  }

  Future<void> _loadClientData() async {
    print('loading water consumptions from api');
    var res = await Network().getData('/water_consumptions');
    print(res.body);
    setState(() {
      waterConsumptionList = waterConsumptionFromJson(res.body);
    });
  }
}
