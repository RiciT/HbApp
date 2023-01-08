// ignore: unused_import
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CreateApplyingScreen extends StatefulWidget {
  @override
  _CreateApplyingScreenState createState() => _CreateApplyingScreenState();
}

class _CreateApplyingScreenState extends State<CreateApplyingScreen> {
  final _biggerFont = TextStyle(fontSize: 18.0, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> rcvdData =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => {Navigator.pushNamed(context, "/")}),
        centerTitle: true,
        title: Text(rcvdData['name'], textAlign: TextAlign.center),
        actions: [],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            "a buli kezdete: " +
                rcvdData['date'].toString().substring(5, 10) +
                " " +
                rcvdData['date'].toString().substring(11, 16) +
                "\n" +
                (int.parse(rcvdData['diffdatedays']) > 0
                    ? "hátralévő idő a buliig: "
                    : "elkezdodott ennyi ideje: ") +
                (int.parse(rcvdData['diffdatedays']) == 0
                        ? ""
                        : rcvdData['diffdatedays'].toString() + " nap ")
                    .toString() +
                (int.parse(rcvdData['diffdatehours']) == 0
                    ? ""
                    : int.parse(rcvdData['diffdatehours']).abs().toString() +
                        " óra"),
            style: _biggerFont,
          ),
        ),
      ),
    );
  }
}
