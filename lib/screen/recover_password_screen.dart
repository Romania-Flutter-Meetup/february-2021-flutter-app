import 'package:flutter/material.dart';
import 'package:index_app/components/email_input_field.dart';
import 'dart:convert';
import 'package:index_app/components/circular_loading_spinner.dart';
import 'package:index_app/network_utils/api.dart';

import 'login.dart';

class RecoverPasswordScreen extends StatefulWidget {
  @override
  _RecoverPasswordScreenState createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  String email;
  String password;
  String name;
  String phone;
  String apartment;
  String scara;

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
            builder: (context) => LoginScreen(),
          ),
        );
      }
    });
  }

  void retrieveValueFunc(String value) {
    setState(() {
      email = value;
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
      child: _isLoading
          ? CircularLoadingSpinner()
          : Scaffold(
              key: _scaffoldKey,
              resizeToAvoidBottomPadding: false,
              body: Form(
                key: _formKey,
                child: Scaffold(
                  appBar: AppBar(
                    title: Text("Recuperare parola"),
                    backgroundColor: Color.fromRGBO(63, 70, 84, 1),
                  ),
                  resizeToAvoidBottomPadding: false,
                  body: Container(
                    padding: EdgeInsets.all(40),
                    color: Color.fromRGBO(63, 70, 84, 1),
                    child: Column(
                      children: <Widget>[
                        // Email input field
                        EmailInputField(retrieveValueFunc: retrieveValueFunc),
                        FlatButton(
                          onPressed: () {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              _recover();
                            }
                          },
                          color: Colors.teal,
                          disabledColor: Colors.grey,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              'Recupereaza parola',
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
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void _recover() async {
    var data = {'email': email};

    print(json.encode(data));
    var res = await Network().recover(data, '/recover-password');

    var body = json.decode(res.body);
    print(body);
    if (body['token'] != null) {
      _formKey.currentState.reset();
      _showMsg('Cerere inregistrata. Verifica link-ul primit pe email.',
          success: true);
    } else {
      _showMsg('A intervenit o eroare! Te rugam sa reincerci');
    }
  }
}
