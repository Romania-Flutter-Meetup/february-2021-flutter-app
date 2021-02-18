import 'package:flutter/material.dart';

class EmailInputField extends StatefulWidget {
  final Function retrieveValueFunc;

  EmailInputField({this.retrieveValueFunc});

  @override
  _EmailInputFieldState createState() =>
      _EmailInputFieldState(retrieveValueFunc: retrieveValueFunc);
}

class _EmailInputFieldState extends State<EmailInputField> {
  final TextEditingController _controller = TextEditingController();
  String _email = '';
  Function retrieveValueFunc;

  _EmailInputFieldState({this.retrieveValueFunc});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelStyle: TextStyle(
            color: Colors.green,
          ),
          border: InputBorder.none,
          prefixIcon: const Icon(
            Icons.email,
            color: Colors.grey,
          ),
          suffixIcon: FlatButton(
            onPressed: () {
              _controller.clear();
              setState(() {
                _email = '';
              });
            },
            child: _email.isNotEmpty
                ? Icon(
                    Icons.cancel,
                    color: Colors.grey,
                  )
                : null,
          ),
          labelText: "Adresa de email",
        ),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          return validateEmail(value);
        },
        onChanged: (value) {
          setState(() {
            _email = value;
          });
        },
        onSaved: (value) {
          print(value);
          retrieveValueFunc(value);
        },
      ),
    );
  }

  String validateEmail(String value) {
    if (value.isEmpty) {
      return 'Campul este obligatoriu';
    }

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Este necesara o adresa de email valida';
    else
      return null;
  }
}
