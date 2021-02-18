import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:index_app/screen/intro.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // _clearData();
    return MaterialApp(
      title: 'Water Consumption App',
      debugShowCheckedModeBanner: true,
      home: Intro(),
    );
  }

  void _clearData() async {
    print('DEBUG: clearing data...');
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('first_time_load');
    localStorage.remove('api_token');
    localStorage.remove('user_data');
  }
}
