import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

import '../components/slide_route_right.dart';
import '../screen/launch_tutorial.dart';
import '../screen/login.dart';

class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  bool _visible = true;
  Timer _timer;
  int _fadeIndex = 0;

  @override
  Widget build(BuildContext context) {
    _timer = new Timer(
      const Duration(milliseconds: 2000),
      () {
        if (_fadeIndex == 1) {
          _timer.cancel();
        } else {
          setState(
            () {
              _visible = !_visible;
              _fadeIndex++;
            },
          );
        }
      },
    );

    return Container(
      width: MediaQuery.of(context).size.width,
      color: Color.fromRGBO(63, 70, 84, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedOpacity(
            onEnd: () {
              _checkFirstTimeAccess();
            },
            opacity: _visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 2000),
            child: FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: AssetImage('assets/images/hero.png'),
              width: 300,
            ),
          )
        ],
      ),
    );
  }

  void _checkFirstTimeAccess() async {
    print('Checking first time access');
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var firstTime = localStorage.getString('first_time_load');

    var page;
    if (firstTime == null) {
      page = LaunchTutorialScreen();
    } else {
      page = LoginScreen();
    }

    Navigator.push(
      context,
      SlideRightRoute(
        page: page,
      ),
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
