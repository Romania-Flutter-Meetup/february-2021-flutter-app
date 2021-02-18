import 'package:flutter/material.dart';

class PasswordInputField extends StatefulWidget {
  final String labelText;
  final String errorText;
  final Function retrievePasswordFunc;

  PasswordInputField({
    this.labelText,
    this.errorText,
    this.retrievePasswordFunc,
  });

  @override
  _PasswordInputFieldState createState() => _PasswordInputFieldState(
        labelText: labelText,
        errorText: errorText,
        retrievePasswordFunc: retrievePasswordFunc,
      );
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _obscureText = true;
  String labelText = '';
  String errorText = '';
  Function retrievePasswordFunc;

  FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();

    myFocusNode.addListener(() {
      // TextField lost focus
      if (!myFocusNode.hasFocus) {
        setState(() {
          _obscureText = true;
        });
      }
    });
  }

  _PasswordInputFieldState({
    this.labelText,
    this.errorText,
    this.retrievePasswordFunc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      child: TextFormField(
        focusNode: myFocusNode,
        obscureText: _obscureText,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelStyle: TextStyle(
              color: Colors.green,
            ),
            border: InputBorder.none,
            prefixIcon: const Icon(
              Icons.vpn_key,
              color: Colors.grey,
            ),
            suffixIcon: FlatButton(
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
            ),
            labelText: labelText == null ? 'Parola' : labelText),
        validator: (value) {
          if (value.isEmpty) {
            return errorText == null
                ? 'Este necesar sa introduci o valoare'
                : errorText;
          }
          // TODO: check repeat password
          return null;
        },
        onChanged: (value) {
          retrievePasswordFunc(value);
        },
      ),
    );
  }
}
