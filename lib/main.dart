import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttercourse/filtring.dart';
import 'package:fluttercourse/homepage.dart';
import 'package:fluttercourse/registeration/signin.dart';
import 'package:fluttercourse/registeration/signup.dart';

import 'categories_collection/addcategory.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if(message.notification != null){
    print("background notification================");
    print(message.notification!.title);
    print(message.notification!.body);
    print(message.data);
    print("background notification================");
  }

}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAoaJeN0Z6EGSZmr7_Vq8YoQhp5Q-WDrhY",
          appId: "1:1023253457690:android:b0ba04eb65413e7be35aa3",
          messagingSenderId: "1023253457690",
          projectId: "fluttercourse-e85f8",
          storageBucket: "fluttercourse-e85f8.appspot.com"
      )
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('===================================User is currently signed out!');
      } else {
        print('===================================User is signed in!');
      }
    });
    super.initState();
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              elevation: 1.0,
              titleTextStyle: TextStyle(color: Colors.blue[700],fontWeight: FontWeight.bold,fontSize: 18),
              iconTheme: IconThemeData(
                  color: Colors.blue[700]
              )
          )
      ),
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.emailVerified ? HomePage() : SigninPage(),
      routes: {
        "Signup" : (context) => SignUpPage(),
        "Signin" : (context) => SigninPage(),
        "Homepage" : (context) => HomePage(),
        "addcategory" : (context) => AddCategory(),
        "filtring" : (context) => Filtring()
      },
    );
  }
}



