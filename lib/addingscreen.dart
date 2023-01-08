// ignore: unused_import
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class CreateAddingScreen extends StatefulWidget {
  @override
  _CreateAddingScreenState createState() => _CreateAddingScreenState();
}

class _CreateAddingScreenState extends State<CreateAddingScreen> {
  final _biggerFont = TextStyle(fontSize: 18.0, color: Colors.white);

  String recordName;
  int recordType = 0;
  DateTime recordDate;

  String recordT, recordD;

  double _height;
  double _width;
  String _hour, _minute, _time;
  String dateTime;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  Future createData(String name, int type, DateTime date) async {
    var resBody = {};
    resBody["Type"] = type;
    resBody["Name"] = name;
    resBody["Date"] = date.toString();
    var fields = {};
    fields["fields"] = resBody;
    fields["typecast"] = true;
    String str = json.encode(fields);
    final response = await http.post(
        Uri.parse('https://api.airtable.com/v0/appSK4qgSgdCbtUVW/Events'),
        headers: <String, String>{
          'Authorization': "Bearer keyCpSbvruShOPMWj",
          'Content-Type': 'application/json',
        },
        body: str);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to create album. ${response.statusCode} + ${response.body}');
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => {Navigator.pushNamed(context, "/")}),
          //automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('Addingscreen', textAlign: TextAlign.center),
          actions: [],
        ),
        body: Container(
            width: _width,
            height: _height,
            color: Colors.black,
            child: Column(children: [
              Container(
                color: Colors.black,
                child: TextField(
                  controller: _nameController,
                  style: _biggerFont,
                  onChanged: (value) => {recordName = _nameController.text},
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Név:',
                      hintStyle: _biggerFont),
                ),
              ),
              InkWell(
                onTap: () {
                  _selectDate(context);
                },
                child: Row(children: [
                  Text(
                    'Dátum: ',
                    style: _biggerFont,
                  ),
                  Container(
                    width: _width / 4,
                    height: _height / 15,
                    alignment: Alignment.center,
                    child: TextFormField(
                      style: _biggerFont,
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _dateController,
                      decoration: InputDecoration(
                        disabledBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        // labelText: 'Time',
                      ),
                    ),
                  )
                ]),
              ),
              InkWell(
                  onTap: () {
                    _selectTime(context);
                  },
                  child: Row(children: [
                    Text(
                      'Idő: ',
                      style: _biggerFont,
                    ),
                    Container(
                        width: _width / 4,
                        height: _height / 15,
                        alignment: Alignment.center,
                        child: TextFormField(
                          style: _biggerFont,
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _timeController,
                          decoration: InputDecoration(
                            disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            // labelText: 'Time',
                          ),
                        ))
                  ])),
              InkWell(
                  onTap: () {
                    if (recordName != null) {
                      recordDate = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute);
                      createData(recordName, recordType, recordDate);
                      Navigator.pop(context);
                    } else {
                      final snackBar = SnackBar(
                        backgroundColor: Colors.lightBlue,
                        duration: Duration(milliseconds: 1500),
                        content: Text(
                          'please fill in \'Name\'',
                          textAlign: TextAlign.center,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Container(
                      height: 50,
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        color: Colors.white,
                      ),
                      child: IgnorePointer(
                        child: Center(
                          child: Text('Jóváhagyás',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontStyle: FontStyle.italic)),
                        ),
                      ))),
            ])));
  }
}
