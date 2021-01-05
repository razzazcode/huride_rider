import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:huride_rider/AllScreens/mainscreen.dart';
import 'package:huride_rider/AllScreens/registerationScreen.dart';

import 'AllScreens/loginScreen.dart';

void main() async {

WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();


  runApp(MyApp());
}


DatabaseReference userRef = FirebaseDatabase.instance.reference().child("users");


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HuRide',
      theme: ThemeData(


        fontFamily: "Signatra",
        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: loginScreen.idScreen,
      routes: {

        RegisterationScreen.idScreen: (context) => RegisterationScreen(),

        loginScreen.idScreen: (context) => loginScreen(),

        MainScreen.idScreen: (context) => MainScreen(),


      },


      debugShowCheckedModeBanner: false,


    );
  }
}


