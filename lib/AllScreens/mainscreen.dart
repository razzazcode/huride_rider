import 'package:flutter/material.dart';






class MainScreen extends StatefulWidget {



  static const String idScreen = "mainScreen" ;






  @override
  _MainScreenState createState() => _MainScreenState();
}

// this is my new screen if you can see it you are too close soo be careful of the dangers of being too close too it .. thank you

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        title: Text(" Main Screen "),


      ),
    );
  }
}
