import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  final String label;
  final Function retrieveValueFunc;

  TextInputField({this.retrieveValueFunc, this.label});

  @override
  _TextInputFieldState createState() =>
      _TextInputFieldState(retrieveValueFunc: retrieveValueFunc, label: label);
}

class _TextInputFieldState extends State<TextInputField> {
  String label = '';
  final TextEditingController _controller = TextEditingController();
  String _value = '';

  Function retrieveValueFunc;

  _TextInputFieldState({this.retrieveValueFunc, this.label});

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
          suffixIcon: FlatButton(
            onPressed: () {
              _controller.clear();
              setState(() {
                _value = '';
              });
            },
            child: _value.isNotEmpty
                ? Icon(
                    Icons.cancel,
                    color: Colors.grey,
                  )
                : null,
          ),
          labelText: label,
        ),
        validator: (value) {
          return validate(value);
        },
        onChanged: (value) {
          setState(() {
            _value = value;
          });
        },
        onSaved: (value) {
          print(value);
          retrieveValueFunc(value);
        },
      ),
    );
  }

  String validate(String value) {
    if (value.isEmpty) {
      return 'Campul este obligatoriu';
    }
    return null;
  }
}
