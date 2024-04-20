import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Color.fromARGB(255, 255, 255, 255),
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.elliptical(8.0, 8.0)),
    borderSide: BorderSide(color: Colors.white, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.elliptical(8.0, 8.0)),
    borderSide: BorderSide(color: Color.fromARGB(255, 15, 41, 93), width: 1.0),
  ),
);
