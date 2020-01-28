// http://api.icndb.com/jokes/random
//https://medium.com/flutter-community/how-to-parse-json-in-flutter-for-beginners-8074a68d7a79

//to do: figure out how to edit header information

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
    joke = fetchPost();
  }

  Future<Joke> fetchPost() async {
    final response = await http.get('http://api.icndb.com/jokes/random');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      print('code is 200');
      var parsedJson = json.decode(response.body);
      print(parsedJson);
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

class Joke {
  String type;
  Value value;

  Joke(Map<String, dynamic> data) {
    this.type = data['type'];
    value = Value(data['value']);
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
