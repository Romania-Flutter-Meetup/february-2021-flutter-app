import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:index_app/components/circular_loading_spinner.dart';
import 'package:index_app/components/email_input_field.dart';
import 'package:index_app/components/password_input_field.dart';
import 'package:index_app/components/text_input_field.dart';
import 'package:index_app/network_utils/api.dart';

import 'login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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

  void retrieveNameFunc(String value) {
    setState(() {
      name = value;
    });
  }

  void retrievePhoneFunc(String value) {
    setState(() {
      phone = value;
    });
  }

  void retrieveApartmentFunc(String value) {
    setState(() {
      apartment = value;
    });
  }

  void retrieveScaraFunc(String value) {
    setState(() {
      scara = value;
    });
  }

  void retrievePasswordFunc(String value) {
    setState(() {
      password = value;
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
                    title: Text("Creează un cont nou"),
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
                        TextInputField(
                          retrieveValueFunc: retrieveNameFunc,
                          label: "Nume si prenume",
                        ),
                        TextInputField(
                          retrieveValueFunc: retrievePhoneFunc,
                          label: "Telefon",
                        ),
                        TextInputField(
                          retrieveValueFunc: retrieveApartmentFunc,
                          label: "Apartament",
                        ),
                        TextInputField(
                          retrieveValueFunc: retrieveScaraFunc,
                          label: "Scara",
                        ),
                        // Password field input
                        PasswordInputField(
                          retrievePasswordFunc: retrievePasswordFunc,
                        ),
                        FlatButton(
                          onPressed: () {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              _register();
                            }
                          },
                          color: Colors.teal,
                          disabledColor: Colors.grey,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              'FINALIZEAZĂ ÎNREGISTRAREA',
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

  void _register() async {
    // setState(() {
    //   _isLoading = true;
    // });

    var data = {
      'email': email,
      'password': password,
      'name': name,
      'phoneNumber': phone,
      'apartment': [
        {
          'number': apartment,
          'entry': scara,
        }
      ]
    };

    print(json.encode(data));
    var res = await Network().register(data, '/users/register');

    var body = json.decode(res.body);
    print(body);
    if (body['email'] != null) {
      _formKey.currentState.reset();
      _showMsg('Te-ai inregistrat cu succes!', success: true);
    } else {
      _showMsg('A intervenit o eroare! Te rugam sa reincerci');
    }
  }
}
