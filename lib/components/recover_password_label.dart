import 'package:flutter/material.dart';
import 'package:index_app/screen/recover_password_screen.dart';

class RecoverPasswordLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            onPressed: () {
              print('Recover password');
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => RecoverPasswordScreen()));
            },
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.lock_open,
                  color: Colors.grey,
                ),
                Text(
                  "Ai pierdut parola?".toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
