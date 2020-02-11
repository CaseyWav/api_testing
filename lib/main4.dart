//to do: figure out how to edit header information

//josh = the object representation of our json data

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:api_testing/josh.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Josh> josh;
  String firstName;
  String lastName;

  @override
  void initState() {
    super.initState();
    josh = fetchPost();
  }

  Future<Josh> fetchPost() async {
    final response = await http.get(
        'https://pennstate.pure.elsevier.com/ws/api/516/persons?size=1&apiKey=e1d6aaae-8a61-4e9e-9e1b-e94d11528b61',
        headers: {'Accept': 'application/json'});

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print('code is 200');
      var parsedJson = json.decode(response.body);
      print(parsedJson);
      return Josh.fromJson(parsedJson);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bread acquisition',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.green[200],
        body: SafeArea(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder<Josh>(
                  future: josh,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data.getAll());
                      //print(snapshot.data.Item.ItemName.firstName);
                      print(snapshot.data.items[0].name.firstName);
                      firstName = snapshot.data.items[0].name.firstName;
                      lastName = snapshot.data.items[0].name.lastName;
                      return Column(
                        children: <Widget>[
                          Text('count is ' + snapshot.data.count.toString()),
                          Text(
                              'This person\'s name is ${firstName} ${lastName}'),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      print(snapshot.error.toString());
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    josh = fetchPost();
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: 200,
                      color: Colors.lightBlueAccent[700],
                      width: double.infinity,
                      child: Center(child: Text('Click me for a new josh')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
