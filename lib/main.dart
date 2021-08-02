import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String messageTitle = "Kosong";
  String notificationAlert = "Kosong";
  String token = '';
  TextEditingController textEdit = TextEditingController();

  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    firebaseMessaging.configure(
      onMessage: (message) async {
        setState(() {
          messageTitle = jsonEncode(message);
          notificationAlert = "New Notification Alert";
        });
      },
      onResume: (message) async {
        setState(() {
          messageTitle = jsonEncode(message);
          notificationAlert = "Application opened from Notification";
        });
      },
    );
    firebaseMessaging.getToken().then((token) => setState(() {
          debugPrint(token);
          this.token = token;
          textEdit.text = token;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('token : $token');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Token :'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  TextField(
                    controller: textEdit,
                    maxLines: 5,
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(notificationAlert),
            Text(
              messageTitle,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
