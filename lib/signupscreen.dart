// ignore: unused_import
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CreateSignUpScreen extends StatefulWidget {
  CreateSignUpScreen({Key key}) : super(key: key);

  @override
  _CreateSignUpPageState createState() => _CreateSignUpPageState();
}

class _CreateSignUpPageState extends State<CreateSignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => {Navigator.pushNamed(context, "/")}),
          //automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Accountscreen', textAlign: TextAlign.center),
          actions: [new Icon(Icons.access_alarm, color: Colors.white)],
        ),
        body: Container(
          color: Colors.black,
        ));
  }
}
