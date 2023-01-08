// ignore: unused_import
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CreateAccountScreen extends StatefulWidget {
  CreateAccountScreen({Key key}) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountScreen> {
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
