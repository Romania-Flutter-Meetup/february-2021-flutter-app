import 'package:flutter/material.dart';

class NumericInputField extends StatefulWidget {
  final int min;
  final int max;

  final String label;
  final Function retrieveValueFunc;

  NumericInputField({this.retrieveValueFunc, this.label, this.min, this.max});

  @override
  _NumericInputFieldState createState() => _NumericInputFieldState(
      retrieveValueFunc: this.retrieveValueFunc,
      label: this.label,
      min: this.min,
      max: this.max);
}

class _NumericInputFieldState extends State<NumericInputField> {
  int min = 0;
  int max = 100;

  String label = '';
  final TextEditingController _controller = TextEditingController();
  String _value = '';

  Function retrieveValueFunc;

  _NumericInputFieldState(
      {this.retrieveValueFunc, this.label, this.min, this.max});

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
        keyboardType: TextInputType.number,
        validator: (value) {
          return validate(value);
        },
        onChanged: (value) {
          setState(() {
            _value = value;
          });
        },
        onSaved: (value) {
          retrieveValueFunc(value);
        },
      ),
    );
  }

  String validate(String value) {
    if (value.isEmpty) {
      return 'Campul este obligatoriu';
    }

    if (int.parse(value) < min) {
      return 'Vârsta minimă obligatorie este de ' + min.toString() + ' ani';
    }

    if (int.parse(value) > max) {
      return 'Vârsta maximă posibilă este de ' + max.toString() + ' ani';
    }

    return null;
  }
}
