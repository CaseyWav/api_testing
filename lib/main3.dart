// http://api.icndb.com/jokes/random
//https://medium.com/flutter-community/how-to-parse-json-in-flutter-for-beginners-8074a68d7a79

//to do: figure out how to edit header information
//construct a custom object
//create sub constructors
//why can I only grab the first 23 people
//it has something weird to do with the size property

//https://pennstate.pure.elsevier.com/en/persons/alan-john-jircitano

// every person object should have:
/*
first name, last name, UNIQUE pureID,

 */

//api key privacy concerns

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String result = 'nothing';
  Future<Joke> joke;

  @override
  void initState() {
    super.initState();
    testing();
    joke = fetchPost();
  }

  void testing() async {
    final response = await http.get(
        'https://pennstate.pure.elsevier.com/ws/api/516/persons?size=1&apiKey=e1d6aaae-8a61-4e9e-9e1b-e94d11528b61',
        headers: {'Accept': 'application/json'});

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print('code is 200 and we are booling');
      print('count is ');
      PersonObject pobj = PersonObject.fromJson(json.decode(response.body));
      print('count is ${pobj.count}');
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<Joke> fetchPost() async {
    final response = await http.get(
        'https://pennstate.pure.elsevier.com/ws/api/516/persons?size=1&apiKey=e1d6aaae-8a61-4e9e-9e1b-e94d11528b61',
        headers: {'Accept': 'application/json'});

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print('code is 200 and we are booling');
      print(response.body);
      var parsedJson = json.decode(response.body);
      print('parse is ' + parsedJson);
      print('next up');

      var nameJson = json.decode(parsedJson['name']);
      var first = nameJson['firstName'];
      print('first name issssss ' + first);

      return Joke(parsedJson);

      //return Post.fromJson(json.decode(response.body));
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
                FutureBuilder<Joke>(
                  future: joke,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data.value.joke);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    joke = fetchPost();
                  }),
                  child: Container(
                    height: 200,
                    color: Colors.blueGrey[200],
                    width: double.infinity,
                    child: Center(child: Text('Click me for a new joke')),
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

class PersonObject {
  int count;
  Items items;

  PersonObject({this.count, this.items});

  factory PersonObject.fromJson(Map<String, dynamic> json) {
    return PersonObject(
      count: json['count'],
      items: Items.fromJson(json['items']),
    );
  }
}

class Items {
  List<dynamic> list;

  Items({this.list});

  factory Items.fromJson(List<dynamic> json) {
    return Items();
  }
}

class ItemsPrimaryData {}

class Name {
  String firstName;
  String lastName;
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class Joke {
  String type;
  var value;

  Joke(Map<String, dynamic> data) {
    this.type = data['type'];
    json.decode(data['value']);
  }
}

class Value {
  int id;
  String joke;

  Value(Map<String, dynamic> data) {
    id = data['id'];
    joke = data['joke'];
  }
}
