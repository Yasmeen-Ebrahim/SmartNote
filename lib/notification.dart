import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'background state.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key,});

  @override
  State<TestPage> createState() => _TestPageState();
}


class _TestPageState extends State<TestPage> {

  sendMessage( title, message) async{
    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': 'key=AAAA7j6oqxo:APA91bEtaxur7EYPZqZlnooc6heVRwTrM2HT59cIE6bYLz898VPGbKtd7JQ8SR7qfHOcTxT1NuPvimYPmOs6Zq0w2XtMs0oEqG2qkwBqmTLH5ByMOr4U9f353QjWqKVFf-Mx7xbYOuL-'
    };
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    var body = {
      "to": "cI6-pHHVRC2kUJmpjRZ7Jn:APA91bEWQDZx10CS2Hi0xqibZREI6ML4ZZ8zHv52j5GtXvZ2p4EjWkYQgfrXO0INcPdFpMp2SgRlt5X_1m6pSLc2DGoTq0Ry6enBpWJFHOpKgztP9YtUcajJ9K3tZvY4nk9Xt5JnGQUP",
      "notification": {
        "title": title,
        "body": message
      },
      "data": {
        "name": "yasmeen",
        "age": "23",
        "college" : "computer science"
      }

    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);


    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
    }
    else {
      print(res.reasonPhrase);
    }
  }
  sendMessageusingTopic( title, message) async{
    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
      'Authorization': 'key=AAAA7j6oqxo:APA91bEtaxur7EYPZqZlnooc6heVRwTrM2HT59cIE6bYLz898VPGbKtd7JQ8SR7qfHOcTxT1NuPvimYPmOs6Zq0w2XtMs0oEqG2qkwBqmTLH5ByMOr4U9f353QjWqKVFf-Mx7xbYOuL-'
    };
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    var body = {
      "to": "/topics/yasmeenEbrahim",
      "notification": {
        "title": title,
        "body": message
      },
      "data": {
        "name": "yasmeen",
        "age": "23",
        "college" : "computer science"
      }

    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);


    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
    }
    else {
      print(res.reasonPhrase);
    }
  }


  gettoken () async {
   String? token =  await FirebaseMessaging.instance.getToken();
   print(token);
  }

  getInitial() async {
    RemoteMessage? message =
    await FirebaseMessaging.instance.getInitialMessage();
    if(message != null) {
      print("==============================terminated state");
    }
    
  }

  @override
  void initState() {

    //get token
    gettoken();

    // send notification (forground state)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if(message.notification != null){
        print("**********************************");
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data);
        print("**********************************");

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${message.notification!.body}")));
      }
    });

    // interact background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if(message.data['type'] == "chat"){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Backgroung(interactbacktitle: '${message.notification!.title}', interactbackbody: '${message.notification!.body}',)));
      }

    });


    //interact terminated
    getInitial();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              MaterialButton(
                child: Text("send message"),
                onPressed: (){
                  sendMessage("Hi" , "Welcome, yasmeen ebrahim");
                },
              ),
              SizedBox(height: 40,),
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: Text("subscribe"),
                onPressed: (){
                  FirebaseMessaging.instance.subscribeToTopic("yasmeenEbrahim");
                },
              ),
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: Text("unsubscribe"),
                onPressed: (){
                  FirebaseMessaging.instance.unsubscribeFromTopic("yasmeenEbrahim");
                },
              ),
              MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                child: Text("send topic"),
                onPressed: (){
                  sendMessageusingTopic("omer", "thank you");
                },
              ),
            ],
          )
        ),
      ),
    );
  }
}

