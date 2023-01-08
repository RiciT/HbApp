// ignore: unused_import
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'authentication_service.dart';

class CreateHomePage extends StatefulWidget {
  CreateHomePage({Key key}) : super(key: key);

  @override
  _CreateHomePageState createState() => _CreateHomePageState();
}

class _CreateHomePageState extends State<CreateHomePage> {
  final _biggerFont = TextStyle(fontSize: 18.0, color: Colors.white);
  int partyType = 0;
  bool refreshing = false;
  bool isFirstTime = true;
  Map fetchedData;
  List partySnapData;
  List rawPartyData;
  List<int> changed = List<int>.filled(400, 0); //nem 40 xd
  List<List> partyData = [[], [], []];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<List> fetchData() async {
    refreshing = true;
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.airtable.com/v0/appSK4qgSgdCbtUVW/Events'), //fields%5B%5D=Type&fields%5B%5D=Name ?????? https://airtable.com/appSK4qgSgdCbtUVW/api/docs#curl/table:events:list
        headers: {HttpHeaders.authorizationHeader: "Bearer keyCpSbvruShOPMWj"},
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        fetchedData = json.decode(response.body);
        partySnapData = fetchedData['records'];
        return partySnapData;
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album ${response.statusCode}');
      }
    } finally {
      refreshing = false;
    }
  }

  Future deleteData(String id) async {
    final response = await http.delete(
      Uri.parse('https://api.airtable.com/v0/appSK4qgSgdCbtUVW/Events/$id'),
      headers: {HttpHeaders.authorizationHeader: "Bearer keyCpSbvruShOPMWj"},
    );
    if (response.statusCode == 200) {
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to delete album ${response.statusCode}');
    }
  }

  Future<Null> _refresh() {
    return fetchData().then((_future) {
      setState(() => rawPartyData = _future);
    });
  }

  Container separator(double height, Color sepColor) {
    return Container(height: height, color: sepColor);
  }

  Container tilePiece(
      Color color, List<List> data, int index, Duration diffDate) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.white, width: 3),
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      child: Row(children: [
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            data[partyType][index]['Name'].toString() +
                "\n" +
                "a buli kezdete: " +
                data[partyType][index]['Date'].substring(5, 10) +
                " " +
                data[partyType][index]['Date'].substring(11, 16) +
                "\n" +
                (diffDate.inDays > 0
                    ? "hátralévő idő a buliig: "
                    : "elkezdodott ennyi ideje: ") +
                (diffDate.inDays == 0
                        ? ""
                        : diffDate.inDays.toString() + " nap ")
                    .toString() +
                ((diffDate.inHours - diffDate.inDays * 24) == 0
                    ? ""
                    : (diffDate.inHours - diffDate.inDays * 24)
                            .abs()
                            .toString() +
                        " óra") +
                (diffDate.inDays == 0 && diffDate.inHours == 0 ? "most" : ""),
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ]),
    );
  }

  List<Widget> _buildTiles(List<List> data) {
    List<Widget> listOfThings = []..length = data[partyType].length;

    for (int i = 0; i < data[partyType].length; i++) {
      var date = DateTime.parse(data[partyType][i]['Date'])
          .subtract(const Duration(hours: 2));
      var diffDate = date.difference(DateTime.now());
      listOfThings[i] = new Padding(
          padding: EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => {
              setState(() {
                // changed = List<bool>.filled(40, false);
                if (partyType == 0) {
                  if (changed[i] == 0) {
                    changed[i] = 1;
                  } else if (changed[i] == 1) {
                    changed[i] = 0;
                  }
                }
              })
            },
            child: getTile(date, diffDate, data, changed[i], i),
          ));
    }

    return listOfThings;
  }

  Widget getTile(
      DateTime date, Duration diffDate, List<List> data, int c, int index) {
    return c == 0 || partyType != 0
        ? tilePiece(Colors.black, data, index, diffDate)
        : c == 1
            ? Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changed[index] = 2;
                        // partyData[2] = [...partyData[2], partyData[0][index]];
                        // quickSort(partyData[2], 0, partyData[2].length - 1);
                        // log(partyData[2].toString());
                      });
                      // log('pressed $index');
                      final snackBar = SnackBar(
                        backgroundColor: Colors.lightBlue,
                        duration: Duration(milliseconds: 1500),
                        content: Text(
                          'you have applied to ${data[partyType][index]['Name']}',
                          textAlign: TextAlign.center,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blueGrey)),
                    child: Text(
                      'Jóváhagyás',
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                  ),
                ))
            : tilePiece(Colors.blueGrey, data, index, diffDate);
  }

  @override
  Widget build(BuildContext context) {
    List<List<String>> suggestions = [[], [], []];
    if (!refreshing) {
      partyData = [[], [], []];
      for (int i = 0; i < rawPartyData.length; i++) {
        // log(rawPartyData.toString() + " " + rawPartyData.length.toString());
        var date = DateTime.parse(rawPartyData[i]['fields']['Date'])
            .add(Duration(days: 1));
        if ((date).isAfter(DateTime.now())) {
          partyData[rawPartyData[i]['fields']['Type']]
              .add(rawPartyData[i]['fields']);
        } else {
          deleteData(rawPartyData[i]['id']);
        }
      }

      for (int i = 0; i < partyData.length; i++) {
        if (partyData[i].length > 1) {
          quickSort(partyData[i], 0, partyData[i].length - 1);
        }
      }
    }
    for (int i = 0; i < partyData.length; i++) {
      for (int j = 0; j < partyData[i].length; j++) {
        suggestions[i].add(partyData[i][j]['Name']);
      }
    }

    final searchbar = Center(
        child: Container(
            width: MediaQuery.of(context).size.width - 10,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 3),
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            child: Row(
              children: [
                IconButton(
                    color: Color.fromARGB(255, 90, 90, 90),
                    icon: Icon(Icons.search, color: Colors.white),
                    onPressed: null),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 3 / 4,
                    child: new TextField(
                      autofillHints: suggestions[partyType],
                      style: _biggerFont,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: _biggerFont),
                    ),
                  ),
                ),
              ],
            )));

    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
              icon: Icon(Icons.account_circle_outlined, color: Colors.white),
              onPressed: () =>
                  {Navigator.pushNamed(context, "/accountscreen")}),
          centerTitle: true,
          title: Text('HB app', textAlign: TextAlign.center),
          actions: [],
        ),
        body: Container(
            color: Colors.black,
            child: Column(children: [
              ElevatedButton(
                  onPressed: () {
                    context.read<AuthenticationService>().signOut();
                  },
                  child: Text("Sign out")),
              separator(20, Colors.black),
              searchbar,
              separator(20, Colors.black),
              Container(
                  child: Row(
                children: [
                  InkWell(
                    onTap: () => setState(() {
                      partyType = 0;
                    }),
                    child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                            border: Border(
                                right:
                                    BorderSide(color: Colors.white, width: 3))),
                        child: Text('Bulik',
                            style: _biggerFont, textAlign: TextAlign.center)),
                  ),
                  InkWell(
                    onTap: () => setState(() {
                      partyType = 1;
                    }),
                    child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Text('Rendezvények',
                            style: _biggerFont, textAlign: TextAlign.center)),
                  ),
                  InkWell(
                    onTap: () => setState(() {
                      partyType = 2;
                    }),
                    child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                            border: Border(
                                left:
                                    BorderSide(color: Colors.white, width: 3))),
                        child: Text('Upcoming',
                            style: _biggerFont, textAlign: TextAlign.center)),
                  ),
                ],
              )),
              separator(20, Colors.black),
              Expanded(
                  child: RefreshIndicator(
                onRefresh: _refresh,
                color: Colors.black,
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: refreshing ? 3 : partyData[partyType].length,
                  itemBuilder: (context, i) {
                    if (!refreshing) {
                      return _buildTiles(partyData)[i];
                    } else {
                      return Center(
                        child: Column(children: [
                          SizedBox(
                            width: 70,
                            height: 70,
                            child: CircularProgressIndicator(
                              strokeWidth: 4,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.green),
                              backgroundColor: Colors.lightGreen,
                            ),
                          ),
                          separator(20, Colors.black)
                        ]),
                      );
                    }
                  },
                ),
              ))
            ])),
        floatingActionButton: new FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, "/addingscreen");
          },
          backgroundColor: Color.fromARGB(255, 90, 90, 90),
          splashColor: Color.fromARGB(255, 225, 225, 225),
          child: new Icon(Icons.add, color: Colors.white),
        ));
  }
}

void quickSort(var arr, int low, int high) {
  if (low < high) {
    /* pi is partitioning index, arr[pi] is now
           at right place */
    int pi = partition(arr, low, high);

    quickSort(arr, low, pi - 1); // Before pi
    quickSort(arr, pi + 1, high); // After pi
  }
}

int partition(var arr, int low, int high) {
  // pivot (Element to be placed at right position)
  var pivot = arr[high]['Date'];
  //log(pivot);w
  MediaQ

  int i = (low - 1); // Index of smaller element and indicates the
  // right position of pivot found so far

  for (int j = low; j <= high - 1; j++) {
    // If current element is smaller than the pivot
    if (DateTime.parse(arr[j]['Date']).isBefore(DateTime.parse(pivot))) {
      i++; // increment index of smaller element
      var temp = arr[i];
      arr[i] = arr[j];
      arr[j] = temp;
    }
  }
  var temp = arr[i + 1];
  arr[i + 1] = arr[high];
  arr[high] = temp;
  return (i + 1);
}
