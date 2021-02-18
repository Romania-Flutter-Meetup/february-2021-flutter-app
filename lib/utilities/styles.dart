import 'package:flutter/material.dart';

final kTitleStyle = TextStyle(
    color: Colors.white,
    fontFamily: 'Roboto',
    fontSize: 40.0,
    height: 1.5,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    shadows: [
      Shadow(
        blurRadius: 4,
        color: Color.fromRGBO(0, 0, 0, 0.25),
        offset: Offset(0, 4.0),
      ),
    ]);

final kSubtitleStyle = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.w300,
    fontStyle: FontStyle.normal,
    fontFamily: 'Roboto',
    shadows: [
      Shadow(
        blurRadius: 4,
        color: Color.fromRGBO(0, 0, 0, 0.25),
        offset: Offset(0, 4.0),
      ),
    ]);
