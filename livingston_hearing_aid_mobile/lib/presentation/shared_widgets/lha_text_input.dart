import 'package:flutter/material.dart';

class LHATextInput extends StatelessWidget {
  const LHATextInput(
      {Key key,
      this.inputController,
      this.hintText,
      this.isPassword,
      this.validator})
      : super(key: key);

  final TextEditingController inputController;
  final String hintText;
  final bool isPassword;
  final Function validator;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextFormField(
      controller: inputController,
      validator: validator,
      style: TextStyle(fontSize: 30),
      decoration: new InputDecoration(
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(15.0),
            ),
          ),
          filled: true,
          hintStyle: new TextStyle(color: Colors.grey[800]),
          hintText: hintText,
          fillColor: Colors.white70),
      obscureText: isPassword ?? false,
    ));
  }
}
