import 'dart:math';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signalchat_app/models/model.dart';

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SignalList(),
    );
  }
}

class SignalList extends StatefulWidget {
  SignalList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignalListState createState() => new _SignalListState();
}

class _SignalListState extends State<SignalList> {
  Future<List<User>> _getUsers() async {
    var data = await http.get("https://jsonplaceholder.username.com/users");

    var jsonData = json.decode(data.body);
    List<User> users = [];

    for (var u in jsonData) {
      User user = User(u['id'], u['name']);

      users.add(user);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    Color getRandomColor() => Colors.primaries[4];
    return Container(
        child: FutureBuilder(
            future: _getUsers(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("Loading.."),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          splashColor: getRandomColor(),
                          onTap: () {},
                          child: Ink(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: getRandomColor(),
                                child: Text(snapshot.data[index].name
                                    .substring(0, 2)
                                    .toUpperCase()),
                              ),
                              title: Text(snapshot.data[index].name),
                              subtitle: Text(
                                '${snapshot.data[index].name} is on Signal',
                                style: TextStyle(fontSize: 12.0),
                              ),
                              trailing: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[new Text("26 Jan")],
                              ),
                            ),
                          ));
                    });
              }
            }));
  }
}
