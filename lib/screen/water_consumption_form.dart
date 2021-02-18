import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:index_app/classes/water_consumption.dart';

import 'package:index_app/components/text_input_field.dart';
import 'package:index_app/network_utils/api.dart';
import 'package:index_app/screen/water_consumption_listing.dart';

import 'login.dart';

class WaterConsumptionForm extends StatefulWidget {
  @override
  _WaterConsumptionFormState createState() => _WaterConsumptionFormState();
}

class _WaterConsumptionFormState extends State<WaterConsumptionForm> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String bathroomHot;
  String bathroomCold;
  String kitchenHot;
  String kitchenCold;

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

  @override
  void initState() {
    super.initState();
  }

  void retrieveBathroomHotFunc(String value) {
    setState(() {
      bathroomHot = value;
    });
  }

  void retrieveBathroomColdFunc(String value) {
    setState(() {
      bathroomCold = value;
    });
  }

  void retrieveKitchenHotFunc(String value) {
    setState(() {
      kitchenHot = value;
    });
  }

  void retrieveKitchenColdFunc(String value) {
    setState(() {
      kitchenCold = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(months[now.month] + " " + now.year.toString()),
          backgroundColor: Color.fromRGBO(63, 70, 84, 1),
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
        ),
        body: Container(
          padding: EdgeInsets.all(40),
          color: Color.fromRGBO(63, 70, 84, 1),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Text(
                      "Kitchen",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextInputField(
                    retrieveValueFunc: retrieveKitchenColdFunc,
                    label: "Cold",
                  ),
                  TextInputField(
                    retrieveValueFunc: retrieveKitchenHotFunc,
                    label: "Hot",
                  ),
                  Container(
                    width: double.infinity,
                    child: Text(
                      "Bathroom",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextInputField(
                    retrieveValueFunc: retrieveBathroomColdFunc,
                    label: "Cold",
                  ),
                  TextInputField(
                    retrieveValueFunc: retrieveBathroomHotFunc,
                    label: "Hot",
                  ),
                  FlatButton(
                    onPressed: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _saveWaterConsumptionLevels();
                      }
                    },
                    color: Colors.teal,
                    disabledColor: Colors.grey,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0)),
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        'Save',
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showMsg(msg, {success = false}) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Inchide',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar).closed.then((value) {
      if (success) {
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => WaterConsumptionListing(),
          ),
        );
      }
    });
  }

  void _saveWaterConsumptionLevels() async {
    // setState(() {
    //   _isLoading = true;
    // });

    var data = {
      'bathroomHot': bathroomHot,
      'bathroomCold': bathroomCold,
      'kitchenHot': kitchenHot,
      'kitchenCold': kitchenCold,
    };

    print(json.encode(data));
    var res = await Network().postData(data, '/water_consumptions/add');

    var body = json.decode(res.body);
    print(body);
    if (body[0] != null && body[0]['apartment'] != null) {
      _showMsg('New value added', success: true);
    } else {
      _showMsg(body['message']);
    }
  }
}
