import 'package:flutter/material.dart';
import 'package:index_app/utilities/styles.dart';

class AppTitle extends StatelessWidget {
  final String _title;

  AppTitle(this._title);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        _title,
        style: kTitleStyle,
      ),
    );
  }
}
