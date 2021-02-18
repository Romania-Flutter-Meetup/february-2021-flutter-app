import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'water_consumption_listing.dart';
import 'admin_dashboard.dart';
import '../screen/register.dart';

import '../components/circular_loading_spinner.dart';
import '../components/app_title.dart';
import '../components/email_input_field.dart';
import '../components/password_input_field.dart';
import '../components/recover_password_label.dart';
import '../network_utils/api.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var email;
  var password;
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Inchide',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  void retrieveValueFunc(String value) {
    setState(() {
      email = value;
    });
  }

  void retrievePasswordFunc(String value) {
    setState(() {
      password = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: GestureDetector(
        // Removing keyboard if click on other element
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomPadding: false,
          body: _isLoading
              ? CircularLoadingSpinner()
              : Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.all(40),
                    color: Color.fromRGBO(63, 70, 84, 1),
                    child: Column(
                      children: <Widget>[
                        // Title
                        AppTitle('Intra in cont'),
                        // Spacing
                        SizedBox(
                          height: 50,
                        ),
                        // Email input field
                        EmailInputField(retrieveValueFunc: retrieveValueFunc),
                        // Spacing
                        SizedBox(
                          height: 20,
                        ),
                        // Password field input
                        PasswordInputField(
                            retrievePasswordFunc: retrievePasswordFunc),
                        // Recover password anchor
                        RecoverPasswordLabel(),
                        // Login button
                        FlatButton(
                          onPressed: () {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }

                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              _login();
                            }
                          },
                          color: Colors.teal,
                          disabledColor: Colors.grey,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              _isLoading ? 'Proccessing...' : 'Login',
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
                        // Register Button
                        OutlineButton(
                          borderSide: BorderSide(color: Colors.white),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              'Inregistrează-te',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                          onPressed: () {
                            print('register...');
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => Register()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  void _login() async {
    var deviceName = 'not available';
    setState(() {
      _isLoading = true;
    });

    var data = {
      'email': email,
      'password': password,
    };

    var res = await Network().authData(data, '/login');
    var body = json.decode(res.body);
    print(body);

    setState(() {
      _isLoading = false;
    });

    if (body['email'] != null && body['isActive']) {
      // Save user data
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('api_token', body['token']);
      localStorage.setString('user_data', json.encode(body));

      if (body['roles'][0] == "ROLE_USER") {
        print('user_type client');
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => WaterConsumptionListing(),
          ),
        );
      } else if (body['roles'][0] == "ROLE_ADMIN") {
        print('user_type admin');
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => AdminDashboard(),
          ),
        );
      } else {
        _showMsg('A intervenit o eroare!');
        localStorage.remove('api_token');
        localStorage.remove('user_data');
      }
    } else {
      if (body['message'] != null) {
        // print(res.body);
        _showMsg(body['message']);
      } else {
        _showMsg('Inactive user');
      }
    }
  }

  void _checkIfLoggedIn() async {
    print('Checking if token is present');

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('api_token');
    var user_data = localStorage.getString('user_data');

    print(user_data);

    if (token != null) {
      print('api_token found');
      _isTokenStillValid(jsonDecode(user_data)['id']);
    } else {
      print('api_token not found');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _isTokenStillValid(int id) async {
    print('check token');

    var res = await Network().getData('/users/' + id.toString());
    var body = json.decode(res.body);

    print(body);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (body['email'] != null && body['isActive'] == true) {
      print('User token is valid');

      print('user data found');
      if (body['roles'][0] == 'ROLE_USER') {
        print('user_type client');
        localStorage.setString('user_data', json.encode(body));
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => WaterConsumptionListing(),
          ),
        );
      } else if (body['roles'][0] == 'ROLE_ADMIN') {
        print('user_type admin');
        localStorage.setString('user_data', json.encode(body));
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => AdminDashboard(),
          ),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        _showMsg('A intervenit o eroare!');
        localStorage.remove('api_token');
        localStorage.remove('user_data');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      _showMsg('A intervenit o eroare!');
      localStorage.remove('api_token');
      localStorage.remove('user_data');
      print('User token is not valid. Removing stored data...');
    }
  }
}
